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

if idx > 1
    error('Number of splits is greater than 1\n');
end

%% train/test split
% first 1/3 for testing, others for training
% Videos for training:
% 
% 5 6 7 8 9 10 11 12 13 14 21 22 23 24 25 26 27 28 29 30 31 32 39 40 41 42 43 44 45 46 47 48 49 50 51 52 55 56 57 58 63 64 65 66 67 68 69 70 75 76 77 78 79 80 81 82 83 88 89 90 91 92 93 94 95 102 103 104 105 106 107 108 109 110 111 112 113 114 115 120 121 122 123 124 125 126 127 128 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 
% 
% 
% Videos for testing:
% 
% 1 2 3 4 15 16 17 18 19 20 33 34 35 36 37 38 53 54 59 60 61 62 71 72 73 74 84 85 86 87 96 97 98 99 100 101 116 117 118 119 129 130 131 132 133 134 135 

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
    test_index = 1:floor(len/3);    % first 1/3 for testing
    labels(test_index) = false;               % testing samples
    
    all_train_labels = [all_train_labels;  i*ones(sum(labels), 1)];
    all_test_labels = [all_test_labels;  i*ones(length(test_index), 1)];
    all_train_files = [all_train_files;  files(labels)];
    all_test_files = [all_test_files; files(test_index)];
    
end
assert(length(all_train_labels) == 103);
assert(length(all_train_files) == 103);
assert(length(all_test_labels) == 47);
assert(length(all_test_files) == 47);
end