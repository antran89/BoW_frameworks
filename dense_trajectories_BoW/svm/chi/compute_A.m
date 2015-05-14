function A = compute_A(trainSet)
% compute mean value of distances over all training samples
% use slmetric_pw to compute pairewise metrics, by Dahua Lin

num_samp = size(trainSet, 1);

D = slmetric_pw(trainSet', trainSet', 'eucdist');

A = sum(sum(D))/(num_samp*(num_samp-1)); %num_samp zeros in sum

end
