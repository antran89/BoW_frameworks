% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ Coeff ] = mySA( B, X, knn, beta, pooling )
%MYSA Summary of this function goes here
%   Detailed explanation goes here
%   localized soft-assignment encoding
%
% Inputs
%       B       -M x d codebook, M entries in a d-dim space
%       X       -N x d matrix, N data points in a d-dim space
%       knn     -number of nearest neighboring
%       beta    -smoothing factor for softness
%
% Outputs
%       Coeff   -N x M matrix, each row is a code for corresponding X
%

if ~exist('knn', 'var') || isempty(knn),
    knn = 5;
end

if ~exist('beta', 'var') || isempty(beta),
    beta = 1;
end

nframe=size(X,1);
nbase=size(B,1);

% FLANN parameters
params.algorithm = 'kdtree';
params.trees = 8;
params.checks = 128;
params.cores = 0;

[IDX, distMat] = flann_search(B', X', knn, params);
% TODO: Do we need to compute distance Matrix again?
distMat = exp(-beta*distMat);
distMat = bsxfun(@rdivide, distMat, sum(distMat, 1)); % localize distance matrix

% llc approximation coding
Coeff = zeros(1, nbase);
if strcmp(pooling, 'sum-pooling')
    sumPooling = true;
elseif strcmp(pooling, 'max-pooling')
    sumPooling = false;
else
    error('mySA::pooling is nt sum-pooling or max-pooling');
end

blksize = 1e5;
nr_calculated = 0;
while(nr_calculated < nframe)
    nr_tocalc = min(nframe-nr_calculated, blksize);
    head = nr_calculated+1;
    tail = nr_calculated+nr_tocalc;
    featureVote = zeros(nr_tocalc, nbase);
    idx = IDX(:, head:tail);
    temp = distMat(:, head:tail);
    for i=1:knn
        featureVote(sub2ind(size(featureVote), 1:nr_tocalc, idx(i,:)))=temp(i,:);
    end
    nr_calculated  = nr_calculated + nr_tocalc;
    % pooling
   if sumPooling
       Coeff = Coeff + sum(featureVote, 1);
   else % max-pooling
       Coeff = max(Coeff, max(featureVote));
   end
end

end

