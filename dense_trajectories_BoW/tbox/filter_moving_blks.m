load ~/s9/ncbases/bs/hw_bases_hszrds_np200_gray_20_1_40_isa_14_300_1.mat
%load data


addpath ~/mf/s3isa
addpath ~/mf/s3isa/tbox/
addpath ~/mf/s3isa/activation_functions/

pa_layer.type = 'none';
pa_layer.usegpu = 0;

act = activateISA(X(1:5600, :), isanetwork{1}, pa_layer);

hist(sum(act));

norm = sum(act);
filter = norm>250;
Xtest = X(:, filter);

%addpath ~/mf/tbox/
%Xtest = reshape(Xtest, 400, []);
%dispimgs(Xtest, 20, 20, 'gray', 0.2);
