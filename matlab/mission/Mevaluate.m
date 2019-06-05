function dValue=Mevaluate(Task,missile,target,T,V)
global model pso
dR=V(missile,5)*T(target,4);
dC2=V(missile,4)*(1-T(target,6));
dC1=sqrt((T(target,2)-V(missile,2))^2+(T(target,3)-V(missile,3))^2);
sizeTask=size(Task);
for i=1:sizeTask(2)
    if Task(missile,i)==0
        continue;
    else
        dis=sqrt((T(i,2)-T(target,2))^2+(T(i,3)-T(target,3))^2);
        if(dC1>dis)
            dC1=dis;
        end
    end
end
max_dR=model.T_value(2);
max_dC1=sum((model.T_point(1)-model.T_point(2)).^2);
max_dC2=model.V_value(2);
dR=dR/max_dR;dC1=dC1/max_dC1;dC2=dC2/max_dC2;
dValue=pso.wJ(1)*dR-pso.wJ(2)*dC1-pso.wJ(3)*dC2; %bigger, better