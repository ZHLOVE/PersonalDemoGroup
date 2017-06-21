#ifndef FaceFR_H__
#define FaceFR_H__
#include "Common.h"
#ifdef __cplusplus
 extern "C" {
 #endif
#include "JY_Head.h"
 
typedef void * HANDLEFaceFreckleRem;
typedef void *  HANDLEFRECK;


HANDLEFaceFreckleRem  JY_FaceFreckleRem_CreateFaceFreckleRemHandle();

 /**
 * @param FaceFreckleRem     	祛斑的句柄
 * @param pImgData1	bgr数据
 * @param iHeight    图片高度（像素）
  * @param iWidth     图片宽度（像素）
 * @param ibpp     图片深度 值为24
  * @param FaceNum		图片中人脸个数
   * @param Face		人脸*FaceNum
 * @param aptFA		88定位点*FaceNum
 * @return          返回值之一
 */
 
HANDLEFRECK   JY_FaceFreckle(HANDLEFaceFreckleRem  FaceFreckleRem,unsigned char* pImgData1, int iHeight,int iWidth, int ibpp,int FaceNum, FACEAREA *Face, POINT	aptFA[]);
int    JY_DeteleFaceFRECKHandle(HANDLEFRECK  freck);
 /**
 * @param FaceFreckleRem     	祛斑的句柄
 * @param freck      初步处理句柄
 * @param pImgData	bgr数据
 * @param iHeight    图片高度（像素）
  * @param iWidth     图片宽度（像素）
 * @param ibpp     图片深度 值为24
  * @param FaceNum		图片中人脸个数
   * @param param		参数
 * @param pShowData		返回人脸
 * @return          返回值之一
 */
 
int   JY_FaceFreckleRem(HANDLEFaceFreckleRem  FaceFreckleRem, HANDLEFRECK freck,unsigned char* pImgData,int iHeight, int iWidth, int ibpp, int FaceNum,double param,unsigned char *pShowData);


int    JY_FaceFreckleRem_DeteleFaceFreckleRemHandle(HANDLEFaceFreckleRem  FaceFreckleRem);
 
#ifdef __cplusplus
	}
 #endif
#endif
