%quick wrapper for min Euclidean distance for kmeans labeling

function vword = findvword(vocab, X)
%   tic
   center = vocab';
   X = X';
   % because features are L2-normalize
   % [val,vword] = max(bsxfun(@minus,center'*X,0.5*sum(center.^2,1)')); ...
   tmp = bsxfun(@minus, sum(X.^2, 1), 2*center'*X);
   [~, vword] = min(bsxfun(@plus, tmp, sum(center.^2,1)'));
   % assign samples to the nearest centers   
   vword = vword';
%   toc
end
