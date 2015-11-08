function err = wdm_dialog(filename)
% WDM_DIALOG Start dialog to compile WDM MEX files

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

err = ~exist(sprintf('%sx.%s', filename, mexext), 'file');
if ~err, return, end

fprintf('MATLAB failed to locate the binary file %sx.%s.\n', filename, mexext);

if ispc
    GSL_lib_dir = 'C:\gnuwin32\lib\';
    GSL_include_dir = 'C:\gnuwin32\include\';
else
    GSL_lib_dir = '/usr/include';
    GSL_include_dir = '/usr/include';
end

if usejava('desktop')
    fprintf(['Do you want to:\n', ...
        '  a) <a href="matlab:fprintf(''Calling mex... '');mex ''%s'';disp(''done.'')">Compile</a> a binary for your system\n', ...
        '  b) Compile a binary and <a href="matlab:fprintf(''Calling mex... '');', ...
        'mex(''%s'', ''-L%s'', ''-lgsl'', ''-lgslcblas'', ''-lm'', ''-I%s'', ''-DWITH_GSL'');', ...
        'disp(''Done!'')">link to GSL</a> (requires GSL)\n', ...
        '  c) Run <a href="matlab:mex(''-setup'')">mex -setup</a> first\n', ...
        '  d) <a href="matlab:disp(''mex(''''%s'''', ''''-L%s'''', ''''-lgsl'''', ''''-lgslcblas'''', ''''-lm'''', ''''-I%s'''', ''''-DWITH_GSL'''')'');">Display</a> the GSL mex call\n'], ...
        which([filename 'x.c']), ...
        which([filename 'x.c']), GSL_lib_dir, GSL_include_dir, ...
        which([filename 'x.c']), GSL_lib_dir, GSL_include_dir)
else
    fprintf('Attempting to compile for your system. MEX may ask for your input.\n')
    fprintf('Calling mex. If you do not have the GSL installed in %s and %s, this will throw an error.\n', GSL_lib_dir, GSL_include_dir)
    fprintf('If it does, either edit %s.m or call  mex ''%s''  from the command line.\n', [filename], which([filename 'x.c']))
    mex(which([filename 'x.c']), ['-L' GSL_lib_dir], '-lgsl', '-lgslcblas', '-lm', ['-I' GSL_include_dir], '-DWITH_GSL')
    disp('Success!')
end
disp('If compilation was successful, try running your program again.')

end
