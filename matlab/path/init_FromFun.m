function [path,threat]=init_FromFun(sta,des,path_n,gamma,thr_n,r,thr)
%GammaFunction: s=cr^gamma
c=(des(2)-sta(2))/((des(1)-sta(1))^gamma);
xdis=(des(1)-sta(1))/path_n;
point=[];path=zeros(path_n+1,2);
for i=0:path_n
    x=sta(1)+i*xdis;
    point(1)=x;point(2)=x^gamma*c+sta(1);
    path(i+1,:)=point;
end
threat=zeros(thr_n,4);
for i=1:thr_n
    threat(i,1)=rand*(des(1)-sta(1))+sta(1);
    threat(i,2)=rand*(des(2)-sta(2))+sta(2);
    threat(i,3)=rand*(r(2)-r(1))+r(1);
    threat(i,4)=rand*(thr(2)-thr(1))+thr(1);
end