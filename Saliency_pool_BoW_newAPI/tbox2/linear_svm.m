% Copyright (C) 2015 Tran Lam An.
% This code is for research, please do not distribute it.

function [mean_ap, acc2, perclass_acc] = linear_svm(params, action_feature,...
			   all_train_labels, all_test_labels, ini_idx)
%NORMALIZE_LINEAR_SVM Summary of this function goes here
%   Detailed explanation goes here
%   Using linear SVM to classify high dimensional data
%   Notice the curse of dimensionality: If the dimension of data is large,
%   we need more data to ensure that performance gradually increases when
%   dimensions also gradually increase
%   For linear svm, you should compute kernels first, then pass it into svm.
%   It makes your program faster
%   INPUT:  params,
%           action_feature
%           all_train_labels
%           all_test_labels
%           ini_idx
%   OUTPUT: mean_ap

%% load labels, run svm
l = length(params.actions);

%%---------------------run SVM to classify data---------------------------
 
fprintf('start classfication with linear kernel svm......\n');

% compute linear kernel
[Ktrain, Ktest] = computeLinearKernel( params, action_feature, ini_idx );

average_ap = 0;
average_acc = 0;
tp = 0;
svm_score = zeros(length(all_test_labels), l);

if isfield(params, 'cost')
    cost = params.cost;
else
    cost = 100; % chosen as fixed: on personal communication with Wang et. al [42] paper citation
end

fprintf('learn svm models......\n');

for label=1:l

    Ytrain_new = double(all_train_labels == label);
    Ytest_new = double(all_test_labels == label);
    
    n_total = length(Ytrain_new);
    n_pos = sum(Ytrain_new);
    n_neg = n_total-n_pos;
    
    % positive and negative weights balanced with number of positive and
    % negative examples
    % on personal communication with Wang et. al [42] paper citation
    w_pos = n_total/(2*n_pos);
    w_neg = n_total/(2*n_neg);
    
    option_string = sprintf('-t 4 -q -s 0 -b 1 -c %f -w1 %f -w0 %f',cost, w_pos, w_neg);

    model = svmtrain(Ytrain_new, Ktrain, option_string);
    
    [predicted_label, accuracy, prob_estimates] = svmpredict(Ytest_new, Ktest, model, '-b 1');
    
    [ap, ~, ~] = computeAP(prob_estimates(:, model.Label==1), Ytest_new, 1, 0, 0);
    
    svm_score(:,label) = compute_svm_score(Ktest(:, 2:end), model, 'kernel');
        
    tp = tp + sum(predicted_label .* Ytest_new);
    average_ap = average_ap + ap;
    average_acc = average_acc + accuracy(1);
    
    fprintf('label = %d,ap = %f, w_neg = %f, w_pos = %f\n', label,  ap, w_neg, w_pos);    
end
[~, predicted_label2] = max(svm_score, [], 2);
acc2 = sum(predicted_label2 == all_test_labels) / length(all_test_labels);
acc = tp / length(all_test_labels);
mean_ap = average_ap / l;
mean_acc = average_acc / l;
fprintf('mean_ap = %f, mean_acc = %f, acc = %f acc2 = %f\n', mean_ap, mean_acc, acc, acc2);

% computer per-class accurarcy
[perclass_acc] = compute_perclass_accurarcy(predicted_label2, all_test_labels, l);

end