function Draw(path,threat)
[thr_n,~]=size(threat);
figure
plot(path(:,1),path(:,2));
hold on
for i=1:thr_n
    circle=[threat(i,1)-threat(i,3),threat(i,2)-threat(i,3),2*threat(i,3),2*threat(i,3)];
    rectangle('Position',circle,'Curvature',[1,1])
end
axis equal