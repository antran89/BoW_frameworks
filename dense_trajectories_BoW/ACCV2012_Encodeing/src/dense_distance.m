function [Distance]=dense_distance(H1,H2,computeUnit,SPM,SPM_weight_vector,SPMTempfFilename,mode,param)
%%[Distance]=dense_distance(H1,H2,computeUnit,SPM,SPM_weight_vector,SPMTempfFilename,mode,param)
%%H1:num1 x dim,H2:num x dim. Distance will be num1 x num2. 
%%mode can be 0: L_p distance(p determined by param), 1: Chi2 distance, 2: Histogram Intersection. 
%%param determines parameters for each method (pass empty if no param is required), it can be 0 for L_inf, or 1 or 2 for L_1 or L_2.
%For any questions, feel free to email me at wangxingxing.hz@gmail.com.
if SPM>1
if exist(SPMTempfFilename,'file')~=2
    SPMEMD=zeros(21,size(H1,2),size(H2,2));
    tempDistance=zeros(size(H1,2),size(H2,2));
    for j=1:21
        tempA=reshape(H1(j,:,:),size(H1,2),size(H1,3));
        tempB=reshape(H2(j,:,:),size(H2,2),size(H2,3));
        switch computeUnit
            case 0
                switch mode
                    case 0
                        switch param
                            case 1
                            case 2
                                tempAA = sum(tempA.*tempA,1);
                                tempBB = sum(tempB.*tempB,1);
                                tempAB = tempA'*tempB;
                                tempDistance = abs(repmat(tempAA',[1 size(tempBB,2)]) + repmat(tempBB,[size(tempAA,2) 1]) - 2*tempAB);
                        end
                    case 1
                        parfor i=1:size(tempDistance,2)
                            tempDistance(:,i)=0.5*sum(bsxfun(@rdivide,bsxfun(@power,bsxfun(@minus,tempA',tempB(i,:)'),2),...
                                bsxfun(@plus,tempA',tempB(i,:)')+eps));
                        end
                end
            case 1
                [Dis]=dense_distance_gpu_large32x16(single(tempB),single(tempA),mode,param);
                SPMEMD(j,:,:)=0.5*Dis;
        end
        SPMEMD(j,:,:)=tempDistance;
    end
    save(SPMTempfFilename,'SPMEMD');
else
    load(SPMTempfFilename);
end
Distance=zeros(size(H1,2),size(H2,2));
switch SPM
    case 2
        for i=1:5
            Distance=Distance+SPM_weight_vector(i)*reshape(SPMEMD(i,:,:),size(Distance,1),size(Distance,2));
        end
    case 3
        for i=1:21
            Distance=Distance+SPM_weight_vector(i)*reshape(SPMEMD(i,:,:),size(Distance,1),size(Distance,2));
        end
end
elseif SPM==1
Distance=zeros(size(H1,1),size(H2,1)); 
% tic
switch computeUnit
    case 0
        switch mode
            case 0
                switch param
                    case 1
                    case 2
                        H11 = sum(H1'.*H1',1);
                        H22 = sum(H2'.*H2',1);
                        H12 = H1*H2';
                        Distance = abs(repmat(H11',[1 size(H22,2)]) + repmat(H22,[size(H11,2) 1]) - 2*H12);
                end
            case 1
                parfor i=1:size(Distance,2)
                    Distance(:,i)=0.5*sum(bsxfun(@rdivide,bsxfun(@power,bsxfun(@minus,H1',H2(i,:)'),2),...
                        bsxfun(@plus,H1',H2(i,:)')+eps));
                end
        end
    case 1
        [Dis]=dense_distance_gpu_large32x16(single(H2),single(H1),mode,param);
        switch mode
            case 0
                Distance=Dis;
            case 1
                Distance=0.5*Dis;
        end
end
% toc
end
