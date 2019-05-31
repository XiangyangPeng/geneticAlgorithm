global plane_n MIN_DIS_COOP w4 w5
global path_n point_n gamma thr_n r thr
global VEL MAX_ANGLE MAX_DIS
global w1 w2 w3 mu sigma p_merge p_vari
plane_n=3;MIN_DIS_COOP=5;w4=0.2;w5=0.2;
path_n=10;point_n=20;%2*plane_n+1   point_n+1
gamma=20;thr_n=10;r=[10,15];thr=[0.6,0.8];
VEL=1;              %�ٶ�
w1=0.2;w2=0.6;w3=0.2;      %Ȩ�� w1-·��,w2-��в,w3-�ͷ�
p_merge=0.2;        %�������
p_vari=0.2;         %�������
mu=0;sigma=0.7;     %����ĸ�˹�ֲ��Ĳ���
MAX_ANGLE=pi/6;MAX_DIS=500;

totalPopu=zeros(plane_n*(path_n*4+2),point_n+1,2);%���зɻ���Ӧ����Ⱥ
totalBestP=zeros(plane_n,point_n+1,2);totalBestE=zeros(plane_n,1);%���зɻ����Ե�����ֵ
totalSta=[[0,0];[5,0];[0,5]];%���зɻ�����ʼ��
des=[100,100];%Ŀ���
%����ս������
sta_env=[0,0];des_env=[100,100];
threat=init_Threat(sta_env,des_env);
%���Ե�������
for i_plane=1:plane_n
    %С����1
    sta=totalSta(i_plane,:);
    [pathPopu1,~]=init_FromFun(sta,des,1);%��ʼ��
    newPathPopu1=pathPopu1;
    Draw(newPathPopu1,threat,true);pause(1);
    bestPath1=[];bestEva1=-100;
    for iteration=1:5
        [eva,temp_bestPath,temp_bestEva]=Evaluate(newPathPopu1,threat);
        newPathPopu1=select_roul(newPathPopu1,eva);
        if(mod(iteration,5)==0)
            Draw(newPathPopu1,threat,true);pause(1);
        end
        if(temp_bestEva>bestEva1)
            bestEva1=temp_bestEva;
            bestPath1=temp_bestPath;
        end
        newPathPopu1=merge_simple(newPathPopu1);
        newPathPopu1=variation_simple(newPathPopu1); 
    end
    %С����2
    [pathPopu2,~]=init_FromFun(sta,des,2);%��ʼ��
    newPathPopu2=pathPopu2;
    Draw(newPathPopu2,threat,true);pause(1);
    bestPath2=[];bestEva2=-100;
    for iteration=1:5
        [eva,temp_bestPath,temp_bestEva]=Evaluate(newPathPopu2,threat);
        newPathPopu2=select_roul(newPathPopu2,eva);
        if(mod(iteration,5)==0)
            Draw(newPathPopu2,threat,true);pause(1);
        end
        if(temp_bestEva>bestEva2)
            bestEva2=temp_bestEva;
            bestPath2=temp_bestPath;
        end
        newPathPopu2=merge_simple(newPathPopu2);
        newPathPopu2=variation_simple(newPathPopu2); 
    end

    Draw(bestPath1,threat,false);
    Draw(bestPath2,threat,false);
    
    totalPopu((i_plane-1)*(path_n*4+2)+1:i_plane*(path_n*4+2),:,:)=[newPathPopu1;newPathPopu2];
    if(bestEva1>bestEva2)
        totalBestE(i_plane)=bestEva1;
        totalBestP(i_plane,:,:)=reshape(bestPath1,[point_n+1,2]);
    else
        totalBestE(i_plane)=bestEva2;
        totalBestP(i_plane,:,:)=reshape(bestPath2,[point_n+1,2]);
    end
end
%Эͬ����
newtotalPopu=totalPopu;
bestPath_c=zeros(plane_n,point_n+1,2);bestEva_c=-100*ones(1,plane_n);
temp_bestPath_c=zeros(plane_n,point_n+1,2);temp_bestEva_c=-100*ones(1,plane_n);
for iteration=1:5
    eva_coop=zeros(1,plane_n*(path_n*4+2));
    for i=1:plane_n
        ista=(i-1)*(path_n*4+2)+1;iend=i*(path_n*4+2);
        [eva_coop(ista:iend),temptemppath,temp_bestEva_c(plane_n)]=togeEvaluate(newtotalPopu(ista:iend,:,:),[newtotalPopu(1:ista-1,:,:);newtotalPopu(iend+1:plane_n*(path_n*4+2),:,:)],threat);
        temp_bestPath_c(plane_n,:,:)=reshape(temptemppath,[point_n+1,2]);
    end
    
    newtotalPopu=select_roul(newtotalPopu,eva_coop);
    if(mod(iteration,1)==0)
        Draw(newtotalPopu,threat,true);
    end
    for i=1:plane_n
        if(temp_bestEva_c(i)>bestEva_c(i))
            bestEva_c(i)=temp_bestEva_c(i);
            bestPath_c(i,:,:)=temp_bestPath_c(i,:,:);
        end
    end    
    newtotalPopu=merge_simple(newtotalPopu);
    newtotalPopu=variation_simple(newtotalPopu); 
end
