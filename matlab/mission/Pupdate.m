function P=Pupdate(P,pbest,best)
%pbest ��������
%best ��Ⱥ����
global pso
sizeP=size(P);
v=rand(sizeP(1),1);
u=pso.umin+(pso.umax-pso.umin)*rand;
w=u+pso.sigma*randn(1);
P=P+w*v+pso.c1*(pbest-P)+pso.c2*(best-P);