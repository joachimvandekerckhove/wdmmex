function varargout = wdm_validate(fn, varargin)
% WDM_VALIDATE  Validates input for WDM functions

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

switch fn
    case 'wdmrnd'
        if nargin < 5 || nargin > 6
            throwAsCaller(MException(sprintf('wdm:%s:insufficientInput', fn), ...
                'Wrong number of input arguments to %s.', fn))
        end
        
        a = varargin{1};
        t = varargin{2};
        b = varargin{3};
        d = varargin{4};
        
        na = numel(a);
        nt = numel(t);
        nb = numel(b);
        nd = numel(d);
        
        if nargin==6
            N = varargin{5};
            if any(N~=fix(N)) || any(N < 0)
                throwAsCaller(MException(sprintf('wdm:%s:inconsistentN', fn), ...
                    'Fifth input argument to wdmrnd (N) should be a positive integer.')                )
            end
            if isscalar(N)
                N = [N 1];
            end
        else
            [N, l] = max([na, nt, nb, nd]);
            param = 'atbd';
            pnm = param(l);
        end
        
        aim = na == N;
        tim = nt == N;
        bim = nb == N;
        dim = nd == N;
        
        
        if aim
            msz = size(a);
        elseif tim
            msz = size(t);
        elseif bim
            msz = size(b);
        elseif dim
            msz = size(d);
        else
            if isscalar(a) && isscalar(t) && isscalar(b) && isscalar(d)
                msz = [N 1];
            else
                throwAsCaller(MException(sprintf('wdm:%s:inconsistentN', fn), ...
                    'Fifth input argument to wdmrnd is only valid if all inputs are scalars.'))
            end
        end
        
        if aim
            ra = a;
        elseif isscalar(a)
            ra = repmat(a, msz);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeA', fn), ...
                'Size of parameter a does not match that of %s.', pnm))
        end
        
        if tim
            rt = t;
        elseif isscalar(t)
            rt = repmat(t, msz);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeT', fn), ...
                'Size of parameter t does not match that of %s.', pnm))
        end
        
        if bim
            rb = b;
        elseif isscalar(b)
            rb = repmat(b, msz);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeB', fn), ...
                'Size of parameter b does not match that of %s.', pnm))
        end
        
        if dim
            rd = d;
        elseif isscalar(d)
            rd = repmat(d, msz);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeD', fn), ...
                'Size of parameter d does not match that of %s.', pnm))
        end
                
        varargout = {ra rt rb rd};
        
    case 'wdmpdf'
        if nargin ~= 6
            throwAsCaller(MException(sprintf('wdm:%s:insufficientInput', fn), ...
                'Wrong number of input arguments to %s.', fn))
        end
        
        y = varargin{1};
        a = varargin{2};
        t = varargin{3};
        b = varargin{4};
        d = varargin{5};
        
        ny = numel(y);
        na = numel(a);
        nt = numel(t);
        nb = numel(b);
        nd = numel(d);
        
        [N, l] = max([ny na, nt, nb, nd]);
        param = 'yatbd';
        pnm = param(l);
        
        yim = ny == N;
        aim = na == N;
        tim = nt == N;
        bim = nb == N;
        dim = nd == N;
        
        if yim
            msz = size(y);
        elseif aim
            msz = size(a);
        elseif tim
            msz = size(t);
        elseif bim
            msz = size(b);
        else
            msz = size(d);
        end
        
        if yim
            ry = y;
        elseif isscalar(y)
            ry = repmat(y, msz);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeY', fn), ...
                'Size of parameter y does not match that of %s.', pnm))
        end
        
        if aim
            ra = a;
        elseif isscalar(a)
            ra = repmat(a, msz);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeA', fn), ...
                'Size of parameter a does not match that of %s.', pnm))
        end
        
        if tim
            rt = t;
        elseif isscalar(t)
            rt = repmat(t, msz);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeT', fn), ...
                'Size of parameter t does not match that of %s.', pnm))
        end
        
        if bim
            rb = b;
        elseif isscalar(b)
            rb = repmat(b, msz);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeB', fn), ...
                'Size of parameter b does not match that of %s.', pnm))
        end
        
        if dim
            rd = d;
        elseif isscalar(d)
            rd = repmat(d, msz);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeD', fn), ...
                'Size of parameter d does not match that of %s.', pnm))
        end
         
        varargout = {ry ra rt rb rd};
        
    case 'wdmlike'
        if nargin ~= 3
            throwAsCaller(MException(sprintf('wdm:%s:insufficientInput', fn), ...
                'Wrong number of input arguments to %s.', fn))
        end
        
        y = varargin{1};
        p = varargin{2};
        
        if size(y, 2) ~= 1
            throwAsCaller(MException(sprintf('wdm:%s:weirdDataVector', fn), ...
                'First input to %s should have one column.', fn))
        end
        
        if size(p, 2) ~= 4
            throwAsCaller(MException(sprintf('wdm:%s:weirdParameterVector', fn), ...
                'Second input to %s should have four columns.', fn))
        end
        
        ny = numel(y);
        np = size(p, 1);
        
        N = max([ny np]);
        
        yim = ny == N;
        pim = np == N;
        
        if yim
            ry = y;
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeY', fn), ...
                'Size of data vector does not match parameter vector.'))
        end
        
        if pim
            rp = p;
        elseif isequal(size(p), [1 4])
            rp = repmat(p, N, 1);
        else
            throwAsCaller(MException(sprintf('wdm:%s:badSizeP', fn), ...
                'Number of rows in parameter vector does not match data.'))
        end
                
        varargout = {ry rp};
        
end
