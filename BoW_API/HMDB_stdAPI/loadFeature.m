% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ feature ] = loadFeature( params, action, data_file_name)
%LOADFEATURE Summary of this function goes here
%   Detailed explanation goes here
%   load features of a video from a mat file
%   INPUT:  params
%           action class name
%           data_file_name
%   OUTPUT: feature        

% change this command according to the dataset
if strcmp(params.feature_type, 'MBHx')
    params.feature_type = 'MBH';
    S = load(fullfile(params.featurepath, params.feature_type,...
        strcat(params.feature_type, '_', data_file_name(1:end-4), '.mat')));
    if ~isempty(S.feature)
        feature = S.feature(:, 1:96);
    else
        feature = single([]);
    end
elseif strcmp(params.feature_type, 'MBHy')
    params.feature_type = 'MBH';
    S = load(fullfile(params.featurepath, params.feature_type,...
        strcat(params.feature_type, '_', data_file_name(1:end-4), '.mat')));
    if ~isempty(S.feature)
        feature = S.feature(:, 97:192);
    else
        feature = single([]);
    end
else
    S = load(fullfile(params.featurepath, params.feature_type,...
        strcat(params.feature_type, '_', data_file_name(1:end-4), '.mat')));
    feature = S.feature;
end

end

