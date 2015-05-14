% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ Xtrain, Xtest ] = featureCodingPooling2( params,...
    all_train_files, all_train_labels, all_test_files, all_test_labels )
%FEATURECODINGPOOLING Summary of this function goes here
%   Detailed explanation goes here
%   feature coding and feature pooling
%   input: params - parameters
%           all_train_files - training files
%           all_test_files - testing files
%           threshold - number of features, we need to samples
% output: Xtrain - training vectors
%         Xtest - testing vectors

fprintf('------------%s feature-------------\n', params.feature_type);

%% ----------------------sampling features---------------------------------
fprintf('Sampling features for all videos in the training set:\n');
[X] = sample_features(params, all_train_files, all_train_labels, params.threshold);
fprintf('Total number of sampled features %d\n', size(X, 1));
dim = size(X, 2);
params.feature_dim = dim;
fprintf('feature dimensions: %d\n', params.feature_dim);

%% ----------------------preprocessing data--------------------------------
% do PCA-whitening
if params.pca_whitening
    desc_mean = mean(X, 1); % demean
    %desc_mean = zeros(1, dim); %don't demean
    % Center X by subtracting off column means
    X0 = bsxfun(@minus, X, desc_mean);
    desc_pca = pca_whitening( params, X0, dim/2 );
    X = X0*desc_pca;
    clear X0
    params.desc_mean = desc_mean;   % mean of train data
    params.desc_pca = desc_pca;     % projection matrix
    params.feature_dim = size(desc_pca, 2);
end
fprintf('feature dimensions after PCA-whitening: %d\n', params.feature_dim);

%% ----------------------train a codebook----------------------------------
fprintf('Start learning BoW codebook on training samples:\n');
if strcmp(params.encoding, 'Fisher')    % GMM codebook
    % Yeal GMM
    [w, mu, sigma] = yael_gmm(X', params.num_centroids, 'redo', 10, 'niter', 500, 'nt', 8);
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
            C = yael_kmeans(X', params.num_centroids, 'niter', 500, 'redo', 5);
            codebook{1} = C';
        case 'vlfeat'
            % vlfeat kmeans
            [C, ~] = vl_kmeans(X', params.num_centroids, 'algorithm', 'elkan', ...
                'numrepetitions', 5, 'MaxNumComparisons', params.num_centroids);
            codebook{1} = C';
        case 'matlab'
            % matlab implementation of kmeans algorithm
            [~, codebook{1}] = kmeans(X, params.num_centroids, 'MaxIter', 500, 'Replicates', 5);
    end
    
end
params.codebook = codebook;
clear X

%% ------------------------feature coding----------------------------------
Xtrain = featureCoding(params, all_train_files, all_train_labels);
Xtest = featureCoding(params, all_test_files, all_test_labels);

end
