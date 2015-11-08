% WDMRND  Random samples from a Wiener diffusion model (MEX)
%
%  y = WDMRND(a, t, b, d, [N]); with a, t, b, d all scalars or Nx1 vectors.
%  N is an optional size vector, which is valid only if all other
%  parameters are scalars.
%
%  Parameter a is the boundary separation, t the nondecision time (in 
%  seconds), b the relative bias (as a proportion) and d the drift rate.
%  y is the data (in seconds), with lower boundary hits coded as negative 
%  values.
%
%  If a compiled MEX-file for this function is not on the path, a
%  compilation dialog will begin.
%
%  See also WDMPDF, WDMLIKE.

% This function is a wrapper and helps to compile binaries for your system
% if necessary. You may want to edit this to set the GSL path.

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


function y = wdmrnd(varargin)

if wdm_dialog(mfilename)
    return
end

[a, t, b, d] = wdm_validate(mfilename, varargin{:});

seed = 1e6 * rand;
y = reshape(wdmrndx(a, t, b, d, seed), size(a));
