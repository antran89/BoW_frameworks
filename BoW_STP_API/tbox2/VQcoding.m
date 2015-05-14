% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [ code ] = VQcoding( K, label )
%VQCODING Summary of this function goes here
%   Detailed explanation goes here
%   Vector quantization
%   Input:  K = number of centroids
%           label = nearest neighbors of features
%   Output: code = VQ code

code = zeros(1, K);
N = length(label);
if N == 0, return; end;

for i = 1:N
    code(label(i)) = code(label(i)) + 1;
end

% L1 normalization
code = code/N;

end

