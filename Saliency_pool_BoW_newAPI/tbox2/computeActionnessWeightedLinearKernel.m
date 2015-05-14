% Copyright (C) 2015 Tran Lam An.
% This code is for research, please do not distribute it.

function [ K_train, K_test ] = computeActionnessWeightedLinearKernel( params, action_feature, ini_idx, mode )
%COMPUTEACTIONNESSWEIGHTEDLINEARKERNEL Summary of this function goes here
%   Detailed explanation goes here

if(nargin < 4)
   mode = 'both';
end

% determine number of regions and levels
num_grids = params.num_regions;
weights = params.weights;

if strcmp(mode, 'both')||strcmp(mode, 'train')
    num_samp_train = size(action_feature{1}.Xtrain{ini_idx}, 1);
    K_train = zeros(num_samp_train, num_samp_train);
    for gridIdx = 1:num_grids     % all grids
        for c = 1:params.num_channels
            M_train = action_feature{c}.Xtrain{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids);
            K_train = K_train + weights(gridIdx) * (M_train * M_train');
        end
    end

    K_train = [(1:num_samp_train)', K_train];
else
    K_train = [];
end

if strcmp(mode, 'both')||strcmp(mode, 'test')
    num_samp_train = size(action_feature{1}.Xtrain{ini_idx}, 1);
    num_samp_test = size(action_feature{1}.Xtest{ini_idx}, 1);
    K_test = zeros(num_samp_test, num_samp_train);
    for gridIdx = 1:num_grids     % all grids
        for c = 1:params.num_channels
            M_train = action_feature{c}.Xtrain{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids);
            M_test = action_feature{c}.Xtest{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids);
            K_test = K_test + weights(gridIdx) * (M_test * M_train');
        end        
    end
    
    K_test = [(1:num_samp_test)', K_test];
else
    K_test = [];
end

end

