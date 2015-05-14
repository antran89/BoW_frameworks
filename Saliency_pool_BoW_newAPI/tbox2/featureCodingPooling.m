% Copyright (C) 2015 Tran Lam An.
% This code is for research, please do not distribute it.

function [ Xtrain, Xtest ] = featureCodingPooling( params,...
    all_train_files, all_train_labels, all_test_files, all_test_labels )
%FEATURECODINGPOOLING Summary of this function goes here
%   Detailed explanation goes here
%   feature coding and feature pooling
%   Input: params - parameters
%          all_train_files - training files
%          all_test_files - testing files
%          threshold - number of features, we need to samples
%   Output: Xtrain - training vectors
%           Xtest - testing vectors

fprintf('------------%s feature-------------\n', params.feature_type);

%% ----------------------preprocessing data--------------------------------
% do PCA-whitening
if params.pca_whitening
    fprintf('Starting learning PCA for training features\n');
    %X = randomSampleFeatures(params, all_train_files, all_train_labels, params.pcaSamplingThreshold);
    X = sample_features2(params, all_train_files, all_train_labels, params.pcaSamplingThreshold);
    dim = size(X, 2);
    desc_mean = mean(X, 1); % demean
    % desc_mean = zeros(1, dim); %don't demean
    % Center X by subtracting off column means
    X0 = bsxfun(@minus, X, desc_mean);
    desc_pca = pca_whitening( params, X0, dim/2 );
    clear X0 X
    params.desc_mean = desc_mean;   % mean of train data
    params.desc_pca = desc_pca;     % projection matrix
    fprintf('feature dimensions before PCA-whitening: %d\n', dim);
    fprintf('feature dimensions after PCA-whitening: %d\n', size(desc_pca, 2));
end

%% ----------------------sampling features---------------------------------
fprintf('Sampling features for all videos in the training set:\n');
X = sample_features2(params, all_train_files, all_train_labels, params.threshold);
fprintf('Total number of sampled features %d\n', size(X, 1));
if params.pca_whitening
    X0 = bsxfun(@minus, X, desc_mean);
    X = X0*desc_pca;
end
params.feature_dim = size(X, 2);
fprintf('feature dimensions: %d\n', params.feature_dim);

%% ----------------------train a codebook----------------------------------
fprintf('Start learning BoW codebook on training samples:\n');
if strcmp(params.encoding, 'Fisher')    % GMM codebook
    % Yeal GMM
    [w, mu, sigma] = yael_gmm(X', params.num_centroids, 'redo', 5, 'niter', params.maxIter, 'nt', 8);
    codebook{1}.w = w;
    codebook{1}.mu = mu;
    codebook{1}.sigma = sigma;
else    % kmeans codebook
    switch params.km_method
        case 'michael'
            % collected kmeans code (Michael Chen)
            [codebook, ~] = kmeans_training_samples(Xtrain_raw, params);
        case 'yael'
            % yael kmeans testing
            C = yael_kmeans(X', params.num_centroids, 'niter', params.maxIter, 'redo', 5);
            codebook{1} = C';
        case 'vlfeat'
            % vlfeat kmeans
            [C, ~] = vl_kmeans(X', params.num_centroids, 'algorithm', 'elkan', 'MaxNumIterations', params.maxIter,...
                'numrepetitions', 5, 'MaxNumComparisons', params.num_centroids);
            codebook{1} = C';
        case 'matlab'
            % matlab implementation of kmeans algorithm
            [~, codebook{1}] = kmeans(X, params.num_centroids, 'MaxIter', params.maxIter, 'Replicates', 5);
    end
    
end
params.codebook = codebook;
clear X0 X

%% ------------------------feature coding----------------------------------
Xtrain = featureCoding(params, all_train_files, all_train_labels);
Xtest = featureCoding(params, all_test_files, all_test_labels);

end
