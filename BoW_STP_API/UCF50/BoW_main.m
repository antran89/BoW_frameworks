% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

clear all
tic

%% ***CHANGE TO DESIRED PATHS***
path = '../../dense_trajectories_BoW'; % basic path

addpath(path);
addpath(fullfile(path, '/tbox/'));
addpath('../tbox2/');           % specific tbox for BoW STP
addpath(fullfile(path, '/svm/chi/'));
addpath(fullfile(path, '/svm/chi/pwmetric/'));
addpath(fullfile(path, '/svm/libsvm-matlab'));
addpath(fullfile(path, '/svm/mpi-chi2'));
addpath(fullfile(path, '/yael/matlab'));
addpath(genpath(fullfile(path, 'ACCV2012_Encodeing/src')));
addpath(fullfile(path, 'vlfeat/toolbox'));
addpath('~/Desktop/workspace/mytoolbox');
vl_setup(); % vlfeat

%% set dataset params
params.dataset = 'UCF50';
params.afspath = '/home/beahacker/Public/data/video/UCF50';
params.savepath = '../debug/'; %path to save intermediate (before svm classification) results
% params.jacketenginepath = '/**/jacket/engine/'; % option to use Jacket GPU code for MATLAB http://www.accelereyes.com/

%path to videos and labels/info of videos
params.avipath = params.afspath;
params.infopath = params.afspath; %path for video labels/info

% path to features
params.featurepath = '~/Public/data/video/features/iDT/UCF50';

% subsample data_file_names to sample features to train codebook
params.num_movies = 1000;

% grid structure
params.grid = [2, 2, 2];

%% set experiment params
% different features
params.exp_descriptions = 'BoW-STP';
params.feature_type = 'MBH';            % default feature
params.type = {'HOG', 'HOF', 'MBHx', 'MBHy'};  % {'Trajectory', 'HOG', 'HOF', 'MBH'}
params.num_channels  = length(params.type);    % number of channels (feature types)
params.feature_dim = [];
params.total_dim = 0;                   % total dim of all features, for viz

% some settings for encoding, pooling, normalization, classification
params.pca_whitening = true;
params.encoding = 'Fisher';             % {VQ, SA, SA-k, LLC, SPC, Fisher, FK, VLAD, SV}, Fisher using Yael lib, FK using Encoding toolbox
params.pooling = 'sum-pooling';         % {sum-pooling, max-pooling}
params.normalization = 'Intra+Power+L2';      % {L1, L2, Power, Power+L1, Power+L2, Intra+Power+L2}
params.classifier = 'linear_svm';       % {linear_svm, chi_svm}
if strcmp(params.encoding, 'Fisher')
    params.threshold = 256e3;
    params.num_centroids = 256;         % gmm mixtures 
else
    params.threshold = 1e5;
    params.num_centroids = 4000;        % number of centroids in k-means
end

% some PCAwhitening settings
params.whiteningFlag = true;
params.whiteningReg = 0.1;
params.pcaSamplingThreshold = 1e6;      % sampling features to train PCA

% k-means reinitilization
params.num_km_init = 1;                 % number of random kmeans or gmm initializations
params.num_km_samples = 1000;           % number of kmeans samples *Per Centroid*
params.seed = 10;                       % random seed for kmeans
params.km_method = 'yael';              % {'michael', 'yael', 'vlfeat', 'matlab'}
params.maxIter = 200;                   % maximum number of iterations

% evaluation method: accuracy (one-vs-all, one label per datapoint), 
params.eval = 'average_accuracy';

%svm kernel
params.kernel = 'chisq';                % {chisq, linear}
params.const_K = 8;                     % constant K to multiply with average distance A(c)
params.cost = 100;                      % regularizer term in svm formulation

%% number of action classes
% customized for different datasets
d = dir(params.avipath);
actions = {d(:).name}';
actions(ismember(actions, {'.','..'})) = [];
params.actions = actions;
l = length(params.actions);
assert(l == 50, 'BoW_main :: something wrong with reading classes files');

%% initialization
fprintf('\n--- Feature extraction and classification (%s) ---\n', params.dataset)
initializerandomseeds;

%% number of train/test splits on dataset
params.no_splits = 25;                  % number of splits for UCF50 dataset: 25 group (LOGO cross-validation)
acc = zeros(params.no_splits,1);
mean_ap = zeros(params.no_splits,1);
perclass_acc = zeros(l, params.no_splits);
for idx = 1:params.no_splits
    fprintf('\n-------------------------split %d----------------------------\n', idx);
    %% --------------compute descriptors for training data-------------
    [all_train_labels, all_test_labels, all_train_files, all_test_files] ...
            = get_data_summary(params, idx);

    %% ---------- generating feature vectors for each feature type-------------
    disp('Generating feature vectors for each feature type');
    action_feature = cell(1, params.num_channels);
    for c = 1:params.num_channels
        params.feature_type = params.type{c};
        action_feature{c}.name = params.type{c};
        [action_feature{c}.Xtrain, action_feature{c}.Xtest] = ...
            featureCodingPooling( params, all_train_files, all_train_labels, all_test_files, all_test_labels );
    end

    %% -----------------DEBUG--------------------------------------------------
    % saving dictionary and final vector
    % save('debug.mat', '-v7.3')
    % load('debug.mat')

    %% -----------------classifying and compute mAP--------------------------- 
    mean_ap_list = zeros(params.num_km_init,1);
    acc_list = zeros(params.num_km_init,1);
    perclass_acc_list = zeros(l, params.num_km_init);

    for ini_idx = 1:params.num_km_init

        %%------------------ run SVM to classify data---------------------------
        if strcmp(params.classifier, 'linear_svm')
            [mean_ap_list(ini_idx), acc_list(ini_idx), perclass_acc_list(:, ini_idx)] = linear_svm(params, action_feature, ...
                   all_train_labels, all_test_labels, ini_idx); 
        else
            [mean_ap_list(ini_idx), acc_list(ini_idx), perclass_acc_list(:, ini_idx)] = kernel_svm(params, action_feature, ...
                   all_train_labels, all_test_labels, ini_idx); 
        end

    end

    fprintf('----------------------------RESULTS----------------------------\n');
    for ini_idx = 1:params.num_km_init
        fprintf('%d th initialization: mean_ap = %f, acc = %f\n', ini_idx, mean_ap_list(ini_idx), acc_list(ini_idx));
    end
    
    % report the result 
    acc(idx) = mean(acc_list);
    mean_ap(idx) = mean(mean_ap_list);
    perclass_acc(:, idx) = mean(perclass_acc_list, 2);
end

%% ----------------------------PRINT RESULTS-------------------------------
for c = 1:params.num_channels
    params.total_dim = params.total_dim + size(action_feature{c}.Xtrain{1}, 2); 
end
printResults(params, acc, mean_ap, perclass_acc);

exit