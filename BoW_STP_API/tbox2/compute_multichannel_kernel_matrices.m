% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [K_train, K_test] = compute_multichannel_kernel_matrices(params, action_feature, ini_idx, mode)
% function to compute multi-channel Chi-squared kernel matrices weighted by mean distance (A)
% use slmetric_pw to compute paire-wise metrics, by Dahua Lin (matlab central file exchange)
% constant K to multiply with average distance.

if(nargin < 4)
   mode = 'both'; 
end

% note: A is mean distance (chi-squared) between all samples, generally multiply by a factor works better
if isunix()     % for unix
    A = zeros(1, params.num_channels);
    for c = 1:params.num_channels
        A(c) = compute_Average(action_feature{c}.Xtrain{ini_idx})*params.const_K;
    end

    if strcmp(mode, 'both')||strcmp(mode, 'train')
        num_samp_train = size(action_feature{1}.Xtrain{ini_idx}, 1);
        M_chi = zeros(num_samp_train, num_samp_train);
        for c = 1:params.num_channels
            M_train = action_feature{c}.Xtrain{ini_idx};
            M_chi = M_chi + chi2_mex(M_train', M_train')/(2*A(c));
        end
        K_train = exp(-M_chi);
        K_train = [(1:num_samp_train)', K_train];
    else
        K_train = [];
    end

    if strcmp(mode, 'both')||strcmp(mode, 'test')
        num_samp_train = size(action_feature{1}.Xtrain{ini_idx}, 1);
        num_samp_test = size(action_feature{1}.Xtest{ini_idx}, 1);
        M_chi = zeros(num_samp_test, num_samp_train);
        for c = 1:params.num_channels
            M_train = action_feature{c}.Xtrain{ini_idx};
            M_test = action_feature{c}.Xtest{ini_idx};
            M_chi = M_chi + chi2_mex(M_test', M_train')/(2*A(c));
        end
        K_test = exp(-M_chi);    
        K_test = [(1:num_samp_test)', K_test];
    else
        K_test = [];
    end
elseif ispc()   % for Windows
    A = zeros(1, params.num_channels);
    for c = 1:params.num_channels
        %A(c) = compute_A_testimp(action_feature{c}.Xtrain{ini_idx})*2;
        A(c) = compute_A_testimp(action_feature{c}.Xtrain{ini_idx})*params.const_K;
    end

    if strcmp(mode, 'both')||strcmp(mode, 'train')
        num_samp_train = size(action_feature{1}.Xtrain{ini_idx}, 1);
        M_chi = zeros(num_samp_train, num_samp_train);
        for c = 1:params.num_channels
            M_train = action_feature{c}.Xtrain{ini_idx};
            M_chi = M_chi + slmetric_pw(M_train', M_train', 'chisq')/A(c);
        end
        K_train = exp(-M_chi);
        K_train = [(1:num_samp_train)', K_train];
    else
        K_train = [];
    end

    if strcmp(mode, 'both')||strcmp(mode, 'test')
        num_samp_train = size(action_feature{1}.Xtrain{ini_idx}, 1);
        num_samp_test = size(action_feature{1}.Xtest{ini_idx}, 1);
        M_chi = zeros(num_samp_test, num_samp_train);
        for c = 1:params.num_channels
            M_train = action_feature{c}.Xtrain{ini_idx};
            M_test = action_feature{c}.Xtest{ini_idx};
            M_chi = M_chi + slmetric_pw(M_test', M_train', 'chisq')/A(c);
        end
        K_test = exp(-M_chi);    
        K_test = [(1:num_samp_test)', K_test];
    else
        K_test = [];
    end
end

end

function A = compute_Average(trainSet)
% compute mean value of distances over all training samples
% use mpi-chi2 to compute pairewise metrics, by Christoph Lampert 

num_samp = size(trainSet, 1);

D = chi2_mex(trainSet', trainSet')/2;

A = sum(sum(D))/(num_samp*(num_samp-1)); %num_samp zeros in sum

end