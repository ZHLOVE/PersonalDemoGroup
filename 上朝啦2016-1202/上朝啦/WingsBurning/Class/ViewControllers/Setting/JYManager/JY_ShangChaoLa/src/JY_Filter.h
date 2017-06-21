#ifndef JY_FILTER_H
#define JY_FILTER_H
#include "JY_Head.h"
#include <iostream>
using namespace std ;
typedef unsigned char  BYTE;
#ifndef _wyjPOINT_
#define _wyjPOINT_
typedef struct tagWyjPOINT
{
    int  x;
    int  y;
} WyjPOINT;
#endif
void SetBright(BYTE &R, BYTE &G, BYTE &B, int bValue) ;
void SetHueAndSaturation(BYTE &R, BYTE &G, BYTE &B, int hValue, int sValue) ;
void SetHueAndSaturation(BYTE &R, BYTE &G, BYTE &B, int hValue, int sValue)  ;
int JY_Filter(BYTE *imgSrc,int nWidth ,int nHeight,double type,int param,BYTE *imgDst);
void curve(WyjPOINT* controlPts,int count, WyjPOINT* outputPts);
#endif
