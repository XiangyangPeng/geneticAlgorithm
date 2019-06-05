function P=constraint(P,V,T)
%P:一个解，列向量
%constraint of position
sizeP=size(P);
sizeV=size(V);
sizeT=size(T);
for i=1:sizeP(1)%对一个解向量中的每一个元素
    if P(i,1)>=sizeV(1)+1%过大限制
        P(i,1)=sizeV(1);
    end    
    if P(i,1)<1%过小限制
        P(i,1)=1;
    end
end

while 1%任务载荷限制
    %constraint of mission
    Task=zeros(sizeV(1),sizeT(1));%任务矩阵
    %get sale
    Sale=[];index=1;
    for i=1:sizeP(1)
        if(sum(Task(floor(P(i,1)),:))<V(floor(P(i,1)),6))%满足载荷限制
            Task(floor(P(i,1)),i)=1;%加入到任务集
        else%否则
            Sale(index)=i;index=index+1;%加入到售卖集
        end
    end
    if(index==1)%售卖集为空
        break;%不进行拍卖
    end
    %Sale
    %bid 巡飞弹投标
    bid=zeros(sizeV(1),2)-100;%投标矩阵
    for missile=1:sizeV(1)
         tempTask=Task;
        if(sum(tempTask(missile,:))>=V(missile,6))%巡飞弹已经超荷
            bid(missile,1)=-1;%不进行投标
            continue;
        end
        for sale_i=1:index-1%巡飞弹对售卖集中的任务进行投标
            %reward=J(missile,Sale(sale_i));%获得预估收益-------------------------------
            reward=Mevaluate(Task,missile,Sale(sale_i),T,V);
            if(reward>bid(missile,2))%选择预估收益最大者投标
                bid(missile,2)=reward;
                bid(missile,1)=Sale(sale_i);
            end
        end
    end
    %bid
    %select and distribute——主持人选择
    selection=zeros(sizeT(1),2)-100;%选择矩阵
    for missile=1:sizeV(1)
        if(bid(missile,1)==-1)%不进行投标的巡飞弹
            continue;%跳过
        end
        if(selection(bid(missile,1),2)<bid(missile,2))%选择收益最大的投标书
            selection(bid(missile,1),1)=missile;
            selection(bid(missile,1),2)=bid(missile,2);
        end
    end
    %change
    %selection——重分配任务
    for target=1:sizeT(1)
        if(selection(target,1)>0)
            P(target)=selection(target,1)+rand;%随机生成优先度
        end
    end
end 