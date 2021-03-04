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

% WDMRND
clear all
% Pick some parameters
a   = 1/2 + rand; % bs
ter = 1/4 + rand/4; % ndt
b   = 1/4 + rand/2; % bias
d   = randn; % drift

N = 1e6;   % large N for plotting

% draw samples
tic
    y = wdmrnd(a, ter, b, d, N);
elt = toc;
fprintf('Elapsed time is %.6f seconds (%.3fkHz).\n', elt, (1e-3*N/elt))

fprintf('mean RT = %f\nmean accuracy = %f\n', mean(abs(y)), mean(y>0))

% WDMPDF
% Get histogram
[h0, y0] = hist(y, 1000);
% get bin widths
d0 = y0(2)-y0(1);
% get joint area
a0 = sum(d0*h0);
% rescale bars
c0 = h0./a0;
% compute pdf
tic
    p0 = wdmpdf(y0, a, ter, b, d);
toc
% plot bars
bar(y0, c0)
% plot pdfs
line(y0(y0<0), p0(y0<0), 'color', 'r', 'linewidth', 2)
line(y0(y0>0), p0(y0>0), 'color', 'g', 'linewidth', 2)
xlim([-3 3])
drawnow

% WDMLIKE
% Recover parameters

N = 1e3;   % smaller N for recovery

y = wdmrnd(a, ter, b, d, N);

fprintf('mean RT = %f\nmean accuracy = %f\n', mean(abs(y)), mean(y>0))

objective = @(p)wdmlike(y, p);
start     = [1.0, 0.2, 0.5, 0.0];
options   = struct('Display', 'off');

param = start;
tic
    for ign = 1:3
        param = fminsearch(objective, param, options);
    end
toc
fprintf('objective at start:           %f\n', objective(start))
fprintf('objective at true values:     %f\n', objective([a, ter, b, d]))
fprintf('objective at returned values: %f\n', objective(param))

disp Recovery:
disp([param; a, ter, b, d])
