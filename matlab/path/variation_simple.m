function NewPathPopu=variation_simple(PathPopu)
%������������ڴ���ı�Ŀ��ܣ���ô�㷨�Ϳ�������ֲ�����������
global p_vari mu sigma
[pathpopu_n,point_n,~]=size(PathPopu);
NewPathPopu=PathPopu;
for i=1:pathpopu_n
    for j=2:point_n-1%��ʼ�����ֹ�㲻�ܱ���
        p_rand=rand;
        if(p_rand<p_vari)%�Ŷ�����
            NewPathPopu(i,j,1)=PathPopu(i,j,1)+normrnd(mu,sigma);
            NewPathPopu(i,j,2)=PathPopu(i,j,2)+normrnd(mu,sigma);
        else if(p_rand<2*p_vari)%ƽ������
            NewPathPopu(i,j,:)=(PathPopu(i,j-1,:)+PathPopu(i,j+1,:))/2;
            end
        end
    end
end