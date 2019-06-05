function T=generateT(T_num,T_point,Tv,r,thr)
%T_point=[[30,35];[70,70]]
%v=[20,100],r=[20,50],thr=[0.3,0.9]
T=ones(T_num,6);
for i=1:T_num
    T(i,1)=floor(i);
    T(i,2)=rand*(T_point(2,1)-T_point(1,1))+T_point(1,1);
    T(i,3)=rand*(T_point(2,2)-T_point(1,2))+T_point(1,2);
    T(i,4)=rand*(Tv(2)-Tv(1));
    T(i,5)=rand*(r(2)-r(1))+r(1);
    T(i,6)=rand*(thr(2)-thr(1))+thr(1);
end