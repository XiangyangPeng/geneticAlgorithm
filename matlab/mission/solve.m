clc;clear;
%T [[ID,Posx,Posy,Value,R,Threat]]    total number of targets * 6
%V [[ID,Posx,Posy,Value,Attack,Load]] total number of missiles * 6

T=[[1,55,50,20, 15,0.50];
   [2,60,70,20, 15,0.55];
   [3,65,30,40, 12,0.60];
   [4,75,20,100,15,0.85];
   [5,80,50,40, 12,0.70];
   [6,78,70,50, 10,0.75];
   [7,75,90,30, 12,0.80]];
V=[[1,20,45,50,0.6,3];
   [2,20,50,60,0.7,4];
   [3,20,55,40,0.8,2]];
Tsize=size(T);
Vsize=size(V);
global pso
%³õÊ¼»¯
evaluation=evaluate(T,V);
Pset=zeros(Tsize(1),pso.numberP);
for index=1:pso.numberP
    tempP=rand(Tsize(1),1)*Vsize(1)+1;
    Pset(:,index)=constraint(tempP,V,T,evaluation);
end
%ÆÀ¼Û
PbestSet=Pset
Pbestevaluation=zeros(1,pso.numberP)-100;
best=tempP;
bestevaluation=-100;

iteration=1;
bestSequence=[];
test=0;
while 1
    %evaluate
    for index=1:pso.numberP
        tempP=Pset(:,index);
        aValue=adaptive_value(tempP,evaluation);
        if(aValue>Pbestevaluation(1,index))
            Pbestevaluation(1,index)=aValue;
            PbestSet(:,index)=tempP;
        end
    end
    [tempbest,tempindex]=max(Pbestevaluation);
    if(tempbest>bestevaluation)
        bestevaluation=tempbest;
        best=PbestSet(:,tempindex);
    end
    %update
    for index=1:pso.numberP
        tempP=Pset(:,index);
        Pset(:,index)=Pupdate(tempP,PbestSet(:,index),best);
    end
    %constraint
    for index=1:pso.numberP
        tempP=rand(Tsize(1),1)*Vsize(1)+1;
        Pset(:,index)=constraint(tempP,V,T,evaluation);
    end
    bestSequence(iteration)=bestevaluation;
    iteration=iteration+1;
    %Pset
    test=test+1;
    if iteration>200
        if bestSequence(iteration-1)>=bestSequence(iteration-100)
            break;
        end
    end
end
best,bestevaluation,
plot(bestSequence);
