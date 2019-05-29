function aValue=adaptive_value(P,J)

sizeJ=size(J);
Task=zeros(sizeJ(1),sizeJ(2));
for target=1:sizeJ(2)
    Task(floor(P(target,1)),target)=1;
end
%P,J,Task,
aValue=sum(sum(J.*Task));