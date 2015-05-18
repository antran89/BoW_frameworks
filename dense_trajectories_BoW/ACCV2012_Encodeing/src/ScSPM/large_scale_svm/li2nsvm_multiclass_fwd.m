function [C Y] = li2nsvm_multiclass_fwd(X, w, b, class_name)

% function [C Y] = li2nsvm_multiclass_fwd(X, w, b, class_name):
% make multi-class prediction

Y = X*w + +repmat(b,[size(X,1),1]);
C = oneofc_inv(Y, class_name);
% accuracy = sum(Yte==Cte)/size(Yte,1);
% fprintf('the accuracy is %f \n', accuracy);

