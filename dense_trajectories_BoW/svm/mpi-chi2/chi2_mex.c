#include <mex.h>
#include "chi2double.h"

/*
  computes the chi² distance between the input arguments
  d(X,Y) = sum ((X(i)-Y(i))²)/(X(i)+Y(i))
*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	double *vecA, *vecB, *pA,*pB;
	double *dist, d1,d2;
	unsigned int i,j,ptsA,ptsB,dim,k,kptsA,kptsB;

	if (nrhs == 0)
	{
		mexPrintf("Usage: d = chi2_mex(X,Y);\n");
		mexPrintf("where X and Y are matrices of dimension [dim,npts]\n");
		mexPrintf("\nExample\n a = rand(2,10);\n b = rand(2,20);\n d = chi2_mex(a,b);\n");
		return;
	}

	if (nrhs != 2){
		mexPrintf("at least two input arguments expected.");
		return;
	}

	if (mxGetNumberOfDimensions(prhs[0]) != 2 || mxGetNumberOfDimensions(prhs[1]) != 2)
	{
		mexPrintf("inputs must be two dimensional");
		return;
	}

	vecA = (double *)mxGetPr(prhs[0]);
	vecB = (double *)mxGetPr(prhs[1]);

	ptsA = mxGetN(prhs[0]);
	ptsB = mxGetN(prhs[1]);
	dim = mxGetM(prhs[0]);

	if (dim != mxGetM(prhs[1]))
	{
		mexPrintf("Dimension mismatch");
		return;
	}

	plhs[0] = mxCreateDoubleMatrix(ptsA,ptsB,mxREAL);
	dist = (double *)mxGetPr(plhs[0]);

	chi2_distance_double(dim,ptsB,vecB,ptsA,vecA,dist);
	
	return;
}
