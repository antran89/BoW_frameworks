% Create subspace structure for ISA, expressed in a single matrix
function matrix=subspacematrix(n,subspacesize)

%n is dimension of data
%subspacesize is size of subspace (!) e.g. 4

matrix=zeros(n);
for i=1:(n/subspacesize)
     for j=1:subspacesize
     for k=1:subspacesize
       offset=(i-1)*subspacesize;
       matrix(offset+j,offset+k)=1;
     end
     end
end
