load ./data/stip_1000.mat;
load ./data/ubm_16.mat
load ./data/stip_data.mat

%% VQ
[code_VQ_P_L2]=Encodeing(feature,'VQ',C,[],[],[],[],'sum-pooling','Power+L2',0.5,[]);
%% LLC
%if KNN=[],KNN will equal to defina value:5
[code_LLC_max_L2]=Encodeing(feature,'LLC',C,[],[],[],[],'max-pooling','L2',[],[]);
[code_LLC_sum_P_L2]=Encodeing(feature,'LLC',C,[],[],[],[],'sum-pooling','Power+L2',0.5,[]);
%% SA
%if KNN equal codebook size,the result is SA-all,else is SA-K,the recommend K value is 5.recommend beta is 1
%SA-all
[code_SA_all_1_sum_P_L2]=Encodeing(feature,'SA',C,size(C,1),1,[],[],'sum-pooling','Power+L2',0.5,[]);
[code_SA_all_1_max_L2]=Encodeing(feature,'SA',C,size(C,1),1,[],[],'max-pooling','L2',[],[]);
%SA-K
[code_SA_K_5_1_sum_P_L2]=Encodeing(feature,'SA',C,5,1,[],[],'sum-pooling','Power+L2',0.5,[]);
[code_SA_K_5_1_max_L2]=Encodeing(feature,'SA',C,5,1,[],[],'max-pooling','L2',[],[]);
%% SPC
[code_SPC_max_L2]=Encodeing(feature,'SPC',C,[],[],[],[],'max-pooling','L2',[],[]);
%for to speed encoding for dataset ,you can precomputed compute the A used in sparse codeing
beta = 1e-4;
A=C*C' + 2*beta*eye(size(C,1));
[code_SPC_max_L2]=Encodeing(feature,'SPC',C,[],[],[],[],'max-pooling','L2',[],A);
%% FK
[code_FK_162_16_sum_P_L2]=Encodeing(feature,'FK',ubm,[],[],162,16,'sum-pooling','Power+L2',0.5,[]);

