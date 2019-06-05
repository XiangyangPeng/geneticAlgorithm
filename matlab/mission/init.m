function [P,v,W]=init(T,V)
%T: information about target [[]]
%V: information about missile [[]]
%P: position
%v: velocity
%W: weight

Tsize=size(T);
Vsize=size(V);
P=rand(Tsize(1),1)*Vsize(1)+1;
v=rand(Tsize(1),1);
global pso
u=pso.umin+(pso.umax-pso.umin)*rand;
w=u+pso.sigma*randn(1);
W=[w,pso.c1,pso.c2];