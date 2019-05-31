function [pathPopu,threat]=init_FromFun(sta,des,type)
%GammaFunction: s=cr^gamma
global path_n point_n gamma thr_n r thr
%init pathPopu
pathPopu=zeros(path_n,point_n+1,2);
d_gamma=gamma^(1/path_n);
if type==1
    for i=path_n*(-1):path_n
        point=[];path=zeros(point_n+1,2);
        gamma_r=d_gamma^i;
        c=(des(2)-sta(2))/((des(1)-sta(1))^gamma_r);
        xdis=(des(1)-sta(1))/point_n;
        for j=0:point_n
            x=j*xdis;
            point(1)=x+sta(1);point(2)=x^gamma_r*c+sta(2);
            path(j+1,:)=point;
        end
        pathPopu(i+path_n+1,:,:)=path;
    end
else
    for i=path_n*(-1):path_n
        point=[];path=zeros(point_n+1,2);
        gamma_r=d_gamma^i;
        c=(des(1)-sta(1))/((des(2)-sta(2))^gamma_r);
        ydis=(des(2)-sta(2))/point_n;
        for j=0:point_n
            y=j*ydis;
            point(1)=y^gamma_r*c+sta(1);point(2)=y+sta(2);
            path(j+1,:)=point;
        end
        pathPopu(i+path_n+1,:,:)=path;
    end
end

threat=zeros(thr_n,4);
for i=1:thr_n
    threat(i,1)=rand*(des(1)-sta(1))+sta(1);
    threat(i,2)=rand*(des(2)-sta(2))+sta(2);
    threat(i,3)=rand*(r(2)-r(1))+r(1);
    threat(i,4)=rand*(thr(2)-thr(1))+thr(1);
end