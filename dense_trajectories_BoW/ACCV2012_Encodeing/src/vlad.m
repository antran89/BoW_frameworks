% Compute a vlad descriptors from a set of local descriptors
%
% Usage v = vlad (centroids, s)
%
% where
%   centroids is the dictionary of centroids 
%   s         is the set of descriptors
%
% Both centroids and descriptors are stored per column
function v = vlad (centroids, s)

n = size (s, 2);          % number of descriptors
d = size (s, 1);          % descriptor dimensionality
k = size (centroids, 2);  % number of centroids

% find the nearest neigbhors for each descriptor
[idx, dis] = yael_nn (centroids, s);

v = zeros (d, k);

for i = 1:n
  v (:, idx(i)) = v (:, idx(i)) + s(:, i) - centroids (:, idx(i));
end

v = reshape (v, 1, k*d);

if norm (v) == 0
  v = ones (1, d*k);
%else
%  v = v ./ norm(v);
end