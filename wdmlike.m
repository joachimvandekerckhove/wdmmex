% WDMLIKE  Negative log-likelihood Wiener diffusion model (MEX)
%
%  L = WDMLIKE(y, param) with y Nx1 and param Nx4 or 1x4.
%
%  Parameter a is the boundary separation, t the nondecision time (in 
%  seconds), b the relative bias (as a proportion) and d the drift rate.
%  param is [a b t d]. y is the data (in seconds), with lower boundary hits 
%  coded as negative values.  l is the aggregate negative log-likelihood.
%
%  If a compiled MEX-file for this function is not on the path, a
%  compilation dialog will begin.
% 
%  See also WDMRND, WDMPDF.

% This function is a wrapper and helps to compile binaries for your system
% if necessary.

% Note that the MEX-file does not validate input, so it cannot be called
% directly.

%{
  Copyright (C) 2004- Joachim Vandekerckhove
  Author: Joachim Vandekerckhove
          Department of Cognitive Sciences
          University of California, Irvine
   email: joachim@uci.edu
 
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
%}

function l = wdmlike(varargin)

if wdm_dialog(mfilename)
    return
end

[y, p] = wdm_validate(mfilename, varargin{:});

l = wdmlikex(y, p);

