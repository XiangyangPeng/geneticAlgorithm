function Draw(M,T,V)
sizeM=size(M);
sizeT=size(T);
figure
for i=1:sizeM(1)
    for j=1:sizeM(2)
        if M(i,j)==0
            break;
        end   
        if j==1
            plot([V(i,2),T(M(i,j),2)],[V(i,3),T(M(i,j),3)]);
            hold on
        else
            plot([T(M(i,j-1),2),T(M(i,j),2)],[T(M(i,j-1),3),T(M(i,j),3)]);
        end
    end
end
for i=1:sizeT(1)
    text(T(i,2),T(i,3),num2str(i));
    circle=[T(i,2)-T(i,5),T(i,3)-T(i,5),2*T(i,5),2*T(i,5)];
    rectangle('Position',circle,'Curvature',[1,1]);    
end