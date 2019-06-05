function aValue=Pevaluate(M,V,T)
%M:任务矩阵
global pso
sizeM=size(M);
sizeV=size(V);
sizeT=size(T);
C1=zeros(sizeM(1),1);
C2=zeros(sizeM(1),1);
R=zeros(sizeM(1),1);
V_x=sum(V(:,2))/sizeV(1);V_y=sum((V(:,3)))/sizeV(2);T_x=sum(T(:,2))/sizeT(1);T_y=sum((T(:,3))/sizeT(2));
max_R=sum(T(:,4));max_C2=sum(V(:,4));mid_C1=sqrt((T_x-V_x)^2+(T_y-V_y)^2)*sizeV(1);
for i=1:sizeM(1)   
    tempC1=0; %路径长度
    tempC2=1;%威胁
    tempR=0;%收益
    for j=1:sizeM(2)
        if M(i,j)==0
            break;
        end
        if j>1
            dis=sqrt((T(M(i,j),2)-T(M(i,j-1),2))^2+(T(M(i,j),3)-T(M(i,j-1),3))^2);
        else
            dis=sqrt((T(M(i,j),2)-V(i,2))^2+(T(M(i,j),3)-V(i,3))^2);
        end
        tempC1=tempC1+dis;
        tempC2=tempC2*(1-T(M(i,j),6));%不被击落的概率
        tempR=tempR+T(M(i,j),4)*V(i,5);       
    end
    tempC2=(1-tempC2)*V(i,4);%被击落的概率*巡飞弹价值
    R(i)=tempR;C1(i)=tempC1;C2(i)=tempC2;    
end
sum_R=sum(R);sum_C2=sum(C2);sum_C1=sum(C1);
sum_R=sum_R/max_R;sum_C2=sum_C2/max_C2;sum_C1=sum_C1/mid_C1;
aValue=pso.wJ(1)*sum_R-pso.wJ(2)*sum_C1-pso.wJ(3)*sum_C2; %bigger, better