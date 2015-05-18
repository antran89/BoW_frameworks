% ========================================================================
% USAGE: [Coeff]=LLC_coding_appr(B,X,knn,lambda)
% Approximated Locality-constraint Linear Coding
%
% Inputs
%       B       -M x d codebook, M entries in a d-dim space
%       X       -N x d matrix, N data points in a d-dim space
%       knn     -number of nearest neighboring
%       lambda  -regulerization to improve condition
%
% Outputs
%       Coeff   -N x M matrix, each row is a code for corresponding X
%
% Jinjun Wang, march 19, 2010
% Modified by Tran Lam An, 2014
% ========================================================================

function [Coeff] = myLLC_coding_appr(B, X, knn, beta, pooling)

if ~exist('knn', 'var') || isempty(knn),
    knn = 5;
end

if ~exist('beta', 'var') || isempty(beta),
    beta = 1e-4;
end

nframe=size(X,1);
nbase=size(B,1);

% find k nearest neighbors
% XX = sum(X.*X, 2);
% BB = sum(B.*B, 2);
% D  = repmat(XX, 1, nbase)-2*X*B'+repmat(BB', nframe, 1);
% D = yael_cross_distances (X', B', 2, 8);
% IDX = zeros(nframe, knn);
% for i = 1:nframe,
% 	d = D(i,:);
% 	[~, idx] = sort(d, 'ascend');
% 	IDX(i, :) = idx(1:knn);
% end
params.algorithm = 'kdtree';
params.trees = 8;
params.checks = 128;
params.cores = 0;

[flann_result, ~] = flann_search(B', X', knn, params);
IDX = flann_result';

% llc approximation coding
II = eye(knn, knn);
Coeff = zeros(1, nbase);
if strcmp(pooling, 'sum-pooling')
    sumPooling = true;
elseif strcmp(pooling, 'max-pooling')
    sumPooling = false;
else
    error('myLLC::pooling is nt sum-pooling or max-pooling');
end
for i = 1:nframe
   idx = IDX(i,:);
   z = B(idx,:) - repmat(X(i,:), knn, 1);           % shift ith pt to origin
   C = z*z';                                        % local covariance
   C = C + II*beta*trace(C);                        % regularlization (K>D)
   w = C\ones(knn,1);
   w = w/sum(w);                                    % enforce sum(w)=1
   if sumPooling
       Coeff(idx) = Coeff(idx) + w';
   else % max-pooling
       Coeff(idx) = max(Coeff(idx), w');
   end
end
