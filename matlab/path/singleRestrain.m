function [isRes,isARes,isDRes]=singleRestrain(path,MAX_ANGLE,MAX_DIS)
isRes=true;isARes=true;isDRes=true;
[path_n,~]=size(path);
dis_total=sqrt((path(2,1)-path(1,1))^2+(path(2,2)-path(1,2))^2);
for i=3:path_n
    angle1=atan((path(i-1,2)-path(i-2,2))/(path(i-1,1)-path(i-2,1)));
    angle2=atan((path(i,2)-path(i-1,2))/(path(i,1)-path(i-1,1)));
    if abs(angle2-angle1)>MAX_ANGLE
        isRes=false;isARes=false;
    end
    dis_total=dis_total+sqrt((path(i,1)-path(i-1,1))^2+(path(i,2)-path(i-1,2))^2);
end
if(dis_total>MAX_DIS)
    isRes=false;isDRes=false;
end