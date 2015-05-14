% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ Xsvm ] = featureCoding( params, data_file_names, label_file_names )
%FEATURECODING Summary of this function goes here
%   Detailed explanation goes here
%   encoding features for each video using different coding methods
%   input: params
%          data_file_names
%          label_file_names
%   output: Xsvm

% some parameters
if params.pca_whitening
    desc_mean = params.desc_mean;
    desc_pca = params.desc_pca;     % projection matrix
end
codebook = params.codebook;

m = length(data_file_names);
% initilize label_all
Xsvm = cell(params.num_km_init, 1);
if strcmp(params.encoding, 'Fisher')    % Fisher coding
    dim = 2 * params.num_centroids * params.feature_dim;
else
    dim = params.num_centroids;
end
for j = 1:params.num_km_init
    Xsvm{j} = zeros(m, dim);
end

for k = 1:m
    X = loadFeature( params, params.actions{label_file_names(k)}, data_file_names{k} );
    if params.pca_whitening && ~isempty(X)
        X = bsxfun(@minus, X, desc_mean);
        X = X * desc_pca;
    end
    for j = 1:params.num_km_init
        if isempty(X)
            Xsvm{j}(k, :) = zeros(1, dim);
        else
            Xsvm{j}(k, :) = Encodeing(X, params.encoding, codebook{j}, 5, 1, ...
                [], [], params.pooling, params.normalization, 0.5, []);
        end
    end

    % print clip index
    fprintf('%d ', k);
    if mod(k, 20) == 0
        fprintf('\n');
    end 
end
fprintf('\n');

end