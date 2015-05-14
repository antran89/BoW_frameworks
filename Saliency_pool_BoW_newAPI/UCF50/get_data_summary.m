% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [all_train_labels, all_test_labels, all_train_files, all_test_files] = get_data_summary(params, idx)
%[all_train_labels, all_test_labels, all_train_files, all_test_files] =
%                   get_data_summary(file_path, num_movies)
% INFO_PATH : path to video information (ClipSets)
% idx: index of TrainTestSplit
% ALL_TRAIN_LABELS : train labels
% ALL_TEST_LABELS  : test labels
% ALL_TRAIN_FILES  : train file names
% ALL_TEST_FILES   : test file names
% test file, train file and labels are organized such that each index will
% give the filename and corresponding labels

if ~exist('idx', 'var')
    idx = 1;
end

%% UCF50 dataset

% initial values
l = length(params.actions);
all_train_files = {};
all_test_files = {};
all_train_labels = [];
all_test_labels = [];

% load train files and test files based on Leave-One-Group-Out CV
for i = 1:l
    d = dir(fullfile(params.avipath, params.actions{i}, '*.avi'));
    for j = 1:length(d)    % group index
        file = d(j).name;
        [groupId cnt] = sscanf(file, ['v_' params.actions{i} '_g%d_c%*d.avi']);
        if cnt == 0     % error control
            error('BoW:get_data_summary', 'cannot retrieve group identity');
        end
        if groupId > 25
            break;
        elseif groupId == idx         % load test files and their labels
            all_test_files = [all_test_files; file];
            all_test_labels = [all_test_labels; i];
        else        % load train files and their labels
            all_train_files = [all_train_files; file];
            all_train_labels = [all_train_labels; i];
        end
    end
end
assert(length(all_train_files) + length(all_test_files) == 6617)
assert(length(all_train_labels) + length(all_test_files) == 6617)

end
