function [all_train_labels, all_test_labels, all_train_files, all_test_files] = get_data_summary(params, idx)
%[all_train_labels, all_test_labels, all_train_files, all_test_files] =
%                   get_data_summary(file_path, num_movies)
% params :  parameters of UCF-Sports dataset
%           including path to video information (ClipSets)
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

%% The following code extracts each movie-label pair in a list from
%% ClipSets, which contains, for each action label, a file giving binary
%% indication of whether each clip has that action label
%since a single movie may have multiple labels, the list is longer than
%total number of movie clips; during classification the list is unscrambled
%to comply with correct testing procedures

l = length(params.actions);
all_train_files = {};
all_test_files = {};
all_train_labels = [];
all_test_labels = [];
for i=1:l
    
    %[files, labels] = textread([info_path, action, sprintf('_test_split%s.txt', num2str(idx))],'%s %d \n');
    d = dir(fullfile(params.infopath, params.actions{i}, '*.avi'));
    files = {d(:).name}';
    len = length(d);
    labels = true(len, 1);   % training samples
    test_index = mod(idx-1, len) + 1;
    labels(test_index) = false;               % testing samples
    
    positive_train_labels = labels == true;
    all_train_labels = [all_train_labels;  i*ones(len-1, 1)];
    all_test_labels = [all_test_labels;  i];
    all_train_files = [all_train_files;  files(positive_train_labels)];
    all_test_files = [all_test_files; files(test_index)];
    
end
assert(length(all_train_labels) == 140);
assert(length(all_train_files) == 140);
assert(length(all_test_labels) == 10);
assert(length(all_test_files) == 10);
end