% Copyright (C) 2015 Tran Lam An.
% This code is for research, please do not distribute it.

function [ K_train, K_test ] = computeActionnessWeightedKernel( params, action_feature, ini_idx, mode )
%COMPUTEACTIONNESSWEIGHTEDKERNEL Summary of this function goes here
%   Detailed explanation goes here
%   Compute combined weighted distance kernels
%   Currently, kernel can be linear, Chi2-RBF.
%   K(X,Y) = sum(weight(i)*K_l) (l from 0 to L), while K_l is the kernel at
%   level l.
%   The weights are computed from function computeActionnessWeights

if(nargin < 4)
   mode = 'both'; 
end

if strcmp(params.kernel, 'chisq')
    [ K_train, K_test ] = computeActionnessWeightedChi2Kernel( params, action_feature, ini_idx, mode );
elseif strcmp(params.kernel, 'linear')
    [ K_train, K_test ] = computeActionnessWeightedLinearKernel( params, action_feature, ini_idx, mode );
end

end

