#ifndef CV_H
#define CV_H
typedef struct MyScalar
{
    double val[4];
}MyScalar;
inline  MyScalar  myScalar( double val0, double val1=0,double val2=0 , double val3=0)
{
    MyScalar scalar;
    scalar.val[0] = val0; scalar.val[1] = val1;
    scalar.val[2] = val2; scalar.val[3] = val3;
    return scalar;
}
inline  MyScalar  myScalarAll( double val0123 )
{
    MyScalar scalar;
    scalar.val[0] = val0123;
    scalar.val[1] = val0123;
    scalar.val[2] = val0123;
    scalar.val[3] = val0123;
    return scalar;
}

typedef struct MyPoint
{
    int x;
    int y;
}MyPoint;
inline  MyPoint  myPoint( int x=0, int y=0 )
{
    MyPoint p;
    p.x = x;
    p.y = y;
    return p;
}
#endif // CV_H
