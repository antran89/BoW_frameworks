% Copyright (C) 2015 Tran Lam An.
% This code is for research, please do not distribute it.

function [ Xall ] = randomSampleFeatures( params, data_file_names, label_file_names, threshold )
%RANDOMSAMPLEFEATURES Summary of this function goes here
%   Detailed explanation goes here
%   randomly select 1e6 features for PCA learning
%   INPUT:  params
%           data_file_names  list of file names
%           label_file_names  labels of file names
%           threshold
%   OUTPUT: Xall

m = length(data_file_names);
Xclip = loadFeature( params, params.actions{label_file_names(1)}, data_file_names{1} );
num_features = size(Xclip, 2);

%% randomly sampling
% get 100000 samples for codebook learning
disp('counting number of samples ...')
no_samples = 0;
for i = 1:m
    % load feature into a big matrix
    % tic 
    Xclip = loadFeature(params, params.actions{label_file_names(i)}, data_file_names{i});
    no_samples = no_samples + size(Xclip, 1);
end
save('noSamples.mat', 'no_samples');
fprintf('total number of samples %d\n', no_samples);

%% sampling no.2
% randomly sample features from all training files
Xall = zeros(threshold, num_features, 'single');

randInd = randperm(no_samples);
randInd = randInd(1:threshold);
randInd = sort(randInd);

idx = 1;    % current row index of Xall
X_fill = 0;     % filling index upto now
for i = 1:m
    % terminate conditions
    if idx > threshold || randInd(idx) <= X_fill
        break;  % break if illegal conditions
    end
    
    Xclip = loadFeature(params, params.actions{label_file_names(i)}, data_file_names{i});
    X_fill_next = X_fill + size(Xclip, 1);
    beginIdx = idx;
    while(idx <= threshold && randInd(idx) <= X_fill_next)
        idx = idx + 1;
    end
    endIdx = idx - 1;
    if endIdx >= beginIdx
        Xall(beginIdx:endIdx, :) = Xclip(randInd(beginIdx:endIdx) - X_fill, :);
    end
    X_fill = X_fill_next;
    
end
assert(idx == threshold + 1)

end
