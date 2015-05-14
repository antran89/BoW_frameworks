% Copyright (C) 2015 Tran Lam An.
% This code is for research, please do not distribute it.

function [ Ktrain, Ktest ] = computeLinearKernel( params, action_feature, ini_idx )
%COMPUTELINEARKERNEL Summary of this function goes here
%   Detailed explanation goes here
%   Compute linear kernel by block multiplication. Each block is a feature
%   type. We also combine multiple blocks from Fisher vectors
%   (action_feature) and BoW_saliency (sal_action_feature). 
%   Input:  params
%           action_feature
%           sal_action_feature
%           ini_idx
%   Output: Ktrain
%           Ktest

numTrainVideos = size(action_feature{1}.Xtrain{ini_idx}, 1);
numTestVideos = size(action_feature{1}.Xtest{ini_idx}, 1);
Ktrain = zeros(numTrainVideos);
Ktest = zeros(numTestVideos, numTrainVideos);

% compute Ktrain
for c = 1:params.num_channels
    trainFeat = action_feature{c}.Xtrain{ini_idx};
    Ktrain = Ktrain + trainFeat * trainFeat';
end

% compute Ktest
for c = 1:params.num_channels
    trainFeat = action_feature{c}.Xtrain{ini_idx};
    testFeat = action_feature{c}.Xtest{ini_idx};
    Ktest = Ktest + testFeat * trainFeat';
end

% attach id numbers
Ktrain = [(1:numTrainVideos)', Ktrain];
Ktest = [(1:numTestVideos)', Ktest];

end

