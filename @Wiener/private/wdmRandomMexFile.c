/*
 *  Name: wdmrndx.c
 *
 *     Generates random variates from a Wiener diffusion first passage
 *     time distribution.
 *     MATLAB call: y = wdmrndx(a, t, b, d);
 *
 *     Parameter a is the boundary separation, t the nondecision time (in
 *     seconds), b the relative bias (as a proportion) and d the drift
 *     rate. y is the data (in seconds), with lower boundary hits coded as
 *     negative values.
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
#include <time.h>

/* For diffusion: */
#define pi 3.14159265358979324

/* Function definitions */
void drawOne(double *y, double v, double a, double h, double b);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *y,
           v = mxGetScalar(prhs[0]), 
           a = mxGetScalar(prhs[1]), 
           h = mxGetScalar(prhs[2]), 
           b = mxGetScalar(prhs[3]),
           s = mxGetScalar(prhs[5]);
           
    int N = (int) mxGetScalar(prhs[4]);
    
    srand((unsigned int)s);
    
    plhs[0] = mxCreateDoubleMatrix(N, 1, mxREAL);
    
    y = mxGetPr(plhs[0]);
    
    for (int i=0; i<N; i++)
        drawOne(y+i, v, a, h, b);
    
    return ;
}

void drawOne(double *y, double v, double a, double h, double b)
{
    double dt=1e-15,tau=.1,D=.005,totaltime,startpos,ndrt,z,
            zz,Aupper,Alower,radius,lambda,F,prob,tt,dir_,l,s1,s2,tnew,t_delta;
    int uu,i;
    bool finish;
    
    a /= 10.0;
    v /= 10.0;
    z = a * b;
    
    finish    = false;
    totaltime = 0;
    startpos  = 0;
    Aupper    = a-z;
    Alower    = -z;
    radius    = fmin(fabs(Aupper),fabs(Alower));
    
    while (!finish)
    {
        if (v==0){
            lambda = 0.25*D*pi*pi/(radius*radius);
            F=1;
            prob = .5;
        } else {
            lambda = 0.25*v*v/D + 0.25*D*pi*pi/(radius*radius);
            F=D*pi/(radius*v);
            F=F*F/(1+F*F);
            prob=exp(radius*v/D);
            prob=prob/(1+prob);
        }
        dir_= (rand()/(double)RAND_MAX)<prob ? 1 : -1;
        l=-1;
        s2=0;
        
        while (s2>l)
        {
            s1 = 0.00001 + 0.99998 *(rand()/(double)RAND_MAX);
            s2 = 0.00001 + 0.99998 *(rand()/(double)RAND_MAX);
            tnew=0;
            t_delta=0;
            uu=0;
            
            while ((fabs(t_delta)>dt) || (!uu))
            {
                tt = 2*++uu+1;
                t_delta = tt * (uu%2?-1:1) * pow(s1,(F*tt*tt));
                tnew += t_delta;
            }
            
            l = 1 + pow(s1,-F) * tnew;
        }/*end while (s2>l) */
        
        totaltime += fabs(log(s1))/lambda;
        dir_=startpos+dir_*radius;
        
        if (dir_+dt>Aupper)
        {
            *y = totaltime + h ;
            finish = true;
        }
        else
        {
            if (dir_-dt<Alower)
            {
                *y = -(totaltime + h);
                finish=true;
            }
            else
            {
                startpos=dir_;
                radius=fmin(fabs(Aupper-startpos),fabs(Alower-startpos));
            }
        }
    } /*end while (!finish) */
    
}
