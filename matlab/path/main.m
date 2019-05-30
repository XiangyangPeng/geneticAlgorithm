sta=[0,0];des=[100,100];
path_n=50;point_n=20;
gamma=20;thr_n=10;r=[10,15];thr=[0.2,0.4];
VEL=1;              %�ٶ�
w1=0.2;w2=0.6;w3=0.2;      %Ȩ�� w1-·��,w2-��в,w3-�ͷ�
p_merge=0.2;        %�������
p_vari=0.1;         %�������
mu=0;sigma=0.7;     %����ĸ�˹�ֲ��Ĳ���
MAX_ANGLE=pi/6;MAX_DIS=500;

[pathPopu,threat]=init_FromFun(sta,des,path_n,point_n,gamma,thr_n,r,thr);
Draw(pathPopu,threat,true);pause(1);
bestPath=[];bestEva=-100;
for iteration=1:100
    [pathPopu,temp_bestPath,temp_bestEva]=select_roul(pathPopu,threat,VEL,w1,w2,w3,MAX_ANGLE,MAX_DIS);
    if(mod(iteration,5)==0)
        Draw(pathPopu,threat,true);pause(1);
    end
    if(temp_bestEva>bestEva)
        bestEva=temp_bestEva;
        bestPath=temp_bestPath;
    end
    pathPopu=merge_simple(pathPopu,p_merge);
    pathPopu=variation_simple(pathPopu,p_vari,mu,sigma);
    
end