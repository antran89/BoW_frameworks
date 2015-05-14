% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ weights ] = computeActionnessWeights( params, all_train_files, all_train_labels )
%COMPUTEACTIONNESSWEIGHTS Summary of this function goes here
%   Detailed explanation goes here
%   Compute actionness value as average saliency values in that region.
%   Each region has its own actionness value to weight for Chi2-distance
%   kernel.
%   Input: params,
%          all_train_files == training files
%          all_train_labels == training files labels
%   Output: weights == weight for each grid in one level 

num_grids = params.num_regions;
weights = zeros(1, num_grids);
for i = 1:length(all_train_files)
    load(fullfile(params.regionindex, params.actions{all_train_labels(i)}, ...
    strcat('ActionessOfRegions_', all_train_files{i}(1:end-4), '_K', num2str(params.num_regions))));
    weights = weights + ActionnessValue(1:num_grids);
end
weights = weights/length(all_train_files);
weights = weights/sum(weights);     % normalization

end

