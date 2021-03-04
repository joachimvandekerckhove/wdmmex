function r =  testSuite()

%% RNG
% generate some random values
obj = Wiener();

% large N for plotting
N = 1e6;

% draw samples
tic
    y = obj.rnd(N);
r.rnd.time = toc;


%% PDF
% Get histogram
B = 1000;
h = histogram(y, B, 'Normalization', 'pdf'); hold on
y0 = (h.BinEdges(1:B) + h.BinEdges(2:B+1))/2;

% compute pdf
tic
    p0 = obj.pdf(y0);
r.pdf.time = toc;

r.pdf.mean = mean(h.Values - p0);
r.pdf.var  = var(h.Values - p0);


%% Deviance
% Recover parameters
obj = Wiener();
xax = obj.rnd(1e4);
tic
est = Wiener().estimate(xax);
r.like.time = toc;

r.like.obj = obj;
r.like.est = est;


%% Report

fprintf('## Accuracy\n')
fprintf(' pdf.mean: %g\n', r.pdf.mean);
fprintf('  pdf.var: %g\n', r.pdf.var);

fprintf(' like.err: %s\n', mat2str( ...
    [ obj.InitialBias        obj.DriftRate             ...
      obj.BoundarySeparation obj.NondecisionTime] -    ...
    [ est.InitialBias        est.DriftRate             ...
      est.BoundarySeparation est.NondecisionTime] , 4  ...
));

fprintf('## Timing\n')
fprintf(' rnd.time: %g\n', r.rnd.time);
fprintf(' pdf.time: %g\n', r.pdf.time);
fprintf('like.time: %g\n', r.like.time);



