function P=constraint(P,V,T,J)

%constraint of position
sizeP=size(P);
sizeV=size(V);
sizeT=size(T);
for i=1:sizeP(1)
    if P(i,1)>=sizeV(1)+1
        P(i,1)=sizeV(1);
    end    
    if P(i,1)<1
        P(i,1)=1;
    end
end

while 1
    %constraint of mission
    Task=zeros(sizeV(1),sizeT(1));
    %get sale
    Sale=[];index=1;
    for i=1:sizeP(1)
        if(sum(Task(floor(P(i,1)),:))<V(floor(P(i,1)),6))
            Task(floor(P(i,1)),i)=1;
        else
            Sale(index)=i;index=index+1;
        end
    end
    if(index==1)
        break;
    end
    %Sale
    %bid
    bid=zeros(sizeV(1),2)-100;
    for missile=1:sizeV(1)
         tempTask=Task;
        if(sum(tempTask(missile,:))>=V(missile,6))
            bid(missile,1)=-1;
            continue;
        end
        for sale_i=1:index-1
            reward=J(missile,Sale(sale_i));
            if(reward>bid(missile,2))
                bid(missile,2)=reward;
                bid(missile,1)=Sale(sale_i);
            end
        end
    end
    %bid
    %select and distribute       
    selection=zeros(sizeT(1),2)-100;
    for missile=1:sizeV(1)
        if(bid(missile,1)==-1)
            continue;
        end
        if(selection(bid(missile,1),2)<bid(missile,2))
            selection(bid(missile,1),1)=missile;
            selection(bid(missile,1),2)=bid(missile,2);
        end
    end
    %change
    %selection
    for target=1:sizeT(1)
        if(selection(target,1)>0)
            P(target)=selection(target,1)+rand;
        end
    end
end 