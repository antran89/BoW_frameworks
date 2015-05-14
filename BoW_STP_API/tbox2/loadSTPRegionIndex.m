% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ regionIndex ] = loadSTPRegionIndex( params, action, data_file_name )
%LOADSTPREGIONINDEX Summary of this function goes here
%   Detailed explanation goes here
%   Load Spatial Temporal Pyramids region index of DT features

% grid structure
grid = params.grid;

% load trajectories
traj = loadTrajectories(params.featurepath, action, data_file_name);
if isempty(traj)
    regionIndex = [];
    return;
end
lastFrame = uint16(traj(:, 1));
trajectories = uint16(round(traj(:, 2:end)));

% read Video dimensions information
vid = mex_VideoReader(fullfile(params.avipath, action, data_file_name));
stp_map = zeros([vid.Height, vid.Width, vid.NumberOfFrames], 'uint8');  % spatial temporal pyramids map
cell_size = floor([vid.Height, vid.Width, vid.NumberOfFrames] ./ grid);

cnt = 0;
for i = 1:grid(1)
    for j = 1:grid(2)
        for k = 1:grid(3)
            cnt = cnt + 1;
            stp_map((i-1)*cell_size(1) + 1 : i*cell_size(1), (j-1)*cell_size(2) + 1 : j*cell_size(2),...
                (k-1)*cell_size(3) + 1 : k*cell_size(3)) = cnt;
        end
    end
end
assert(cnt == prod(grid));

% segment trajectories into different grids
regionIndex = gridSTPSegment(stp_map, trajectories', lastFrame);

end
