#ifndef SMARTSKIN_H__
#define SMARTSKIN_H__
#include "JY_Head.h"
/**********************************************************************/
/* define                                                             */
/**********************************************************************/
/* Error code */
#define SS_OK			0x00000001
#define SS_MALLOC_ERR	-0x80000001
#define SS_PARAM_ERR	-0x80000002

#ifndef _MYPOINT_
#define _MYPOINT_
/*
typedef struct tagPOINT
{
	long  x;
	long  y;
} POINT; */
#endif



/* Mask area definition */
typedef struct tagSS_MASKRECT {
	POINT lefttop;
	POINT rightbottom;
} SS_MASKRECT;


typedef void * HANDLE_SmartSkin;
typedef void * HANDLE_FACEMASK;

#ifdef __cplusplus
extern "C" {
#endif

	HANDLE_SmartSkin   JY_SmartSkin_CreateSmartSkinWhHandle();
	 /**
 * @param ss     	美化句柄
 * @param image	bgr数据
   * @param width     图片宽度（像素）
 * @param height    图片高度（像素）
 * @param BitDepth     图片深度 值为24
 * @param faceCorner   人脸 *人念书
  * @param FaceNum		图片中人脸个数
  * @param             	LEye中心 人脸个数
  * @param  			 REye中心 人脸个数
 * @return          返回值之一
 */
	HANDLE_FACEMASK   JY_SkinMask(HANDLE_SmartSkin ss,unsigned char *image,int width,int height,int BitDepth,FACEAREA *faceCorner,int faceNum,POINT *LEye,POINT *REye);
	int   JY_DeteleFACEMASK(HANDLE_FACEMASK facemask);
	
		 /**
 * @param ss     	美化句柄
 *@param  facemask   美肤句柄
 * @param image	bgr数据
   * @param width     图片宽度（像素）
 * @param height    图片高度（像素）
 * @param BitDepth     图片深度 值为24
 * @param param  		参数0-2
  * @param imageSmartSkin		返回处理后数据
 * @return          返回值之一
 */
	int   JY_Skin(HANDLE_SmartSkin ss,HANDLE_FACEMASK facemask,unsigned char *image,int width,int height,int BitDepth,double param,unsigned char *imageSmartSkin);
 /**
 	* @param image	bgr数据
   	* @param width     图片宽度（像素）
 	* @param height    图片高度（像素）
 	* @param BitDepth     图片深度 值为24
 	* @param param  		参数 0--10
  	* @param imageSmartSkin		返回处理后数据
 	* @return          返回值之一
 */
	int   JY_WhiteningSkin(unsigned char *image,int width,int height,int param,unsigned char *imageSmartSkin);
	int   JY_SmartSkin_DeteleSmartSkinHandle(HANDLE_SmartSkin ss);
#ifdef __cplusplus
}
#endif
#endif	/* SMARTSKIN_H__ */
