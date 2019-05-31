function NewPathPopu=merge_simple(PathPopu)
global p_merge
[pathpopu_n,point_n,xy]=size(PathPopu);
NewPathPopu=PathPopu;
count=1;temp=zeros(2,point_n,xy);j=1;
for i=1:pathpopu_n
    p_rand=rand;
    if(p_rand<p_merge)
        temp(count,:,:)=PathPopu(i,:,:);count=count+1;
        if count==3
            count=1;
            merge_point=floor(rand*point_n);
            NewPathPopu(j,:,:)=[temp(1,1:merge_point,:),temp(2,merge_point+1:point_n,:)];j=j+1;
            NewPathPopu(j,:,:)=[temp(2,1:merge_point,:),temp(1,merge_point+1:point_n,:)];j=j+1;
        end
    else
        NewPathPopu(j,:,:)=PathPopu(i,:,:);
        j=j+1;
    end
end
if count==2
    NewPathPopu(j,:,:)=PathPopu(i,:,:);
    j=j+1;
end