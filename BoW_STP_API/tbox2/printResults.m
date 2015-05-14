% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function printResults( params, acc, mean_ap, perclass_acc )
%PRINTRESULTS Summary of this function goes here
%   Detailed explanation goes here
%   Print the results into results.txt file
%   INPUT:  params
%           acc             accuracy
%           mean_ap         mAP
%           perclass_acc    perclass_acc

mean_perclass_acc = mean(perclass_acc, 2);
l = length(params.actions);

fid = fopen('results.txt', 'a');
fprintf(fid, '\n----------------%s RESULTS----------------\n', params.dataset);
fprintf(fid, '---------------Experiment descriptions---------------\n');
fprintf(fid, 'experiment objective: %s\n', params.exp_descriptions);
fprintf(fid, 'feature descriptors:');
for c = 1:params.num_channels
    fprintf(fid, ' %s', params.type{c});
end
fprintf(fid, '\nsampling %d features for training a codebook\n', params.threshold);
fprintf(fid, 'number of centroids in codebook: %d\n', params.num_centroids);
if ~strcmp(params.encoding, 'Fisher')
    fprintf(fid, 'k-means implementation: %s\n', params.km_method);
end
fprintf(fid, 'max number of iterations in k-means: %d\n', params.maxIter);
fprintf(fid, 'grid structure: ');
for idx = 1:length(params.grid)
    fprintf(fid, '%d ', params.grid(idx));
end
fprintf(fid, '\n');
if params.pca_whitening && params.whiteningFlag
    fprintf(fid, 'do PCA whitening\n');
    fprintf(fid, 'whitening regularizer: %f\n', params.whiteningReg);
elseif params.pca_whitening && ~params.whiteningFlag
    fprintf(fid, 'do only PCA\n');    
else
    fprintf(fid, 'NOT using PCA whitening\n');
end
if params.pca_whitening
    fprintf(fid, 'sampling %d features to train PCA\n', params.pcaSamplingThreshold);
end
fprintf(fid, 'encoding method: %s\n', params.encoding);
fprintf(fid, 'total feature dimensions: %d\n', params.total_dim);
fprintf(fid, 'pooling method: %s\n', params.pooling);
fprintf(fid, 'normalization: %s\n', params.normalization);
fprintf(fid, 'classifier: %s\n', params.classifier);
if strcmp(params.classifier, 'kernel_svm')
    fprintf(fid, 'kernel: %s\n', params.kernel);
end
fprintf(fid, 'cost c = %d\n', params.cost);
fprintf(fid, 'performance measure: %s\n', params.eval);

for idx = 1:params.no_splits
    fprintf(fid, '%d th split: mean_ap = %f, acc = %f\n', idx, mean_ap(idx), acc(idx));
end
fprintf(fid, 'Final results after %d splits: mean_ap (mAP) = %f, average accuracy (acc) = %f\n', params.no_splits, mean(mean_ap), mean(acc));
fprintf(fid, 'Final results after %d splits: average class accuracy: %f\n', params.no_splits, mean(mean_perclass_acc));
fprintf(fid, 'Conclusions:\n');

fprintf(fid, 'Per-class accuracy for each splits: ...\n');
for idx = 1:l
    fprintf(fid, 'Class %d: ... ', idx);
    for i = 1:params.no_splits
        fprintf(fid, '%0.2f ', perclass_acc(idx, i));
    end
    fprintf(fid, '\n');
end

fprintf(fid, 'Mean per-class accuracy: ...\n');
for idx = 1:l
    fprintf(fid, 'Accuracy of class %d: %f\n', idx, mean_perclass_acc(idx));
end

date = datestr(now, 'yyyy-mm-dd-HH-MM');
fprintf(fid, '-----saving at SAVEPATH ....%s  %s------\n', params.savepath, date);
% timing
t_elapse = toc;
fprintf('total time is %f hours\n', t_elapse/3600);
fprintf(fid, 'total time is %f hours\n', t_elapse/3600);
fclose(fid);

end

