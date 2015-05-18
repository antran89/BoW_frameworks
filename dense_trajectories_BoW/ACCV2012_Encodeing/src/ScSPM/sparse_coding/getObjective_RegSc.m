function [fobj, fresidue, fsparsity, fregs] = getObjective_RegSc(X, B, S, Sigma, beta, gamma)

Err = X - B*S;

fresidue = 0.5*sum(sum(Err.^2));

fsparsity = gamma*sum(sum(abs(S)));

fregs = 0;
for ii = 1:size(S, 2),
    fregs = fregs + beta*S(:, ii)'*Sigma*S(:, ii);
end

fobj = fresidue + fsparsity + fregs;