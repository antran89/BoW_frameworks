% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ K_train, K_test ] = computeActionnessWeightedChi2Kernel( params, action_feature, ini_idx, mode )
%COMPUTEACTIONNESSWEIGHTEDCHI2KERNEL Summary of this function goes here
%   Detailed explanation goes here
%   Compute combined weighted Chi2-RBF distance kernels
%   K(X,Y) = sum(weight(i)*K_l) (l from 0 to L), while K_l is the kernel at
%   level l.
%   The weights are computed from function computeActionnessWeights

if(nargin < 4)
   mode = 'both';
end

% determine number of regions and levels
num_grids = params.num_regions;
weights = params.weights;

if isunix()     % for Unix platform
    % note: A is mean distance (chi-squared) between all samples, generally multiply by a factor works better
    A = cell(params.num_channels, 1);
    for c = 1:params.num_channels
        A{c} = zeros(num_grids, 1);
        for gridIdx = 1:num_grids
            A{c}(gridIdx) = compute_Average(action_feature{c}.Xtrain{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids)) ...
                * params.const_K;
        end
    end

    if strcmp(mode, 'both')||strcmp(mode, 'train')
        num_samp_train = size(action_feature{1}.Xtrain{ini_idx}, 1);
        K_train = zeros(num_samp_train, num_samp_train);
        for gridIdx = 1:num_grids     % all grids

            M_chi = zeros(num_samp_train, num_samp_train);
            for c = 1:params.num_channels
                M_train = action_feature{c}.Xtrain{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids);
                M_chi = M_chi + chi2_mex(M_train', M_train')/(2*A{c}(gridIdx));
            end

            K_train = K_train + weights(gridIdx) * exp(-M_chi);
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

            M_chi = zeros(num_samp_test, num_samp_train);
            for c = 1:params.num_channels
                M_train = action_feature{c}.Xtrain{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids);
                M_test = action_feature{c}.Xtest{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids);
                M_chi = M_chi + chi2_mex(M_test', M_train')/(2*A{c}(gridIdx));
            end

            K_test = K_test + weights(gridIdx) * exp(-M_chi);
        end

        K_test = [(1:num_samp_test)', K_test];
    else
        K_test = [];
    end
    
elseif ispc()   % for Windows platform
    % note: A is mean distance (chi-squared) between all samples, generally multiply by a factor works better
    A = cell(params.num_channels, 1);
    for c = 1:params.num_channels
        A{c} = zeros(num_grids, 1);
        for gridIdx = 1:num_grids
            A{c}(gridIdx) = compute_A_testimp(action_feature{c}.Xtrain{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids)) ...
                * params.const_K;
        end
    end

    if strcmp(mode, 'both')||strcmp(mode, 'train')
        num_samp_train = size(action_feature{1}.Xtrain{ini_idx}, 1);
        K_train = zeros(num_samp_train, num_samp_train);
        for gridIdx = 1:num_grids     % all grids

            M_chi = zeros(num_samp_train, num_samp_train);
            for c = 1:params.num_channels
                M_train = action_feature{c}.Xtrain{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids);
                M_chi = M_chi + slmetric_pw(M_train', M_train', 'chisq')/A{c}(gridIdx);
            end

            K_train = K_train + weights(gridIdx) * exp(-M_chi);
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

            M_chi = zeros(num_samp_test, num_samp_train);
            for c = 1:params.num_channels
                M_train = action_feature{c}.Xtrain{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids);
                M_test = action_feature{c}.Xtest{ini_idx}(:, (gridIdx-1)*params.num_centroids + 1 : gridIdx*params.num_centroids);
                M_chi = M_chi + slmetric_pw(M_test', M_train', 'chisq')/A{c}(gridIdx);
            end

            K_test = K_test + weights(gridIdx) * exp(-M_chi);
        end

        K_test = [(1:num_samp_test)', K_test];
    else
        K_test = [];
    end
end

end

function A = compute_Average(trainSet)
% compute mean value of distances over all training samples
% use mpi-chi2 to compute pairewise metrics, by Christoph Lampert 

num_samp = size(trainSet, 1);

D = chi2_mex(trainSet', trainSet')/2;

A = sum(sum(D))/(num_samp*(num_samp-1)); %num_samp zeros in sum

end