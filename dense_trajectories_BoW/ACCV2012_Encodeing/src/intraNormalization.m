% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function normCode = intraNormalization(code, nr, alpha, dim)
% intra-normalization of super-vector based normalization
% Just only for Power+L1 or Power+L2
% INPUT: code unnormalized code
%        nr norm type
%        alpha
%        dim dimension of this feature type

% % implementation 1: 2K groups
% d = length(code);
% normCode = zeros(1, d);
% K = d / dim; 
% for i = 1:K
%     v = code((i-1)*dim + 1: i*dim);
%     v = sign(v) .* (abs(v).^alpha);
%     vnr = norm(v, nr) + eps;
%     v = bsxfun(@times, v, 1/vnr);
%     normCode((i-1)*dim + 1: i*dim) = v;
% end

% implementation 2: just only K groups
d = length(code);
normCode = zeros(1, d);
K = d / (2 * dim); 
for i = 1:K
    v = [code((i-1)*dim + 1 : i*dim) code((K+i-1)*dim + 1 : (K+i)*dim)];
    v = sign(v) .* (abs(v).^alpha);
    vnr = norm(v, nr) + eps;
    v = bsxfun(@times, v, 1/vnr);
    normCode((i-1)*2*dim + 1 : i*2*dim) = v;
end

% renormalized again 
vnr = norm(normCode, nr) + eps;
normCode = normCode * (1/vnr);

end