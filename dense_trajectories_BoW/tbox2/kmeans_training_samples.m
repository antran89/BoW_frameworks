function [center_all, km_obj] = kmeans_training_samples(Xtrain_raw, params)
%% Running K-means to find codewords

center_all = cell(params.num_km_init, 1);
km_obj = cell(params.num_km_init, 1);

%%--------------Do kmeans on random sampled training data------------------

tot_num_samples = size(Xtrain_raw, 1);

fprintf('total number of training samples for k-means: %d\n', tot_num_samples);

% random seed guarantees samples corresponding to same video positions are
% used % for different bases

rand('state', params.seed);

for ini_idx = 1:params.num_km_init        
    fprintf('compute kmeans: %d th initialization\n', ini_idx);
    rand('state', params.seed + 10*ini_idx);

    [~, center_all{ini_idx}, km_obj{ini_idx}] = litekmeans_obj(Xtrain_raw, params.num_centroids);  
end

end
