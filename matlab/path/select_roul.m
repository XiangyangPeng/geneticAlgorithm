function [NewPathPopu,bestPath,bestEva]=select_roul(PathPopu,threat,VEL,w1,w2,w3,MAX_ANGLE,MAX_DIS)
%select with roulette
%pathpopu:the population of paths
[pathpopu_n,point_n,xy]=size(PathPopu);
prob=zeros(1,pathpopu_n);
for i=1:pathpopu_n
    prob(i)=singleEvaluate(PathPopu(i,:,:),threat,VEL,w1,w2,w3,MAX_ANGLE,MAX_DIS);
end
%prob;
[bestEva,bestIndex]=max(prob);bestPath=reshape(PathPopu(bestIndex,:,:),[point_n,xy]);
prob=prob/sum(prob);
NewPathPopu=PathPopu;
for i=1:pathpopu_n
    prob_path=0;
    prob_sele=rand;
    for j=1:pathpopu_n
        prob_path=prob_path+prob(j);
        if(prob_sele<prob_path)
            NewPathPopu(i,:,:)=PathPopu(j,:,:);
            break;
        end
    end    
end