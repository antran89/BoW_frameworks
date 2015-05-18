function [f, df] = li2nsvm_grad(para, X, Y, lambda, sigma, gamma)

% USAGE: [f, df] = li2nsvm_grad(para, X, Y, lambda, sigma, gamma)
% compute the cost and gradient of linear SVM classifer with square-hinge loss
%
% Input:
%        para --- (d+1) by 1 vector, first d elements giving linear
%        function weights w and the rest one elements giving the bias term
%        b
%        X --- N x d matrix, N data points in a d-dim space
%        Y --- N x 1 matrix, labels of n data points -1 or 1
%        lambda --- a positive coefficient for regulerization, related to
%                   learning rate
%        sigma --- a vector of weights of training examples. Its summation
%                  will be ensured to be N in the problem. Default setting is I. 
%                  This parameter enables to deal with classification with 
%                  unbalanced data. 
%        gamma --- a d x 1 weight vector, containing positive elements,
%                  used for modifying the regularization term into w'diag(gamma)w
%
% Output:
%        f --- the cost function at current w and b
%        df --- (d + 1) dim gradient vector
%       
% Kai Yu, kai.yu@siemens.com
% Nov. 2005

N = size(X, 1);

error(nargchk(4, 6, nargin));
if nargin < 6
    gamma = [];
end
if nargin < 5
    sigma  = [];
end

[N, D] = size(X);

w = para(1:D);
b = para(D+1);

if isempty(gamma)
    lambdawgamma = w*lambda;
else
    lambdawgamma = w.*(lambda+gamma);
end

Ypred = X*w + b;
active_idx = find( Ypred.*Y < 1 );  
if isempty(active_idx)
    dw = 2*lambdawgamma;
    db = 0;
    active_E = 0;
else
    active_X = X(active_idx, :);
    active_Y = Y(active_idx, :);
    if isempty(sigma)
        active_E = Ypred(active_idx)- active_Y;
    else
        active_E = sigma(active_idx, :).*(Ypred(active_idx)- active_Y);
    end
    dw = 2*(active_E'*active_X)' + 2*lambdawgamma;  
    db = 2*sum(active_E);
end
df = [dw; db];
%err = abs( Y(active_idx, :) - Ypred(active_idx, :) ).*sigma(active_idx, :);
f = active_E'*active_E + w'*lambdawgamma;
