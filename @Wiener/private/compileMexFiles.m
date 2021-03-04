% COMPILEMEXFILES  Compile the Wiener diffusion mex files

% This function is a helper to compile binaries for your system if
% necessary. Do not edit.

%{
  Copyright (C) 2006- Joachim Vandekerckhove
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

function compileMexFiles(obj)

    for mexFile = { 'wdmRandomMexFile.c'           ...
                    'wdmDevianceMexFile.c'         ...
                    'wdmDensityMexFile.c'          ...
                    'wdmLogJointDensityMexFile.c'  ...
                    'wdmLogLikelihoodMexFile.c'  }
        compileOneMexFile(obj, mexFile{1});
    end

end


function compileOneMexFile(obj, ccFileName)

    classPath = fileparts(which(class(obj)));
    
    outputDirectory = fullfile(classPath, 'private');
    
    [~, baseName, ~] = fileparts(ccFileName);
    
    if ~exist(fullfile(outputDirectory, [baseName '.' mexext]), 'file')
        fprintf('compiling - %s/%-7s --- \n', outputDirectory, ccFileName);
        
        mex(fullfile(outputDirectory, ccFileName), ...
            '-outdir', outputDirectory)
    end
end

