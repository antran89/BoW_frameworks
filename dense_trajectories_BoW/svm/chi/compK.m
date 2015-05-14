function Kcolumn = compK(v, Mtrain ,A)
%this function implements the Chi squared kernel
%returns a whole column (or row) of the kernel matrix
%A is the mean value of distances between all training samples

v = v+1e-10;
Mtrain = Mtrain;

no_samp = size(Mtrain,1);

tgt = repmat(v,no_samp,1);

Kcolumn = exp(-1/(2*A)*sum((tgt-Mtrain).^2./(tgt+Mtrain),2));

end
