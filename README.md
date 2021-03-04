# WDM-MEX

Fast MATLAB files for the Wiener diffusion model distribution

These functions require a compiler correctly set up for your 
MATLAB install.  The GNU GSL library can optionally be linked
during compilation.

----------------

## @WIENER CLASS

### Methods for class Wiener

 * WIENER       --- Construct a new object
 * DISP         --- Print the object to console
 * RND          --- Generate random data from the distribution
 * PDF          --- Returns the pdf
 * LOGPDF       --- Returns the log of the pdf
 * LOGJOINTPDF  --- Returns the log of the joint pdf of multiple points

### Static methods

 * DEVIANCE     --- Returns the deviance score
 * ESTIMATE     --- Produces a Wiener object fit to data
 * TESTSUITE    --- Tests the public methods ofthe class

---------------

## +WDM PACKAGE

### Main functions

 *  WDM.WDMRND   --- Random samples from a Wiener diffusion model
 *  WDM.WDMPDF   --- Wiener diffusion model probability density function
 *  WDM.WDMLIKE  --- Negative log-likelihood Wiener diffusion model

### Helper functions

 *  WDM.WDM_VALIDATE  --- Validates input for WDM functions
 *  WDM.WDM_DIALOG    --- Start dialog to compile WDM MEX files
 *  WDM.TEST_MEX      --- Test all files

### C functions

 *  +wdm/wdmrndx.c     --- Compiled and called by WDMRND
 *  +wdm/wdmpdfx.c     --- Compiled and called by WDMPDF
 *  +wdm/wdmlikex.c    --- Compiled and called by WDMLIKE

---------------


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
