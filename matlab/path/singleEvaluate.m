function J=singleEvaluate(path,threat,VEL,w1,w2)
%解码并计算路径长度
[path_n,~]=size(path);
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
dis_min=sqrt(path(path_n,2)-path(1,2)^2+(path(path_n,1)-path(1,1))^2);
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
    threat_J(i)=threat_J(i)/threat(i,3)/2*threat(i,4);%威胁越大，该值越大-代价值
end
dis_J,sum(threat_J),
J=w1*dis_J-w2*sum(threat_J);
