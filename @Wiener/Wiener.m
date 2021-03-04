classdef Wiener
% WIENER  A class for the Wiener distribution

    % The main properties are the parameters of the distribution
    properties
    
        DriftRate          double {mustBeReal, mustBeFinite} = 0.0
        BoundarySeparation double {mustBeReal, mustBeFinite, mustBePositive} = 1.0
        NondecisionTime    double {mustBeReal, mustBeFinite, mustBePositive} = 0.2
        InitialBias        double {mustBeReal, mustBeFinite, mustBePositive} = 0.5
        DriftCoefficient   double {mustBeReal, mustBeFinite, mustBePositive} = 1.0
    
    end
    
    % Derived properties that need to be set internally
    properties (SetAccess = private)
    end
    
    % Constants are sometimes useful
    properties (Constant)
    end
    
    
    % Methods are functions that belong to the class
    methods
    
        %%% Constructor function %%%

        % A main constructor, for a new Wiener
        function obj = Wiener( DriftRate          , ...
                               BoundarySeparation , ...
                               NondecisionTime    , ...
                               InitialBias        , ...
                               DriftCoefficient   )

            if nargin > 0, obj.DriftRate          = DriftRate;          end
            if nargin > 1, obj.BoundarySeparation = BoundarySeparation; end
            if nargin > 2, obj.NondecisionTime    = NondecisionTime;    end
            if nargin > 3, obj.InitialBias        = InitialBias;        end
            if nargin > 4, obj.DriftCoefficient   = DriftCoefficient;   end
            
            obj.compileMexFiles();

        end
        
    
        %%% Display function %%%
        
        % Print the distribution to screen
        function disp(obj)
        
            t = sprintf('+');
            m = sprintf('+');
            b = sprintf('+');
            
            f = '     %s  %-20s=%8.4f\n';
            
            fprintf('  Wiener distribution with parameters:\n');

            fprintf(f, t, 'Drift rate'         , obj.DriftRate          );
            fprintf(f, m, 'Boundary separation', obj.BoundarySeparation );
            fprintf(f, m, 'Nondecision time'   , obj.NondecisionTime    );
            fprintf(f, m, 'Initial bias'       , obj.InitialBias        );
            fprintf(f, b, 'Drift coefficient'  , obj.DriftCoefficient   );
            
            fprintf('\n');
            
        end

        
        function density = pdf(obj, xValues)
                        
            density = wdmDensityMexFile(                        ...
                xValues                                       , ...
                obj.DriftRate * obj.DriftCoefficient          , ...
                obj.BoundarySeparation * obj.DriftCoefficient , ...
                obj.NondecisionTime                           , ...
                obj.InitialBias                               );
            
        end
        
        
        function logDensity = logPdf(obj, data)
            
            logDensity = wdmLogLikelihoodMexFile(               ...
                data                                          , ...
                obj.DriftRate * obj.DriftCoefficient          , ...
                obj.BoundarySeparation * obj.DriftCoefficient , ...
                obj.NondecisionTime                           , ...
                obj.InitialBias                               );
            
        end
        
        
        function logDensity = logJointPdf(obj, data)
            
            logDensity = wdmLogJointDensityMexFile(             ...
                data                                          , ...
                obj.DriftRate * obj.DriftCoefficient          , ...
                obj.BoundarySeparation * obj.DriftCoefficient , ...
                obj.NondecisionTime                           , ...
                obj.InitialBias                               );
            
        end
        
        
        function [data, reactionTime, accuracy] = rnd(obj, sampleSize)
            
            data = wdmRandomMexFile(               ...
                obj.DriftRate * obj.DriftCoefficient          , ...
                obj.BoundarySeparation * obj.DriftCoefficient , ...
                obj.NondecisionTime                           , ...
                obj.InitialBias                               , ...
                sampleSize                                    , ...
                1e6 * rand                                    );
            
            reactionTime = abs(data);
            accuracy = data > 0;

%             dt  =  0.01;
%             L   =  round(5/dt);
%             T   =  1:L;
%             
%             Xi  =  cumsum( obj.DriftRate .* dt + randn(N,L) .* sqrt(dt) , 2.0 ) ...
%                 + obj.InitialBias * obj.BoundarySeparation;
%             
%             isf =  cumsum(cumsum( Xi > obj.BoundarySeparation | Xi < 0,2),2) == 1;
%             isc =  isf & (cumsum(cumsum(Xi > obj.BoundarySeparation, 2),2) == 1);
%             y   =  (repmat(T, N, 1) .* dt + obj.NondecisionTime) .* (2*(isf&isc)-1);
%             y   =  y(isf);
%             t   =  abs(y);
%             isc =  y > 0;

        end
        
    end
    
    
    % Static methods don't need the object as input
    methods (Static)
        
        testSuite()
        
        function devianceScore = deviance(data, parameters)
 
            devianceScore = -2 * wdmLogJointDensityMexFile( ...
                data          , ...
                parameters(1) , ...
                parameters(2) , ...
                parameters(3) , ...
                parameters(4) );
            
        end

        function obj = estimate(data)
            
            objective = @(p)Wiener().deviance(data, p);
            
            parameter = [0.0, 1.0, 0.2, 0.5];
            
            for ign = 1:3
                parameter = fminsearch( ...
                    objective         , ...
                    parameter         , ...
                    struct('Display', 'off'));
            end
            
            obj = Wiener( ...
                    parameter(1), ...
                    parameter(2), ...
                    parameter(3), ...
                    parameter(4));
            
        end

    end 
    

    % Static methods don't need the object as input
    methods (Static, Access=private)
    end
        
end
