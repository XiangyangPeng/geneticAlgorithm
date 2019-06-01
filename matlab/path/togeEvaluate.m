function [eva,newbestPath,newbestEva]=togeEvaluate(totalPopu,threat,bestPath_c)
global plane_n path_n point_n
[eva,~,~]=Evaluate(totalPopu,threat);
newbestPath=zeros(plane_n,point_n+1,2);newbestEva=zeros(1,plane_n);
for i=1:plane_n
    ista=(i-1)*(path_n*4+2)+1;iend=i*(path_n*4+2);
    for j=ista:iend
        eva(j)=coopEvaluate2(totalPopu(j,:,:),i,bestPath_c,eva(j));
    end
    [newbestEva(i),bestIndex]=max(eva(ista:iend));
    bestIndex=bestIndex+ista-1;
    newbestPath(i,:,:)=totalPopu(bestIndex,:,:);
end


function J=coopEvaluate(path,PathPopuOth,eva)
global MIN_DIS_COOP plane_n w4 w5
[~,point_n,~]=size(path);
[pathPopuOth_n,pointOth_n,~]=size(PathPopuOth);%解码
path_dec=decode(path);crash_total=0;
angle_in=zeros(1,pathPopuOth_n+1);
dxy=path(1,point_n,:)-path(1,point_n-1,:);
angle_in(1)=calAngle(dxy);
for i=1:pathPopuOth_n
    pathOth_dec=decode(PathPopuOth(i,:,:));%解码
    %判断是否满足碰撞约束
    [pathOd_n,~]=size(pathOth_dec);
    [pathd_n,~]=size(path_dec);
    for j=1:pathOd_n
        if(j>pathd_n)
            break;
        end
        dis_xy=pathOth_dec(j,:)-path_dec(j,:);
        dis=sqrt(dis_xy(1)^2+dis_xy(2)^2);
        if(dis<MIN_DIS_COOP)
            crash_total=crash_total+1;
        end
    end
    %进入目标时的方向角要尽可能分离
    dxy=PathPopuOth(i,pointOth_n,:)-PathPopuOth(i,pointOth_n-1,:);
    angle_in(i+1)=calAngle(dxy);
end
crash=crash_total/(pathPopuOth_n*pathOd_n);%碰撞指数-越小越好
angle_coop=var(angle_in)/var(pi/plane_n:pi/plane_n:2*pi);%进入方向分离指数-越大越好
J=eva-w4*crash+w5*angle_coop;
if J<0
    J=0;%J必须为正数
end

function J=coopEvaluate2(path,path_label,bestPath_c,eva)
global plane_n w5
[~,point_n,~]=size(path);
angle_in=zeros(1,plane_n);
dxy=path(1,point_n,:)-path(1,point_n-1,:);
angle_in(1)=calAngle(dxy);
for i=[1:path_label-1,path_label+1:plane_n]
    %进入目标时的方向角要尽可能分离
    dxy=bestPath_c(i,point_n,:)-bestPath_c(i,point_n-1,:);
    angle_in(i+1)=calAngle(dxy);
end
angle_coop=var(angle_in)/var(pi/plane_n:pi/plane_n:2*pi);%进入方向分离指数-越大越好
J=eva+w5*angle_coop;
if J<0
    J=0;%J必须为正数
end

function path_dec=decode(path)
global VEL
[~,path_n,xy]=size(path);
path=reshape(path,[path_n,xy]);
path_dec=[];point=[];k=1;
for i=1:path_n-1
    dis_x=path(i+1,1)-path(i,1);
    dis_y=path(i+1,2)-path(i,2);
    dis=sqrt(dis_x^2+dis_y^2);
    dis_n=floor(dis/VEL);
    path_dec(k,:)=path(i,:);k=k+1;
    for j=1:dis_n
        point(1)=path(i,1)+j*VEL*dis_x/dis;
        point(2)=path(i,2)+j*VEL*dis_y/dis;
        path_dec(k,:)=point;k=k+1;
    end
end
path_dec(k,:)=path(path_n,:);

function angle=calAngle(dxy)
angle=atan(dxy(2)/dxy(1));
if(dxy(2)>0)
    if(angle<0)
        angle=angle+pi/2;
    else
    end
else
    if(angle<0)
        angle=angle-pi/2;
    else
        angle=angle+pi;
    end
end    