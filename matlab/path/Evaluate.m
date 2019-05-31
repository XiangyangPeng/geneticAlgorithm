function [eva,bestPath,bestEva]=Evaluate(PathPopu,threat)
%pathpopu:the population of paths
[pathpopu_n,~,~]=size(PathPopu);
eva=zeros(1,pathpopu_n);
for i=1:pathpopu_n
    eva(i)=singleEvaluate(PathPopu(i,:,:),threat);
end
[bestEva,bestIndex]=max(eva);bestPath=PathPopu(bestIndex,:,:);

function J=singleEvaluate(path,threat)
global VEL MAX_ANGLE MAX_DIS
global w1 w2 w3 
%解码并计算路径长度
%path:1*path_n*2
[~,path_n,xy]=size(path);
path=reshape(path,[path_n,xy]);
path_dec=[];point=[];k=1;
dis_J=0;
for i=1:path_n-1
    dis_x=path(i+1,1)-path(i,1);
    dis_y=path(i+1,2)-path(i,2);
    dis=sqrt(dis_x^2+dis_y^2);
    dis_J=dis_J+dis;
    dis_n=floor(dis/VEL);
    path_dec(k,:)=path(i,:);k=k+1;
    for j=1:dis_n
        point(1)=path(i,1)+j*VEL*dis_x/dis;
        point(2)=path(i,2)+j*VEL*dis_y/dis;
        path_dec(k,:)=point;k=k+1;
    end
end
path_dec(k,:)=path(path_n,:);
%标定
dis_min=sqrt((path(path_n,2)-path(1,2))^2+(path(path_n,1)-path(1,1))^2);
dis_J=dis_min/dis_J;%路径越长，该值越小-适应值
%统计位于各个威胁区域内的路径点数量
[pathdec_n,~]=size(path_dec);
[thr_n,~]=size(threat);
threat_J=zeros(thr_n,1);
for i=1:pathdec_n
    for j=1:thr_n
        if sqrt((path_dec(i,1)-threat(j,1))^2+(path_dec(i,2)-threat(j,2))^2)<threat(j,3)
            threat_J(j)=threat_J(j)+1;
        end
    end
end
for i=1:thr_n
    threat_J(i)=threat_J(i)/threat(i,3)/2*VEL*threat(i,4);%威胁越大，该值越大-代价值
end
%dis_J,sum(threat_J),
J=w1*dis_J-w2*sum(threat_J);

%take restrain into consideration
isRes=true;isARes=true;isDRes=true;angle_total=0;
angle=zeros(1,path_n);
for i=2:path_n
    angle(i)=atan((path(i,2)-path(i-1,2))/(path(i,1)-path(i-1,1)));
    if(path(i,2)-path(i-1,2)>0)
        if(angle(i)<0)
            angle(i)=angle(i)+pi/2;
        else
            angle(i)=angle(i);
        end
    else
        if(angle(i)<0)
            angle(i)=angle(i)-pi/2;
        else
            angle(i)=angle(i)+pi;
        end
    end
end
for i=3:path_n
    d_angle=abs(angle(i)-angle(i-1));
    if(d_angle>pi)
        d_angle=2*pi-d_angle;
    end
    if d_angle>MAX_ANGLE
        isRes=false;isARes=false;
    end
    angle_total=angle_total+d_angle;
end
if(dis_min/dis_J>MAX_DIS)
    isRes=false;isDRes=false;
end
%if(~isRes)
%    J=0;
%else
    %标定
angle_total=angle_total/(MAX_ANGLE*(path_n-2));%惩罚项，越小越好
J=J-angle_total*w3+1;
if J<0
    J=0;%J必须为正数
end

%