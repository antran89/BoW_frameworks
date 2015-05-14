function A = comp_A(trainSet, dist_type)
% compute mean value of distances over all training samples
% use slmetric_pw to compute pairewise metrics, by Dahua Lin

num_samp = size(trainSet, 1);

D = slmetric_pw(trainSet', trainSet', dist_type);

A = sum(sum(D))/(num_samp*(num_samp-1)); %num_samp zeros in sum

end
