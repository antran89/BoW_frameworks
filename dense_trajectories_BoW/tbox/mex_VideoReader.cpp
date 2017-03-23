/*
 * Copyright (C) 2014 Tran Lam An.
 * This code is for research, please do not distribute it.
 *
 */

/*  
 * This mex function to get information of a video
 *
 */

#include <mex.h>
#include <matrix.h>
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <sys/stat.h>

#include <stdio.h>
#include <string>
#include <cstring>
#include <cstdlib>

using namespace cv;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs != 1) {
        mexPrintf( "Input: videoFileName \n" );
        return;
    }
    
    if (mxGetClassID(prhs[0]) != mxCHAR_CLASS){
    	mexPrintf("first input arguments must be in string \n");
    	return;
    }
    
    char video[500];
    //video = (char*) mxGetData(prhs[0]);
    mxGetString(prhs[0], video, mxGetN(prhs[0]) + 1);
    
	VideoCapture capture(video);

	if (!capture.isOpened()) { 
		mexPrintf( "Could not initialize capturing... video %s\n", video );
		return;
	}
    
    // create fieldnames for the mex struct, this function support 4 fieldnames
    int numFields = 4;
    const char* fieldnames[numFields];
    for (int i = 0; i < numFields; i++)
        fieldnames[i] = new char[20];
    memcpy((char*) fieldnames[0], "Width", sizeof("Width"));
    memcpy((char*) fieldnames[1], "Height", sizeof("Height"));
    memcpy((char*) fieldnames[2], "FrameRate", sizeof("FrameRate"));
    memcpy((char*) fieldnames[3], "NumberOfFrames", sizeof("NumberOfFrames"));
    
    // create output matrix
    //mexPrintf("number of frames %d\n", counter);
    plhs[0] = mxCreateStructMatrix(1, 1, numFields, fieldnames);
    
    // assign the field values
    // width
    mxArray *width = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL);
    mxSetData(width, mxMalloc(sizeof(double)));
    double* data = (double*) mxGetData(width);	
    *data = capture.get(CV_CAP_PROP_FRAME_WIDTH);
    mxSetFieldByNumber(plhs[0], 0, 0, width);
    
    // height
    mxArray *height = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL);
    mxSetData(height, mxMalloc(sizeof(double)));
    data = (double*) mxGetData(height);	
    *data = capture.get(CV_CAP_PROP_FRAME_HEIGHT);
    mxSetFieldByNumber(plhs[0], 0, 1, height);
    
    // Frame Rate
    mxArray *fps = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL);
    mxSetData(fps, mxMalloc(sizeof(double)));
    data = (double*) mxGetData(fps);	
    *data = capture.get(CV_CAP_PROP_FPS);
    mxSetFieldByNumber(plhs[0], 0, 2, fps);
    
    // Number of frames
    mxArray *numFrames = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL);
    mxSetData(numFrames, mxMalloc(sizeof(double)));
    data = (double*) mxGetData(numFrames);	
    *data = capture.get(CV_CAP_PROP_FRAME_COUNT);
    mxSetFieldByNumber(plhs[0], 0, 3, numFrames);
    
    // deallocate memory for the structure
    for (int i = 0; i < numFields; i++)
        delete fieldnames[i];
    
}

