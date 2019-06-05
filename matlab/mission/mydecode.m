function mission=mydecode(p,V_num,load_max)
mission=zeros(V_num,load_max);
p_size=size(p);load_=ones(V_num);
[p,I]=sort(p);
for i=1:p_size(1)
    mission(floor(p(i)),load_(floor(p(i))))=I(i);
    load_(floor(p(i)))=load_(floor(p(i)))+1;
end