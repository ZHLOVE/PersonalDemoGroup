#ifndef  JY_CosmeticEye_H_
#define  JY_CosmeticEye_H_
#include "Common.h"
#include "JY_Head.h"




#ifdef __cplusplus
extern "C"{
#endif


	typedef void* HANDLE_CosEye;
	HANDLE_CosEye  JY_CosmeticEye_CreateHandle(							
		unsigned char *src,
		int width,
		int height,
		int nDepth);
		
	int   JY_CosmeticEye_Change(
		HANDLE_CosEye CosEye,//参数句柄
		unsigned char *pSrcImage,//BGR输入图像
		int nwidth,//宽度
		int nHeight,//高度
		int nDepth,//位深 24
		POINT aptFa[],//器官坐标	左眼顺序：aptFeat[4] aptFeat[3]	est88pt[2]	est88pt[3]右眼顺序aptFeat[5]aptFeat[6]est88pt[18]est88pt[19]
		int aptFeatSize,//坐标点个数
		double Contrast,//参数 
		unsigned char *pDesImage//返回BGR图像
		);
	int   JY_CosmeticEye__DeteleHandle(HANDLE_CosEye  CosEye);

#ifdef __cplusplus
}
#endif

#endif

