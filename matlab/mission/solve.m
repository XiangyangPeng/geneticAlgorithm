clc;clear;
%T [[ID,Posx,Posy,Value,R,Threat]]    total number of targets * 6
%V [[ID,Posx,Posy,Value,Attack,Load]] total number of missiles * 6
global pso model
pso.numberP=50;pso.umin=0.2;pso.umax=0.8;pso.sigma=0.2;pso.c1=2;pso.c2=2;%pso.wJ=[0.4,0.5,0.6];
pso.wJ=[0.2,0.4,0.4];
model.T_num=10;model.T_point=[[50,50];[200,200]];model.T_value=[20,70];model.T_R=[10.,13.];model.T_P=[0.4,0.6];
model.V_num=3 ;model.V_point=[[10,10];[20,20]];model.V_value=[40,60];model.V_P=[0.5,0.8];model.V_load=[2,4,10];%[min,max,sum_min=T_num]
% T=[[1,55,50,20, 15,0.50];
%    [2,60,70,20, 15,0.55];
%    [3,65,30,40, 12,0.60];
%    [4,75,20,100,15,0.85];
%    [5,80,50,40, 12,0.70];
%    [6,78,70,50, 10,0.75];
%    [7,75,90,30, 12,0.80]];
% V=[[1,20,45,50,0.6,3];
%    [2,20,50,60,0.7,3];
%    [3,20,55,40,0.8,2]];
T=generateT(model.T_num,model.T_point,model.T_value,model.T_R,model.T_P);
V=generateV(model.V_num,model.V_point,model.V_value,model.V_P,model.V_load);
Tsize=size(T);
Vsize=size(V);

%初始化
%evaluation=evaluate(T,V);%--------------------------------------------------------------------
Pset=zeros(Tsize(1),pso.numberP);%解矩阵，列向量为解，一共pso.numberP个解
for index=1:pso.numberP%对每一个解向量
    tempP=rand(Tsize(1),1)*Vsize(1)+1;%初始化——随机初始化
    %Pset(:,index)=constraint(tempP,V,T,evaluation);%调整以满足约束————————————————
    Pset(:,index)=constraint(tempP,V,T);
end
%评价
PbestSet=Pset;%每个粒子的最优解
Pbestevaluation=zeros(1,pso.numberP)-100;%每个粒子的最优适应度
best=tempP;%全局最优解
bestevaluation=-100;%全局最优适应度

iteration=1;iterations=1000;%迭代次数
bestSequence=[];%最优序列
test=0;
while 1
    %evaluate
    for index=1:pso.numberP%对每一个解向量（粒子）
        tempP=Pset(:,index);
        %aValue=adaptive_value(tempP,evaluation);%计算适应度——————————————————————
        M=mydecode(tempP,model.V_num,model.V_load(2));
        aValue=Pevaluate(M,V,T);
        if(aValue>Pbestevaluation(1,index))%更新每个粒子的最优
            Pbestevaluation(1,index)=aValue;
            PbestSet(:,index)=tempP;
        end
    end
    [tempbest,tempindex]=max(Pbestevaluation);%更新全局最优
    if(tempbest>bestevaluation)
        bestevaluation=tempbest;
        best=PbestSet(:,tempindex);
    end
    %update——粒子飞行
    for index=1:pso.numberP
        tempP=Pset(:,index);
        Pset(:,index)=Pupdate(tempP,PbestSet(:,index),best);
    end
    %constraint——调整以满足约束
    for index=1:pso.numberP
        tempP=rand(Tsize(1),1)*Vsize(1)+1;
        %Pset(:,index)=constraint(tempP,V,T,evaluation);%————————————————————————
        Pset(:,index)=constraint(tempP,V,T);
    end
    bestSequence(iteration)=bestevaluation;%最优值序列
    iteration=iteration+1;
    %Pset——终止条件
    test=test+1;
    if mod(iteration,100)==0
        M=mydecode(best,model.V_num,model.V_load(2));
        Draw(M,T,V);pause(1);
    end
    %PbestSet,Pbestevaluation,best,bestevaluation,
    %getmission=mydecode(best,model.V_num,model.V_load(2)),
    if iteration>iterations
        break;
%         if bestSequence(iteration-1)>=bestSequence(iteration-100)+0
%             break;
%         end
    end
end
%best;bestevaluation;
figure
plot(bestSequence);
getmission=mydecode(best,model.V_num,model.V_load(2)),%解码得到任务矩阵
