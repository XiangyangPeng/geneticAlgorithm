function NewPathPopu=variation_simple(PathPopu)
%变异如果不存在大幅改变的可能，那么算法就可能陷入局部搜索的陷阱
global p_vari mu sigma
[pathpopu_n,point_n,~]=size(PathPopu);
NewPathPopu=PathPopu;
for i=1:pathpopu_n
    for j=2:point_n-1%起始点和终止点不能变异
        p_rand=rand;
        if(p_rand<p_vari)%扰动算子
            NewPathPopu(i,j,1)=PathPopu(i,j,1)+normrnd(mu,sigma);
            NewPathPopu(i,j,2)=PathPopu(i,j,2)+normrnd(mu,sigma);
        else if(p_rand<2*p_vari)%平滑算子
            NewPathPopu(i,j,:)=(PathPopu(i,j-1,:)+PathPopu(i,j+1,:))/2;
            end
        end
    end
end