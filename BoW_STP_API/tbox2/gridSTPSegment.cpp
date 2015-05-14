/*
 * Copyright (C) 2014 Tran Lam An.
 * This code is for research, please do not distribute it.
 *
 */

#include <algorithm>
#include <mex.h>
#include <matrix.h>
#include <iostream>
#include <stdint.h>

int height;
int width;
int nrFrames;
int N;          // number of trajectories

/**
 * check if index for point(i, j, k) from cube segMap is valid?
 * index i, j, k is 1-based index of pixel at (i, j, k) position of video
 * segmentation
 */
inline bool isValidIndex(int ind_i, int ind_j, int ind_k)
{
    if (ind_i < 1 || ind_i > height)
        return false;
    if (ind_j < 1 || ind_j > width)
        return false;
    if (ind_k < 1 || ind_k > nrFrames)
        return false;
    return true;
}

/**
// get index for point(i, j, k) from cube segMap
// index i, j, k is 1-based index of pixel at (i, j, k) position of video
// segmentation
 */
inline int getIndex(int ind_i, int ind_j, int ind_k)
{
	return (ind_i - 1) + (ind_j - 1)*height + (ind_k - 1)*height*width; 
}

/**
*	mex function for determining foreground segmentation of dense trajectories from salMap
*	help me with this segmentation
*	input: 	in[0] == salMap (uint8 matrix with height*width*frames)
*			in[1] == traj (matrix of N trajectories with N*2*tracj, with traj.x, traj.y)
*   output: segment label of traj which is 0 for background
*										   1 for foreground
*
*/

/**
 * @brief mexFunction for determining which grid of spatial temporal grid that dense trajectories belong to
 * input: in[0] == stp map (uint8 matrix with height*width*frames)
 *        in[1] == traj (matrix of N trajectories with N*2*tracj, with traj.x, traj.y)
 *          shape of this matrix is [30*N]
 *        in[2] == last frame (matrix [N*1])
 *
 * output: matrix [N*1], each row indicate which grid that this trajectory belongs  to
 *          if 0, it does not belong to any svx
 *          if >0, yes, its supervoxel index
 *
 */
void mexFunction(int nlhs, mxArray *out[], int nrhs, const mxArray *in[]) {
	if (nrhs < 3) {
		mexPrintf("Need 3 input arguments \n");
		return;
	}
    
     if (mxGetClassID(in[0]) != mxUINT8_CLASS){
        mexPrintf("stp_map arguments must be in uint8 \n");
        return;
     }
    if (mxGetClassID(in[1]) != mxUINT16_CLASS){
        mexPrintf("trajectories arguments must be in uint16 \n");
    	return;
    }
    if (mxGetClassID(in[2]) != mxUINT16_CLASS){
        mexPrintf("last frame arguments must be in uint16 \n");
    	return;
    }
    
    
    // number of trajectories and length of trajectories
    N = mxGetN(in[1]);
    int track_length = mxGetM(in[1])/2;
    if (N != mxGetM(in[2]))
    {
        mexPrintf("Something wrong with inputs\n");
        return;
    }
    
    // to get dimensions of stp_map
    const int* dim = mxGetDimensions(in[0]);
    height = dim[0];
    width = dim[1];
    nrFrames = dim[2];

    //mexPrintf(" %d %d %d %d", height, width, nrFrames, N);
    
    // create output matrix
    out[0] = mxCreateNumericMatrix(0, 0, mxUINT32_CLASS, mxREAL);
    mxSetM(out[0], N);
    mxSetN(out[0], 1);
    mxSetData(out[0], mxMalloc(sizeof(uint32_t) * N));
    uint32_t* segment = (uint32_t*) mxGetData(out[0]);	// segment label for each trajectories

    uint8_t* stp_map = (uint8_t *) mxGetData(in[0]);
    uint16_t* traj = (uint16_t*) mxGetData(in[1]);
    uint16_t* lastFrame = (uint16_t*) mxGetData(in[2]);

    int ind_i, ind_j, ind_k, ind, traj_ind, j;
    int* tmp_array = new int[track_length];
    traj_ind = 0;
    // loop through all features
    for (int i = 0; i < N; i++) {
        for (j = 0; j < track_length; j++) {
            ind_j = traj[traj_ind++];        // j for width
            ind_i = traj[traj_ind++];        // i for height
            ind_k = lastFrame[i] - track_length + j + 1;    // ind_k is 1-based index
            if (!isValidIndex(ind_i, ind_j, ind_k))
                continue;
    		ind = getIndex(ind_i, ind_j, ind_k);
            tmp_array[j] = stp_map[ind];
    	}

        // TODO: processing tmp_array here
        std::sort(tmp_array, tmp_array + track_length);
        // count maximum times it appear and return its value
        int cnt = 1, maxCnt = 0, maxValue;
        for (j = 1; j < track_length; j++)
            if (tmp_array[j] != tmp_array[j-1])
            {
                if (maxCnt < cnt) // update maximum values
                {
                    maxCnt = cnt;
                    maxValue = tmp_array[j-1];
                }
                cnt = 1;    // reset counter
            }
            else cnt++;
        // update for last elemnt in array
        if (maxCnt < cnt) // update maximum values
        {
            maxCnt = cnt;
            maxValue = tmp_array[j-1];
        }

        // assign supervoxel index, if its count >= a threshold
        segment[i] = maxValue;
    }
    
    // release memory
    delete[] tmp_array;
/*    
    // testing some functions
    const int segMapDim[3] = {height, width, nrFrames};
    out[1] = mxCreateLogicalArray(3, segMapDim);
    mxSetData(out[1], segMap);
    
    // test getIndex function and mxCalcSingleSubscript
    int subscript[3] = {34, 45, 37};
    mexPrintf("mxCalcSingleSubscript function gives index %d\n", mxCalcSingleSubscript(out[1], 3, subscript));
    mexPrintf("getIndex function gives index %d\n", getIndex(35, 46, 38));
    
    // test getIndexOfTraj function and mxCalcSingleSubscript
    int subs[2] = {34, 45};
    mexPrintf("mxCalcSingleSubscript function gives index %d\n", mxCalcSingleSubscript(in[1], 2, subs));
    mexPrintf("getIndexOfTraj function gives index %d\n", getIndexOfTraj(34, 45));
 */
}
