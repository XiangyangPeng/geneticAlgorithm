function NewPathPopu=select_roul(PathPopu,eva,bestPath)
%select with roulette
%pathpopu:the population of paths
[pathpopu_n,~,~]=size(PathPopu);
%prob;
prob=eva/sum(eva);
NewPathPopu=PathPopu;
for i=1:pathpopu_n-1
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
NewPathPopu(pathpopu_n,:,:)=bestPath;