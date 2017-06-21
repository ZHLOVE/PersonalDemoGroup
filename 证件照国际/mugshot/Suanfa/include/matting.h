#ifndef MATTING_H
#define MATTING_H
#include <iostream>
#include <cmath>
#include <vector>
#include "mystruct.h"
using namespace std;
#include "JY_Head.h"
struct labelPoint
{
    int x;
    int y;
    int label;
};

struct Tuple
{
    MyScalar f;
    MyScalar b;
    double   sigmaf;
    double   sigmab;
    int flag;
};

struct Ftuple
{
    MyScalar f;
    MyScalar b;
    double   alphar;
    double   confidence;
};
class Matting
{
public:
    Matting();
    ~Matting();
public :
    void setSrc(unsigned char *_src,int _width,int _height);//输入原图
    void setTrimap(unsigned char *_src,int _width,int _height);//输入待确定的选区图
    void solveAlpha(unsigned char *_dst);//返回新的选区图
private:
    void expandKnown();
    void sample(MyPoint p, vector<MyPoint>& f, vector<MyPoint>& b);
    void gathering();
    void refineSample();
    void localSmooth();
    void Sample(vector<vector<MyPoint> > &F, vector<vector<MyPoint> > &B);
    void getMatte();
    void release();

    double mP(int i, int j, MyScalar f, MyScalar b);
    double nP(int i, int j, MyScalar f, MyScalar b);
    double eP(int i1, int j1, int i2, int j2);
    double pfP(MyPoint p, vector<MyPoint>& f, vector<MyPoint>& b);
    double aP(int i, int j, double pf, MyScalar f, MyScalar b);
    double gP(MyPoint p, MyPoint fp, MyPoint bp, double pf);
    double gP(MyPoint p, MyPoint fp, MyPoint bp, double dpf, double pf);
    double dP(MyPoint s, MyPoint d);
    double sigma2(MyPoint p);
    double distanceColor2(MyScalar cs1, MyScalar cs2);
    double comalpha(MyScalar c, MyScalar f, MyScalar b);
private:
    unsigned char  * pImg;//原图
    unsigned char  * trimap;//待确定区域图
    unsigned char  * matte;//灰度图像

    vector<MyPoint> uT;
    vector<struct Tuple> tuples;
    vector<struct Ftuple> ftuples;
    int height;
    int width;
    int kI;
    int kG;
    int ** unknownIndex;//Unknown的索引信息；
    int ** tri;
    int ** alpha;
    double kC;
    int step;
    int channels;
};

#endif // MATTING_H
