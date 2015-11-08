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


#ifdef WITH_GSL
#include <gsl/gsl_rng.h>
#endif
        
/* For diffusion: */
#define pi 3.14159265358979324

/* Function definitions */
#ifdef WITH_GSL
void drawOne(double *y, double a, double ter, double b, double v, gsl_rng *r);
#else
#pragma message ( "\n\n   Compiling without GSL results in reduced efficiency.\n   Add -DWITH_GSL flag or see HELP.\n" )
void drawOne(double *y, double a, double ter, double b, double v);
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *a, *t0, *b, *d, *y, *s;
    int N, i;
    
    a  = mxGetPr(prhs[0]);
    t0 = mxGetPr(prhs[1]);
    b  = mxGetPr(prhs[2]);
    d  = mxGetPr(prhs[3]);
    s  = mxGetPr(prhs[4]);
    
    N = mxGetNumberOfElements(prhs[0]);
    /* mexPrintf("N = %i\n", N); */
    
    plhs[0] = mxCreateDoubleMatrix(N, 1, mxREAL);
    y = mxGetPr(plhs[0]);
    
#ifdef WITH_GSL
    gsl_rng *rng = gsl_rng_alloc(gsl_rng_taus);
	gsl_rng_set(rng, (int)*s);
    /* mexPrintf("GSL seed = %i\n", (int)*s); */
    
	for (i=0; i<N; ++i)
		drawOne(y+i, *(a+i), *(t0+i), *(b+i), *(d+i), rng);

	gsl_rng_free (rng);
#else
    
//    srand(0);
    srand((unsigned int)*s);
    
	for (i=0; i<N; i++)
		drawOne(y+i, *(a+i), *(t0+i), *(b+i), *(d+i));
        
#endif
	return ;
}

#ifdef WITH_GSL
void drawOne(double *y, double a, double ter, double b, double v, gsl_rng *r)
{
    double dt=1e-15,tau=.1,D=.005,totaltime,startpos,ndrt,z,
		zz,Aupper,Alower,radius,lambda,F,prob,tt,dir_,l,s1,s2,tnew,t_delta;
    int uu,i;
    bool finish;
    
    a /= 10.0;
    v /= 10.0;
    z = a * b;
        
        finish = false ;
        totaltime = 0.0 ;
        startpos  = 0.0 ;
        Aupper    = a-z ;
        Alower    =  -z ;
        radius = fmin( fabs(Aupper) , fabs(Alower) ) ;
        
        while ( !finish ) {
            if (v==0){
                lambda = 0.25*D*pi*pi/(radius*radius) ;
                F = 1.0 ;
                prob = 0.5 ;
            } else {
                lambda = 0.25*v*v/D + 0.25*D*pi*pi/(radius*radius) ;
                F = D*pi/(radius*v) ;
                F = F*F/(1.0+F*F) ;
                prob = exp(radius*v/D) ;
                prob = prob/(1.0+prob) ;
            }
            dir_ = gsl_rng_uniform(r)<prob ? 1.0 : -1.0 ;
            l  = -1.0 ;
            s2 =  0.0 ;
            
            while (s2>l)
            {
                s2 = gsl_rng_uniform(r);
                s1 = gsl_rng_uniform(r);
                tnew = 0.0 ;
                t_delta = 0.0 ;
                uu = 0 ;
                
                while ( (fabs(t_delta)>dt) | (!uu) )
                {
                    tt = 2.0*++uu+1.0 ;
                    t_delta = tt * ( uu%2 ? -1.0 : 1.0 ) * pow( s1 , (F*tt*tt) ) ;
                    tnew += t_delta ;
                }
                
                l = 1.0 + pow(s1,-F) * tnew ;
            }/*end while (s2>l) */
            
            totaltime += fabs(log(s1))/lambda ;
            dir_ = startpos + dir_*radius ;
            
            if (dir_+dt>Aupper)
            {
                *y = totaltime + ter ;
                finish = true ;
            }
            else
            {
                if (dir_-dt<Alower)
                {
                    *y = -(totaltime + ter) ;
                    finish = true ;
                }
                else
                {
                    startpos = dir_ ;
                    radius = fmin(fabs(Aupper-startpos),fabs(Alower-startpos)) ;
                }
            }
        } /*end while (!finish) */
    
}
#else
void drawOne(double *y, double a, double ter, double b, double v)
{
    double dt=1e-15,tau=.1,D=.005,totaltime,startpos,ndrt,z,
		zz,Aupper,Alower,radius,lambda,F,prob,tt,dir_,l,s1,s2,tnew,t_delta;
    int uu,i;
    bool finish;
    
    a /= 10.0;
    v /= 10.0;
    z = a * b;
                    
        finish = false;
        totaltime=0;
        startpos=0;
        Aupper=a-z;
        Alower=-z;
        radius=fmin(fabs(Aupper),fabs(Alower));
        
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
            
            totaltime+=absol(log(s1))/lambda;
            dir_=startpos+dir_*radius;
            
            if (dir_+dt>Aupper)
            {
                *y = totaltime + ter ;
                finish = true;
            }
            else
            {
                if (dir_-dt<Alower)
                {
                    *y = -(totaltime + ter);
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
#endif
