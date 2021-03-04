/* 
 *   Name: wdm.h
 *   Copyright (C) 2004- Joachim Vandekerckhove
 *   Author: Joachim Vandekerckhove
 *           Department of Cognitive Sciences
 *           University of California, Irvine
 *    email: joachim@uci.edu
 * 
 *  This program is free software: you can redistribute it and/or modify it 
 *  under the terms of the GNU General Public License as published by the 
 *  Free Software Foundation, either version 3 of the License, or (at your
 *  option) any later version.
 *  
 *  This program is distributed in the hope that it will be useful, but 
 *  WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
 *  General Public License for more details.
 * 
 *  You can obtain a copy of the GNU General Public License via 
 *  <http://www.gnu.org/licenses/>.
 */

#include <stdlib.h>
#include <math.h>
#include <mex.h>
#include <matrix.h>
#include <tmwtypes.h>

#define PI 3.14159265358979324
#define max(x, y) ((x > y) ? x : y)

#ifndef DEBUG
bool DEBUG = 0;
#else
bool DEBUG = 1;
#endif

double pdfdif(double t, bool x, double v, double a, double b);
double logpdfdif(double t, bool x, double v, double a, double b);
bool checkPdfdifParameters(double v, double a, double b);

/* The main function for the three-parameter diffusion model */
double pdfdif(double t, bool x, double v, double a, double b)
{
	double tt, kl, ks, g, p, err, inva=1/a;
	int k, K;
	
	if (!checkPdfdifParameters(v, a, b)) {
		if (DEBUG) mexPrintf("Returning 0 because of bad parameters: v = %f; a = %f; b = %f.\n", v, a, b);
		return 0;
	}

	if (t < 1e-3) {
		if (DEBUG) mexPrintf("Returning 0 because t = %f < 1e-3.\n", t);
		return 0;
	}
	
	tt = t * inva * inva; 
	err = 1e-7;
	
	if (x) {
		b = 1 - b;
		v *= -1;
	}
	
	kl = sqrt(-2 * log(PI * tt * err) / (PI * PI * tt));
	ks = 1 + sqrt(-2 * tt * log(2 * sqrt(2 * PI * tt) * err));
	ks = max(ks, sqrt(tt));
	kl = max(kl, 1 / (PI * sqrt(tt)));
	
	g = ks + 1 - kl; 
	
	p = 0;
	if (g < 0) {
		K = (int)ceil(ks);
		for (k =- (int)floor(0.5 * K); k <= (int)ceil(0.5 * K); k++)
			p += (b + 2 * k ) * exp(-0.5 * ((b + 2 * k) * (b + 2 * k)) / tt);
		p /= sqrt(2 * PI * tt * tt * tt);
	}
	else {
		K = (int)ceil(kl);
		for (k = 1; k <= K; k++)
			p += k * exp(-0.5 * (k * k) * (PI * PI) * tt) * sin(k * PI * b);
		p *= PI;
	}
	if (DEBUG && !p)
		mexPrintf("First factor of likelihood is zero: v = %f; a = %f; b = %f.\n", v, a, b);
     
	return p * exp(-v * a * b - 0.5 * (v * v) * t) * (inva * inva);
}

/* The log likelihood function for the three-parameter diffusion model */
double logpdfdif(double t, bool x, double v, double a, double b)
{
	double tt, kl, ks, g, p, err, inva=1.0/a;
	int k, K;
	
	if (!checkPdfdifParameters(v, a, b)) {
		if (DEBUG) mexPrintf("Returning -Inf because of bad parameters: v = %f; a = %f; b = %f.\n", v, a, b);
		return (-mxGetInf());
	}

	if (t<1e-3) {
		if (DEBUG) mexPrintf("Returning -Inf because t = %f < 1e-3. ", t);
		if (DEBUG) mexPrintf("Parameters: v = %f; a = %f; b = %f.\n", v, a, b);
		return (-mxGetInf());
	}
    
	tt = t * (inva * inva); 
	err = 1e-7;
	
	if (x) {
		b = 1 - b;
		v *= -1;
	}
	
	kl = sqrt(-2 * log(PI * tt * err) / (PI * PI * tt));
	ks = 1 + sqrt(-2 * tt * log(2 * sqrt(2 * PI * tt) * err));
	ks = max(ks, sqrt(tt));
	kl = max(kl, 1 / (PI * sqrt(tt)));
	
	g = ks+1-kl; 
	
	p = 0;
	if (g < 0) {
		K = (int)ceil(ks);
		for (k =- (int)floor(0.5 * K); k <= (int)ceil(0.5 * K); k++)
			p += (b + 2 * k) * exp(-0.5 * ((b + 2 * k) * (b + 2 * k)) / tt);
		p /= sqrt(2 * PI * tt * tt * tt);
	}
	else {
		K = (int)ceil(kl);
		for (k = 1; k <= K; k++)
			p += k * exp(-0.5 * (k * k) * (PI * PI) * tt) * sin(k * PI * b);
		p *= PI;
	}
	if (DEBUG && !p)
		mexPrintf("Returning -Inf because first factor of likelihood is zero: v = %f; a = %f; b = %f.\n", v, a, b);

	return log(p) - v * (a * b + 0.5 * v * t) - 2 * log(a);
}

bool checkPdfdifParameters(double v, double a, double b)
{
	if (a < .001)  return 0;
	if (b > .999)  return 0;
	if (b < .001)  return 0;
	return 1;
}
