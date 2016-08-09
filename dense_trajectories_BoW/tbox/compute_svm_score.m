% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [score] = compute_svm_score(Ktest, model, kernel)
% compute_svm_score
% Ktest : test features matrix or test kernel matrix depend on kernel
% variable
% model : SVM model
% kernel : a string indicates whether kernel is 'linear' (for linear
% kernel), and 'kernel' (for other type of kernel)

% NOTICE: rho = -b in formulation w'x+b
%           need to revert score of SVM if the first lable is negative
%           (VERY IMPORTANT) ? Why?
% explained in http://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html#f804

if strcmp(kernel, 'kernel')
    score = model.sv_coef' *  Ktest(:, model.sv_indices)' - model.rho;
elseif strcmp(kernel, 'linear')
    w = model.sv_coef' * model.SVs;
    score = w * Ktest' - model.rho;
else
    disp('wrong arguments for kernel');
end
% check if first label is negative
if model.Label(1) == 0  % here 0 is negative, 1 is positive
    score = -score;
end
score = score';
end