% kmeans clustering
% by Michael Chen
% 01 Jul 2009 (Updated 20 Mar 2010)
% Code covered by the BSD License:
%
% Copyright (c) 2009, Michael Chen
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%     
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
%
% Retrieved from: http://www.mathworks.com/matlabcentral/fileexchange/24616-kmeans-clustering
% Modified superficially by Adam Coates, 6/1/10
function [label,center, obj] = litekmeans_obj(X, k)

X=X';
n = size(X,2);
last = 0;
label = ceil(k*rand(1,n));  % random initialization
itr=0;
MAX_ITERS=500;
fprintf('iterations: ');
while any(label ~= last)
  itr = itr+1;

  fprintf('%d ', itr);
  if mod(itr,10) == 0
     fprintf('\n');
  end
 % fprintf(1, '%d(%d)..', itr, sum(label ~= last));
  E = sparse(1:n,label,1,n,k,n);  % transform label into indicator matrix
  
  center = zeros(1,n);
  batch_size = 10000;
  num_batch = ceil(n / batch_size);
  center = double(X)*(E*spdiags(1./sum(E,1)',0,k,k));    % compute center of each cluster
  last = label;
%  tic;
  val = zeros(1, n);
  label = zeros(1, n);
  batch_size = 10000;
  num_batch = ceil(n / batch_size);
  for j=1:num_batch
    [temp_val,temp_label] = max(bsxfun(@minus,center'*X(:, (j-1)*batch_size+1: min(n, j*batch_size)),0.5*sum(center.^2,1)')); % assign samples to the nearest centers
    val((j-1)*batch_size+1: min(n, j*batch_size)) = temp_val;
    label((j-1)*batch_size+1: min(n, j*batch_size)) = temp_label;
  end
%  toc;
  if (itr >= MAX_ITERS) 
      break; 
  end;
end

fprintf('\n');

obj = 0;
Xsq = 0.5*sum(X.^2,1);
batch_size = 2000;
num_batch = ceil(n / batch_size);
csq = 0.5*sum(center.^2,1)';
for j=1:num_batch
    tempX = X(:, (j-1)*batch_size+1: min(n, j*batch_size));
    temp = bsxfun(@plus,-center'*tempX,csq);
    temp_mindist = min(bsxfun(@plus,Xsq(1,(j-1)*batch_size+1: min(n, j*batch_size)),temp));
    mindist((j-1)*batch_size+1: min(n, j*batch_size)) = temp_mindist;
    obj = obj + sum(temp_mindist);
end    

fprintf('obj value: %f\n', obj);

center=center';
