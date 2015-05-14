% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ noSplits ] = getNumSplits( params )
%GETNUMSPLITS Summary of this function goes here
%   Detailed explanation goes here
%   Input: params.info_path == path to video information (ClipSets)
%   Output: noSplits == number os splits is maximum number of videos in
%   each class

%% customized for different datasets; this is for UCF-Sports
fid = fopen(fullfile(params.infopath, 'classes.txt'), 'r');
actions = textscan(fid, '%s\n');
actions = actions{1};
fclose(fid);

noSplits = 0;
for i = 1:length(actions)
    d = dir(fullfile(params.featurepath, 'MBH', actions{i}, '*.mat'));
    len = length(d);
    if noSplits < len
        noSplits = len;
    end
end
end

