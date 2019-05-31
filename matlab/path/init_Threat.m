function threat=init_Threat(sta,des)
global thr r thr_n
threat=zeros(thr_n,4);
for i=1:thr_n
    threat(i,1)=rand*(des(1)-sta(1))+sta(1);
    threat(i,2)=rand*(des(2)-sta(2))+sta(2);
    threat(i,3)=rand*(r(2)-r(1))+r(1);
    threat(i,4)=rand*(thr(2)-thr(1))+thr(1);
end