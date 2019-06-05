function V=generateV(V_num,V_point,Vv,att,load)
V=ones(V_num,6);
for i=1:V_num
    V(i,1)=i;
    V(i,2)=rand*(V_point(2,1)-V_point(1,1))+V_point(1,1);
    V(i,3)=rand*(V_point(2,2)-V_point(1,2))+V_point(1,2);
    V(i,4)=rand*(Vv(2)-Vv(1));
    V(i,5)=rand*(att(2)-att(1))+att(1);
    V(i,6)=floor(rand*(load(2)-load(1))+load(1));
end
%任务载荷总数必须大于任务总数(保证max_load之和可以大于任务总数)
if load(2)*V_num<load(3)
    error('保证max_load之和可以大于任务总数!!!');
end
i=1;
while sum(V(:,6))<load(3)
    if V(i,6)<load(2)
        V(i,6)=V(i,6)+1;
    end
    i=i+1;
    if i>V_num
        i=1;
    end
end