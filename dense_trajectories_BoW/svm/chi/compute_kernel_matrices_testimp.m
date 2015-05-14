function [K_train, K_test] = compute_kernel_matrices_testimp(M_train, M_test)
% function to compute Chi-squared kernel matrices weighted by mean distance
% (A)
% use slmetric_pw to compute paire-wise metrics, by Dahua Lin (matlab central file exchange)

addpath /afs/cs/u/wzou/mf/chi/pwmetric

A = compute_A_testimp(M_train)*4;

num_samp_train = size(M_train, 1);
num_samp_test = size(M_test, 1);

K_train = exp(-slmetric_pw(M_train', M_train', 'chisq')/A);

K_train = [(1:num_samp_train)', K_train];

K_test = exp(-slmetric_pw(M_test', M_train', 'chisq')/A);

K_test = [(1:num_samp_test)', K_test];

end
