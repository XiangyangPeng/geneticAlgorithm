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

%��ʼ��
%evaluation=evaluate(T,V);%--------------------------------------------------------------------
Pset=zeros(Tsize(1),pso.numberP);%�����������Ϊ�⣬һ��pso.numberP����
for index=1:pso.numberP%��ÿһ��������
    tempP=rand(Tsize(1),1)*Vsize(1)+1;%��ʼ�����������ʼ��
    %Pset(:,index)=constraint(tempP,V,T,evaluation);%����������Լ����������������������������������
    Pset(:,index)=constraint(tempP,V,T);
end
%����
PbestSet=Pset;%ÿ�����ӵ����Ž�
Pbestevaluation=zeros(1,pso.numberP)-100;%ÿ�����ӵ�������Ӧ��
best=tempP;%ȫ�����Ž�
bestevaluation=-100;%ȫ��������Ӧ��

iteration=1;iterations=1000;%��������
bestSequence=[];%��������
test=0;
while 1
    %evaluate
    for index=1:pso.numberP%��ÿһ�������������ӣ�
        tempP=Pset(:,index);
        %aValue=adaptive_value(tempP,evaluation);%������Ӧ�ȡ�������������������������������������������
        M=mydecode(tempP,model.V_num,model.V_load(2));
        aValue=Pevaluate(M,V,T);
        if(aValue>Pbestevaluation(1,index))%����ÿ�����ӵ�����
            Pbestevaluation(1,index)=aValue;
            PbestSet(:,index)=tempP;
        end
    end
    [tempbest,tempindex]=max(Pbestevaluation);%����ȫ������
    if(tempbest>bestevaluation)
        bestevaluation=tempbest;
        best=PbestSet(:,tempindex);
    end
    %update�������ӷ���
    for index=1:pso.numberP
        tempP=Pset(:,index);
        Pset(:,index)=Pupdate(tempP,PbestSet(:,index),best);
    end
    %constraint��������������Լ��
    for index=1:pso.numberP
        tempP=rand(Tsize(1),1)*Vsize(1)+1;
        %Pset(:,index)=constraint(tempP,V,T,evaluation);%������������������������������������������������
        Pset(:,index)=constraint(tempP,V,T);
    end
    bestSequence(iteration)=bestevaluation;%����ֵ����
    iteration=iteration+1;
    %Pset������ֹ����
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
getmission=mydecode(best,model.V_num,model.V_load(2)),%����õ��������
