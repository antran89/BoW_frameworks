% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ regionIndex ] = loadRegionIndex( params, action, data_file_name )
%LOADREGIONINDEX Summary of this function goes here
%   Detailed explanation goes here
%   load index of features from pooled regions
%   Input:  params
%           action name
%           data_file_name
%           column: which column to load (we have many configurations)

% change this command according to the dataset
S = load(fullfile(params.regionindex, action,...
    strcat('Actioness2DenseFea_', data_file_name(1:end-4), '_K', num2str(params.num_regions))));
regionIndex = S.RegionIndex;
end

