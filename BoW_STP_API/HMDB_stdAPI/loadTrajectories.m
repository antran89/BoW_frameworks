% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ traj ] = loadTrajectories( featurepath, action, data_file_name )
%LOADTRAJECTORIES Summary of this function goes here
%   Detailed explanation goes here
%   load trajectories position and its last frame from a .mat file.

% change this command according to the dataset
S = load(fullfile(featurepath, 'OrgTraj', [],...
    strcat('OrgTraj_', data_file_name(1:end-4), '.mat')));
traj = S.feature;

end

