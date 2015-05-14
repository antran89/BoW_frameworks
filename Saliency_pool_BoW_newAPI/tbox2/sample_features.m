% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [Xall] = sample_features(params, data_file_names, label_file_names, threshold)
%SAMPLE_FEATURES Summary of this function goes here
%   Detailed explanation goes here
%   Sampling features to train a codebook
%   input: params
%          data_file_names  list of file names
%          label_file_names  labels of file names
%   output: Xall

% % subsample data_file_names
% if exist('num_movies', 'var')&&(num_movies>0)    
%     m = length(data_file_names);
%     p = randperm(m);
%     p = p(1:num_movies); % if no input, take all movies
%     data_file_names = data_file_names(p,:);  
% end

m = length(data_file_names);
Xclip = loadFeature( params, params.actions{label_file_names(1)}, data_file_names{1});
num_features = size(Xclip, 2);

%% randomly sampling
% get 100000 samples for codebook learning
disp('couting number of samples ...')
if exist('noSamples.mat', 'file')
    load('noSamples.mat');
else
    no_samples = 0;
    for i = 1:m
        % load feature into a big matrix
        % tic 
        Xclip = loadFeature( params, params.actions{label_file_names(i)}, data_file_names{i});
        no_samples = no_samples + size(Xclip, 1);
    end
    save('noSamples.mat', 'no_samples');
end
fprintf('total number of samples %d\n', no_samples);

%% sampling proportionally per video
%% sampling no.1
% randomly sampling in whole block.

% p = randperm(no_samples);
% out_samples = p(1:threshold);
% clear p;
% out_samples = sort(out_samples);
% 
% ind = 1;
% for i = 1:m
%     % load feature into a big matrix
%     % tic 
%     S = load(fullfile(params.featurepath, params.feature_type, ...
%         strcat(params.feature_type,'_',data_file_names{i},'.mat')));
%     X_clip = S.feature;
%     Xall_fill_new = Xall_fill + size(X_clip,1);
%     while (out_samples(ind) > Xall_fill && out_samples(ind) <= Xall_fill_new)
%         Xall(ind, :) = X_clip(out_samples(ind)-Xall_fill, :);
%         ind = ind+1;
%         if ind > threshold
%             break;
%         end
%     end
%     Xall_fill = Xall_fill_new;
% end
% assert(Xall_fill == no_samples);

%% sampling no.2
% randomly proportionally per video.
Xall_fill = 0;
p = ceil(threshold/m);
Xall = zeros(threshold, num_features, 'single');

for i = 1:m
    % load feature into a big matrix
    % tic 
    Xclip = loadFeature(params, params.actions{label_file_names(i)}, data_file_names{i});
    if size(Xclip, 1) == 0
        continue;
    elseif p < size(Xclip,1)
        randInd = randperm(size(Xclip,1));
        ind = randInd(1:p);
    else
        ind = 1:size(Xclip,1);
    end
    Xall(Xall_fill + 1 : Xall_fill+length(ind), :) = Xclip(ind, :);
    Xall_fill = Xall_fill + length(ind);
    % update p again
    if i ~= m
        p = ceil((threshold - Xall_fill) / (m - i));
    end
end
if Xall_fill < size(Xall, 1)
    Xall = Xall(1:Xall_fill, :);
end 

% %% sampling no.3
% % sampling all features in a video
% p = randperm(m);
% data_file_names = data_file_names(p, :);  
% Xall_fill = 0;
% Xall = zeros(threshold, num_features, 'single');
% i = 0;
% while Xall_fill < threshold
%     i = i + 1;
%     S = load(fullfile(params.featurepath, params.feature_type, ...
%         strcat(params.feature_type,'_',data_file_names{i}(1:end-4),'.mat')));
%     Xclip = S.feature;
%     if Xall_fill + size(Xclip, 1) > threshold
%         remaining = threshold - Xall_fill;
%         Xall(Xall_fill + 1 : end, :) = Xclip(1:remaining, :);
%         Xall_fill = threshold;
%     else
%         Xall(Xall_fill + 1 : Xall_fill + size(Xclip, 1), :) = Xclip;
%         Xall_fill = Xall_fill + size(Xclip, 1);  
%     end
% end

end