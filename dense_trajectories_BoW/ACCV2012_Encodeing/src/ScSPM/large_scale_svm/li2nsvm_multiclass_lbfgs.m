function [w, b, class_name] = li2nsvm_multiclass_lbfgs(X, C, lambda, gamma)

% USAGE: [w, b, class_name] = li2nsvm_multiclass_lbfgs(X, C, lambda, gamma)
% linear multi-class SVM classifer with square-hinge loss, trained via
% lbfgs, one-against-all decomposition
%
% Input:
%        X --- N x d matrix, n data points in a d-dim space
%        C --- N x 1 matrix, labels of n data points 
%        lambda --- a positive coefficient for regulerization, related to
%                   learning rate
%        gamma --- d x class_name weight vector of positive elements,
%                  used for modifying the regularization term into
%                  w(:,c)'[lambda+diag(gamma(:,c))]w(:,c) for each class c.
%
% Output:
%        w --- d x k matrix, each column is a function vector
%        b --- 1 x k the estimated bias term, k is the class number
%       
% Kai Yu, Aug. 2008

error(nargchk(3, 4, nargin));
if nargin < 4
    gamma = [];
end

[Y, class_name] = oneofc(C);
Y = sign(Y-0.5);
dim = size(X,2);
cnum = size(Y,2);

w = zeros(dim,cnum);
b = zeros(1,cnum);

for i = 1 : cnum
%     fprintf('training class %d of %d ... \n', i, cnum);
    if isempty(gamma)
        [w(:,i), b(i)] = li2nsvm_lbfgs(X, Y(:,i), lambda);
    else
        [w(:,i), b(i)] = li2nsvm_lbfgs(X, Y(:,i), lambda, [], gamma(:,i));
    end
end


