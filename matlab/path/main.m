global plane_n MIN_DIS_COOP w4 w5
global path_n point_n gamma thr_n r thr
global VEL MAX_ANGLE MAX_DIS
global w1 w2 w3 mu sigma p_merge p_vari
plane_n=4;MIN_DIS_COOP=5;w4=0.2;w5=0.4; %w4-碰撞  w5-方向
path_n=20;point_n=20;%2*plane_n+1   point_n+1
gamma=20;thr_n=15;r=[15,20];thr=[0.6,0.8];
VEL=1;              %速度
w1=0.6;w2=0.2;w3=0.2;      %权重 w1-路径,w2-威胁,w3-惩罚
p_merge=0.2;        %交配概率
p_vari=0.2;         %变异概率
mu=0;sigma=0.7;     %变异的高斯分布的参数
MAX_ANGLE=pi/6;MAX_DIS=500;

totalPopu=zeros(plane_n*(path_n*4+2),point_n+1,2);%所有飞机对应的种群
totalBestP=zeros(plane_n,point_n+1,2);totalBestE=zeros(plane_n,1);%所有飞机各自的最优值
totalSta=[[0,0];[50,0];[0,50];[0,20]];%所有飞机的起始点
des=[200,200];%目标点
%构建战场环境
sta_env=[0,0];des_env=[180,180];
%threat=init_Threat(sta_env,des_env);
%各自单独进化
for i_plane=1:plane_n
    %小生境1
    sta=totalSta(i_plane,:);
    [pathPopu1,~]=init_FromFun(sta,des,1);%初始化
    newPathPopu1=pathPopu1;
    Draw(newPathPopu1,threat,true);pause(1);
    bestPath1=[];bestEva1=-100;
    for iteration=1:100
        [eva,temp_bestPath,temp_bestEva]=Evaluate(newPathPopu1,threat);
        newPathPopu1=select_roul(newPathPopu1,eva);
        if(mod(iteration,25)==0)
            Draw(newPathPopu1,threat,true);pause(1);
        end
        if(temp_bestEva>bestEva1)
            bestEva1=temp_bestEva;
            bestPath1=temp_bestPath;
        end
        newPathPopu1=merge_simple(newPathPopu1);
        newPathPopu1=variation_simple(newPathPopu1); 
    end
    %小生境2
    [pathPopu2,~]=init_FromFun(sta,des,2);%初始化
    newPathPopu2=pathPopu2;
    Draw(newPathPopu2,threat,true);pause(1);
    bestPath2=[];bestEva2=-100;
    for iteration=1:100
        [eva,temp_bestPath,temp_bestEva]=Evaluate(newPathPopu2,threat);
        newPathPopu2=select_roul(newPathPopu2,eva);
        if(mod(iteration,25)==0)
            Draw(newPathPopu2,threat,true);pause(1);
        end
        if(temp_bestEva>bestEva2)
            bestEva2=temp_bestEva;
            bestPath2=temp_bestPath;
        end
        newPathPopu2=merge_simple(newPathPopu2);
        newPathPopu2=variation_simple(newPathPopu2); 
    end

    Draw(bestPath1,threat,false);pause(1);
    Draw(bestPath2,threat,false);pause(1);
    
    totalPopu((i_plane-1)*(path_n*4+2)+1:i_plane*(path_n*4+2),:,:)=[newPathPopu1;newPathPopu2];
    if(bestEva1>bestEva2)
        totalBestE(i_plane)=bestEva1;
        totalBestP(i_plane,:,:)=reshape(bestPath1,[point_n+1,2]);
    else
        totalBestE(i_plane)=bestEva2;
        totalBestP(i_plane,:,:)=reshape(bestPath2,[point_n+1,2]);
    end
end
%协同进化
newtotalPopu=totalPopu;
bestPath_c=totalBestP;bestEva_c=-100*ones(1,plane_n);
%temp_bestPath_c=zeros(plane_n,point_n+1,2);temp_bestEva_c=-100*ones(1,plane_n);
for iteration=1:100
    %评价
    [eva_coop,temp_bestPath_c,temp_bestEva_c]=togeEvaluate(newtotalPopu,threat,bestPath_c);
    for i=1:plane_n
        ista=(i-1)*(path_n*4+2)+1;iend=i*(path_n*4+2);
        %更新最优值
        if(temp_bestEva_c(i)>bestEva_c(i))
            bestEva_c(i)=temp_bestEva_c(i);
            bestPath_c(i,:,:)=temp_bestPath_c(i,:,:);
        end
        %选择算子
        newtotalPopu(ista:iend,:,:)=select_roul(newtotalPopu(ista:iend,:,:),eva_coop(ista:iend));
        %交配算子
        newtotalPopu(ista:iend,:,:)=merge_simple(newtotalPopu(ista:iend,:,:));
        %变异算子
        newtotalPopu(ista:iend,:,:)=variation_simple(newtotalPopu(ista:iend,:,:)); 
    end
    
    %newtotalPopu=select_roul(newtotalPopu,eva_coop);
    if(mod(iteration,20)==0)
        Draw(newtotalPopu,threat,true);pause(1);
    end
end
Draw(bestPath_c,threat,true);
