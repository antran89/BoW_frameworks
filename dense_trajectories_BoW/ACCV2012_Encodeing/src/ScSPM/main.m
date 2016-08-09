% This is an example code for running the ScSPM algorithm described in "Linear 
% Spatial Pyramid Matching using Sparse Coding for Image Classification" (CVPR'09)
%
% Written by Jianchao Yang @ IFP UIUC
% For any questions, please email to jyang29@ifp.illinois.edu.
% 
% Revised May, 2010 by Jianchao Yang

clear all;
clc;

%% set path
addpath('large_scale_svm');
addpath('sift');
addpath(genpath('sparse_coding'));

%% parameter setting

% directory setup
img_dir = 'image';                  % directory for dataset images
data_dir = 'data';                  % directory to save the sift features of the chosen dataset
dataSet = 'Caltech101';

% sift descriptor extraction
skip_cal_sift = false;              % if 'skip_cal_sift' is false, set the following parameter
gridSpacing = 6;
patchSize = 16;
maxImSize = 300;
nrml_threshold = 1;                 % low contrast region normalization threshold (descriptor length)

% dictionary training for sparse coding
skip_dic_training = true;
nBases = 1024;
nsmp = 200000;
beta = 1e-5;                        % a small regularization for stablizing sparse coding
num_iters = 50;

% feature pooling parameters
pyramid = [1, 2, 4];                % spatial block number on each level of the pyramid
gamma = 0.15;
knn = 200;                          % find the k-nearest neighbors for approximate sparse coding
                                    % if set 0, use the standard sparse coding

% classification test on the dataset
nRounds = 5;                        % number of random tests
lambda = 0.1;                       % regularization parameter for w
tr_num = 30;                        % training number per category

rt_img_dir = fullfile(img_dir, dataSet);
rt_data_dir = fullfile(data_dir, dataSet);

%% calculate sift features or retrieve the database directory
if skip_cal_sift,
    database = retr_database_dir(rt_data_dir);
else
    [database, lenStat] = CalculateSiftDescriptor(rt_img_dir, rt_data_dir, gridSpacing, patchSize, maxImSize, nrml_threshold);
end;

%% load sparse coding dictionary (one dictionary trained on Caltech101 is provided: dict_Caltech101_1024.mat)
Bpath = ['dictionary/dict_' dataSet '_' num2str(nBases) '.mat'];
Xpath = ['dictionary/rand_patches_' dataSet '_' num2str(nsmp) '.mat'];

if ~skip_dic_training,
    try 
        load(Xpath);
    catch
        X = rand_sampling(database, nsmp);
        save(Xpath, 'X');
    end
    [B, S, stat] = reg_sparse_coding(X, nBases, eye(nBases), beta, gamma, num_iters);
    save(Bpath, 'B', 'S', 'stat');
else
    load(Bpath);
end

nBases = size(B, 2);                    % size of the dictionary

%% calculate the sparse coding feature

dimFea = sum(nBases*pyramid.^2);
numFea = length(database.path);

sc_fea = zeros(dimFea, numFea);
sc_label = zeros(numFea, 1);

disp('==================================================');
fprintf('Calculating the sparse coding feature...\n');
fprintf('Regularization parameter: %f\n', gamma);
disp('==================================================');

for iter1 = 1:numFea,  
    if ~mod(iter1, 50),
        fprintf('.\n');
    else
        fprintf('.');
    end;
    fpath = database.path{iter1};
    load(fpath);
    if knn,
        sc_fea(:, iter1) = sc_approx_pooling(feaSet, B, pyramid, gamma, knn);
    else
        sc_fea(:, iter1) = sc_pooling(feaSet, B, pyramid, gamma);
    end
    sc_label(iter1) = database.label(iter1);
end;

%% evaluate the performance of the computed feature using linear SVM

[dimFea, numFea] = size(sc_fea);
clabel = unique(sc_label);
nclass = length(clabel);

accuracy = zeros(nRounds, 1);

for ii = 1:nRounds,
    fprintf('Round: %d...\n', ii);
    tr_idx = [];
    ts_idx = [];
    
    for jj = 1:nclass,
        idx_label = find(sc_label == clabel(jj));
        num = length(idx_label);
        
        idx_rand = randperm(num);
        
        tr_idx = [tr_idx; idx_label(idx_rand(1:tr_num))];
        ts_idx = [ts_idx; idx_label(idx_rand(tr_num+1:end))];
    end;
    
    tr_fea = sc_fea(:, tr_idx);
    tr_label = sc_label(tr_idx);
    
    ts_fea = sc_fea(:, ts_idx);
    ts_label = sc_label(ts_idx);
    
    [w, b, class_name] = li2nsvm_multiclass_lbfgs(tr_fea', tr_label, lambda);

    [C, Y] = li2nsvm_multiclass_fwd(ts_fea', w, b, class_name);

    acc = zeros(length(class_name), 1);
    
    for jj = 1 : length(class_name),
        c = class_name(jj);
        idx = find(ts_label == c);
        curr_pred_label = C(idx);
        curr_gnd_label = ts_label(idx);    
        acc(jj) = length(find(curr_pred_label == curr_gnd_label))/length(idx);
    end; 
    
    accuracy(ii) = mean(acc); 
end;

fprintf('Mean accuracy: %f\n', mean(accuracy));
fprintf('Standard deviation: %f\n', std(accuracy));
    
    


