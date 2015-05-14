% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ xPCAwhite ] = pca_whitening( params, X0, k )
%PCA_WHITENING Summary of this function goes here
%   Detailed explanation goes here
%   Do PCA whitening
%   INPUT: X0 a demeaned matrix of dimensions n-by-d
%          k dimension to keep after PCA
%   OUTPUT: xPCAwhite whitening matrix [d-by-k]

%% implementation 1
covarianceMatrix = X0'*X0/size(X0, 1);
[U, S] = eig(covarianceMatrix);
e = diag(S);               
[e, perm] = sort(e, 'descend');
U = U(:, perm);
if params.whiteningFlag
    e = e + params.whiteningReg * max(e);   % reduce the impact of small eigen
    e = e(1:k);                           % keep top eigen values
    esqrtinv = 1 ./ sqrt(e + eps);          % element-wise division
    xPCAwhite = U(:, 1:k) * diag(esqrtinv);
else
    xPCAwhite = U(:, 1:k);
end

% %% implementation 2
% [U, ~, e] = princomp(X0);
% if params.whiteningFlag
%     e = e + params.whiteningReg * max(e);   % reduce the impact of small eigen
%     e = e(1:k);                           % keep top eigen values
%     esqrtinv = 1 ./ sqrt(e + eps);          % element-wise division
%     xPCAwhite = U(:, 1:k) * diag(esqrtinv);
% else
%     xPCAwhite = U(:, 1:k);
% end

end

