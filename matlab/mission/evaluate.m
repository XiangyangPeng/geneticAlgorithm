function J=evaluate(T,V)
%T [[ID,Posx,Posy,Value,R,Threat]]    total number of targets * 6
%V [[ID,Posx,Posy,Value,Attack,Load]] total number of missiles * 6
%W weight [w,pso.c1,pso.c2]
%J total number of missiles * total number of targets

sizeT=size(T);sizeV=size(V);
C1=zeros(sizeV(1),sizeT(1));
C2=zeros(sizeV(1),sizeT(1));
R=zeros(sizeV(1),sizeT(1));
for missile=1:sizeV(1)
    for target=1:sizeT(1)
        distance=sqrt((V(missile,2)-T(target,2))^2+(V(missile,3)-T(target,3))^2);
        C1(missile,target)=V(missile,4)*(1-prod(1-T(:,6)));
        C2(missile,target)=distance;
        R(missile,target)=T(target,4)*V(missile,5);
    end
end
C1=C1/max(max(C1));
C2=C2/max(max(C2));
R=R/max(max(R));
global pso
J=pso.wJ(1)*R-pso.wJ(2)*C1-pso.wJ(3)*C2; %bigger, better

