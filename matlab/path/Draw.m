function Draw(path,threat,multipath)
%multipath:bool
[thr_n,~]=size(threat);
figure
if(multipath)
    [path_n,~,~]=size(path);
    plot(path(1,:,1),path(1,:,2));hold on
    for i=2:path_n
        plot(path(i,:,1),path(i,:,2));
    end
else
    plot(path(1,:,1),path(1,:,2));hold on
end

for i=1:thr_n
    circle=[threat(i,1)-threat(i,3),threat(i,2)-threat(i,3),2*threat(i,3),2*threat(i,3)];
    rectangle('Position',circle,'Curvature',[1,1])
end
axis equal