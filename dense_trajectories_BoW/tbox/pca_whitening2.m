function [V,E,D] = pca_whitening2(X)

% do PCA on image patches
%
% INPUT variables:
% X                  matrix with image patches as columns
%                    dimension [d*n]
%
% OUTPUT variables:
% V                  whitening matrix [d*d] columns are sorted by
% decreasing eigenvalues
% E                  principal component transformation (orthogonal) [d*d]
% D                  variances of the principal components [1*d]


% Calculate the eigenvalues and eigenvectors of the new covariance matrix.
covarianceMatrix = X*X'/size(X,2);
[E, D] = eig(covarianceMatrix);

% Sort the eigenvalues  and recompute matrices
[dummy,order] = sort(diag(-D));
E = E(:,order);
d = diag(D); 
dsqrtinv = real(d.^(-0.5));
Dsqrtinv = diag(dsqrtinv(order));
D = diag(d(order));
V = Dsqrtinv*E';



