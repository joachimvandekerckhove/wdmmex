/*
 *  Name: wemLogLikelihoodMexFile.c
 *
 *     Computes the LOGPDF of a Wiener diffusion first passage time
 *     distribution.
 *     MATLAB call: p = wdmpdfx(y, d, a, t, b);
 *
 *     Parameter a is the boundary separation, t the nondecision time (in
 *     seconds), b the relative bias (as a proportion) and d the drift
 *     rate. y is the data (in seconds), with lower boundary hits coded as
 *     negative values. p is the probability density at y.
 *
 *
 *  Copyright (C) 2004- Joachim Vandekerckhove
 *  Author: Joachim Vandekerckhove
 *          Department of Cognitive Sciences
 *          University of California, Irvine
 *   email: joachim@uci.edu
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You can obtain a copy of the GNU General Public License via
 * <http://www.gnu.org/licenses/>.
 */

#include <stdlib.h>
#include <math.h>
#include <mex.h>
#include <matrix.h>
#include <tmwtypes.h>
#include "wdm.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *y,
           *f,
           v = mxGetScalar(prhs[1]), 
           a = mxGetScalar(prhs[2]), 
           h = mxGetScalar(prhs[3]), 
           b = mxGetScalar(prhs[4]);
    
    int r = mxGetM(prhs[0]),
        c = mxGetN(prhs[0]);
        
    y = mxGetPr(prhs[0]);
    
    plhs[0] = mxCreateDoubleMatrix(r, c, mxREAL);
    
    f = mxGetPr(plhs[0]);
    
    for (int i = 0; i<r*c; i++)
        *(f+i) = logpdfdif(
                fabs(*(y+i)) - h,
                *(y+i)>0,
                v,
                a,
                b);
}
