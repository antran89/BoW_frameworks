function [code]=Encodeing(feature,Method,codebook,KNN,beta,lambda,sigma,pooling,Normalization,alpha,A)
%% input feature :N*dim matrix
%% input codebook : N*dim matrix
%% KNN a integer,belong [1 size(codebook,1)]
%% beat : param for SA Encodeing
%% lambda : param for SPC Encodeing
%% sigma : param for KCB Encodeing
%% pooling  select 'sum-pooling' or 'max-pooling',the VQ and FK Encodeing default value is 'sum-pooling'
%% Normalization : 'L1','L2','P+L1','P+L2'
%% alpha : param for Power Normalization
%% A : speed the SPC encodeing at big dataset,

[feature_vote]=Vote(feature,Method,codebook,KNN,beta,lambda,sigma,A,pooling);
switch pooling
    case 'max-pooling'
        code=max(feature_vote,[],1);
    case 'sum-pooling'
        code=sum(feature_vote,1);
    case 'mix-ord-pooling'
    case 'sum-max-pooling'
    case 'No'
end

switch Normalization
    case 'Power'
        code=sign(code).*(abs(code).^alpha);
    case 'L1'
        code=code./(sum(abs(code),2)+eps);
    case 'L2'
        code=code./(sum(code.^2,2).^(0.5)+eps);
    case 'Power+L1'
        code=sign(code).*(abs(code).^alpha);
        code=code./(sum(abs(code),2)+eps);
    case 'Power+L2'
        code=sign(code).*(abs(code).^alpha);
        code=code./(sum(code.^2,2).^(0.5)+eps);
    case 'Intra+Power+L2'
        dim = size(feature, 2);
        code = intraNormalization(code, 2, alpha, dim);
    case 'Intra+Power+L1'
        dim = size(feature, 2);
        code = intraNormalization(code, 1, alpha, dim);
    case 'No'
end
