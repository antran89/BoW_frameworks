% Copyright (C) 2015 Tran Lam An.
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

%% UCF101 dataset

% load training files and their labels
fid = fopen(fullfile(params.infopath, sprintf('trainlist%s.txt', num2str(idx, '%02d'))), 'r');
C = textscan(fid, '%*s %s %d', 'delimiter', '/ ');   % multiple delimiters '/ '
all_train_files = C{1};
all_train_labels = C{2};
fclose(fid);

% load test files and their labels
fid = fopen(fullfile(params.infopath, sprintf('testlist%s.txt', num2str(idx, '%02d'))), 'r');
C = textscan(fid, '%s %s', 'delimiter', '/');   % multiple delimiters '/ '
test_labels = C{1};     % all test classes 
all_test_files = C{2};
all_test_labels = zeros(length(all_test_files), 1, 'int32');
label = 1;  % current label
all_test_labels(1) = label;
% convert string labels into numeric labels
for i = 2:length(all_test_labels)
    if ~strcmp(test_labels{i}, test_labels{i-1})
        label = label + 1;
    end
    all_test_labels(i) = label;
end
assert(label == 101)
fclose(fid);

end
