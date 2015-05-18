function [w, b] = li2nsvm_lbfgs(X, Y, lambda, sigma, gamma)

% USAGE: [w, b] = li2nsvm_lbfgs(X, Y, lambda, sigma, gamma)
% linear SVM classifer with square-hinge loss, trained via lbfgs
%
% Input:
%        X --- N x d matrix, n data points in a d-dim space
%        Y --- N x 1 matrix, labels of n data points -1 or 1
%        lampda --- a positive coefficient for regulerization, related to
%                   learning rate
%        sigma --- a vector of weights of training examples. Its summation
%                  will be ensured to be N in the problem. Default setting is I. 
%                  This parameter enables to deal with classification with 
%                  unbalanced data. 
%        gamma --- a d x 1 weight vector of positive elements,
%                  used for modifying the regularization term into
%                  w'diag(gamma)w
%
% Output:
%        w --- d x 1 matrix, each column is a function vector
%        b --- the estimated bias term
%       
% Kai Yu, Aug. 2008

error(nargchk(3, 5, nargin));
if nargin < 5
    gamma = [];
end
if nargin < 4
    sigma  = [];
end

[N, D] = size(X); 

w0 = zeros(D,1);
b0 = 0;

wolfe = struct('a1',0.5,'a0',0.01,'c1',0.0001,'c2',0.9,'maxiter',10,'amax',1.1);
lbfgs_options = struct('maxiter', 30, ...
                       'termination', 1.0000e-004, ...
                       'xtermination', 1.0000e-004, ...
                       'm', 10, ...
                       'wolfe', wolfe, ...
                       'echo', false);
          
[retval, xstarbest, xstarfinal, history] = lbfgs2([w0; b0], lbfgs_options, 'li2nsvm_grad', [], X, Y, lambda, sigma, gamma);

w = xstarbest(1:D);
b = xstarbest(D+1);



