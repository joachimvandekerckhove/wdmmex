# wdmmex
MATLAB files for the Wiener diffusion model distribution

These functions require a compiler correctly set up for your 
MATLAB install.  The GNU GSL library can optionally be linked
during compilation.

Main functions:

 *  WDMRND   Random samples from a Wiener diffusion model
 *  WDMPDF   Wiener diffusion model probability density function
 *  WDMLIKE  Negative log-likelihood Wiener diffusion model

Helper functions:

 *  WDM_VALIDATE  Validates input for WDM functions
 *  WDM_DIALOG    Start dialog to compile WDM MEX files
 *  TEST_MEX      Test all files

C functions:

 *  wdmrndx.c     Compiled and called by WDMRND.M
 *  wdmpdfx.c     Compiled and called by WDMPDF.M
 *  wdmlikex.c    Compiled and called by WDMLIKE.M


 Copyright (C) 2004- Joachim Vandekerckhove
 
 This program is free software: you can redistribute it and/or modify it
 under the terms of the GNU General Public License as published by the
 Free Software Foundation, either version 3 of the License, or (at your
 option) any later version.
 
 This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 General Public License for more details.
 
 You can obtain a copy of the GNU General Public License via
 <http://www.gnu.org/licenses/>.
