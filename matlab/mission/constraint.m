function P=constraint(P,V,T)
%P:һ���⣬������
%constraint of position
sizeP=size(P);
sizeV=size(V);
sizeT=size(T);
for i=1:sizeP(1)%��һ���������е�ÿһ��Ԫ��
    if P(i,1)>=sizeV(1)+1%��������
        P(i,1)=sizeV(1);
    end    
    if P(i,1)<1%��С����
        P(i,1)=1;
    end
end

while 1%�����غ�����
    %constraint of mission
    Task=zeros(sizeV(1),sizeT(1));%�������
    %get sale
    Sale=[];index=1;
    for i=1:sizeP(1)
        if(sum(Task(floor(P(i,1)),:))<V(floor(P(i,1)),6))%�����غ�����
            Task(floor(P(i,1)),i)=1;%���뵽����
        else%����
            Sale(index)=i;index=index+1;%���뵽������
        end
    end
    if(index==1)%������Ϊ��
        break;%����������
    end
    %Sale
    %bid Ѳ�ɵ�Ͷ��
    bid=zeros(sizeV(1),2)-100;%Ͷ�����
    for missile=1:sizeV(1)
         tempTask=Task;
        if(sum(tempTask(missile,:))>=V(missile,6))%Ѳ�ɵ��Ѿ�����
            bid(missile,1)=-1;%������Ͷ��
            continue;
        end
        for sale_i=1:index-1%Ѳ�ɵ����������е��������Ͷ��
            %reward=J(missile,Sale(sale_i));%���Ԥ������-------------------------------
            reward=Mevaluate(Task,missile,Sale(sale_i),T,V);
            if(reward>bid(missile,2))%ѡ��Ԥ�����������Ͷ��
                bid(missile,2)=reward;
                bid(missile,1)=Sale(sale_i);
            end
        end
    end
    %bid
    %select and distribute����������ѡ��
    selection=zeros(sizeT(1),2)-100;%ѡ�����
    for missile=1:sizeV(1)
        if(bid(missile,1)==-1)%������Ͷ���Ѳ�ɵ�
            continue;%����
        end
        if(selection(bid(missile,1),2)<bid(missile,2))%ѡ����������Ͷ����
            selection(bid(missile,1),1)=missile;
            selection(bid(missile,1),2)=bid(missile,2);
        end
    end
    %change
    %selection�����ط�������
    for target=1:sizeT(1)
        if(selection(target,1)>0)
            P(target)=selection(target,1)+rand;%����������ȶ�
        end
    end
end 