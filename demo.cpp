#include<iostream>
#include<vector>
#include<math.h>
using namespace std;

#define MAX_ANGLE 30
#define MAX_DIS 100
#define VEL 1
//编码实例
//编码向量:[[1,1,30],[...],...]

vector<vector<float>> init_pathFromFun(float sta_x=0,float sta_y=0,float end_x=100,float end_y=100,
int path_n=10,float gamma=1){
    vector<vector<float>> path;
    vector<float> point;
    //确定函数——伽马函数 s=cr^gamma
    float c=(end_y-sta_y)/pow(end_x-sta_x,gamma);
    //取样生成路径点序列
    float p_x,p_y,p_xdis=(end_x-sta_x)/path_n;
    for(int i=0;i<=path_n;i++){
        p_x=sta_x+i*p_xdis;
        point.push_back(p_x);
        point.push_back(c*pow(p_x,gamma));
        path.push_back(point);
        point.pop_back();point.pop_back();
    }
    return path;
}

float decode(vector<vector<float>>& path){
    int n=path.size();
    float path_dis=0;
    for(int i=1;i<n;i++){
        path_dis+=sqrt(pow((path[i][0]-path[i-1][0]),2)+pow((path[i][1]-path[i-1][1]),2));
    }
    return path_dis;
}
float calDis(float x,float y,float u,float v){
    return sqrt(pow(x-u,2)+pow(y-v,2));
}
float singleEvaluate(vector<vector<float>>& path,vector<vector<float>>& threat){
    //args: threat-[[x,y,r,p],...]
    float eva;
    //解码得到等距离路径点序列同时计算总路径长度
    int n=path.size();
    vector<vector<float>> depath;//the decoded path
    vector<float> point;
    float dis_x,dis_y,dis_;
    float dis_total=0;    //total distance of a path
    int dis_n;
    for(int i=0;i<n-1;i++){
        dis_x=path[i+1][0]-path[i][0];
        dis_y=path[i+1][1]-path[i][1];
        dis_=sqrt(pow(dis_x,2)+pow(dis_y,2));
        dis_total+=dis_;
        dis_n=dis_/VEL;
        for(int j=0;j<dis_n+1;j++){
            point.push_back(path[i][0]+j*VEL*dis_x/dis_);
            point.push_back(path[i][1]+j*VEL*dis_y/dis_);
            depath.push_back(point);
            point.pop_back();point.pop_back();
        }        
    }
    point.push_back(path[n-1][0]);
    point.push_back(path[n-1][1]);
    depath.push_back(point);
    
    //统计位于各个威胁区域内的路径点数量
    int depath_n=depath.size();
    int threat_n=threat.size();
    vector<float> threat_prob(threat_n,0);
    for(int i=0;i<depath_n;i++){
        for(int j=0;j<threat_n;j++){
            if(calDis(depath[i][0],depath[i][1],threat[j][0],threat[j][1])<threat[j][2]){
                threat_prob[j]++;
            }
        }
    }
    //计算各个威胁区域对导弹的威胁程度及总的威胁程度
    float threat_total=0;
    for(int i=0;i<threat_n;i++){
        threat_prob[i]=threat_prob[i]/threat[i][2]/2*threat[i][3];
        threat_total+=threat_prob[i];
    }
    //计算适应值
    eva=(dis_total+threat_total)*(-1);
    return eva;
}

bool singleRestrain(vector<vector<float>>& path){
    bool restr=true;
    int n=path.size();
    float path_dis=0;
    for(int i=1;i<n;i++){
        if(abs(path[i][2]-path[i-1][2])>MAX_ANGLE){
            restr=false;break;
        }
    }
    for(int i=1;i<n;i++){
        path_dis+=sqrt(pow((path[i][0]-path[i-1][0]),2)+pow((path[i][1]-path[i-1][1]),2));
    }
    if(path_dis>MAX_DIS){
        restr=false;
    }
    return restr;
}

int main(){    
    vector<vector<float>> path;
    vector<vector<float>> threat;
    path=init_pathFromFun();
    
    return 0;
}