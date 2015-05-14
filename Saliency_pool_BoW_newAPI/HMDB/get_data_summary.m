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

%% HMDB dataset
l = length(params.actions);
all_train_files = {};
all_test_files = {};
all_train_labels = [];
all_test_labels = [];
for i=1:l
    action = params.actions{i};
    
    fid = fopen(fullfile(params.infopath, [action, sprintf('_test_split%s.txt', num2str(idx))]));
    C = textscan(fid,'%s %d\n');
    fclose(fid);
    files = C{1};
    labels = C{2};
        
    positive_train_labels = labels == 1;
    positive_test_labels = labels == 2;
    all_train_labels = [all_train_labels;  i*ones(sum(positive_train_labels),1)];
    all_test_labels = [all_test_labels;  i*ones(sum(positive_test_labels),1)];
    all_train_files = [all_train_files;  files(positive_train_labels)];
    all_test_files = [all_test_files; files(positive_test_labels)];
end

end
