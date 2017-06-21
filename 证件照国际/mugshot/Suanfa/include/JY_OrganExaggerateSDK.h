#ifndef OrganEx_H__
#define OrganEx_H__
#include "JY_Head.h"
#include "Common.h"


#ifdef __cplusplus
extern "C" {
#endif
	
	typedef  void *   HANDLE_OrganEx;
	
	//创建一个句柄
	HANDLE_OrganEx  JY_OrganExaggerate_CreateOrganExHandle();
	
	//单个器官夸张 返回1是成功 -1是失败
	int   JY_OrganExaggerate_ONEChange(
									   HANDLE_OrganEx  OrganEx, //夸张句柄
									   unsigned char *pSrcImg,//含有填充字节的 BGR值
									   int picWidth,//宽度
									   int picHeight,//高度
									   int BitDepth,//位深  24
									   POINT aptFeat[],//器官坐标
									   int aptFeatSize,//器官数量  左眼：aptFeatureDetail[0] 1、2、3 右眼：8、9、10、11 嘴巴：16 17、19、20
									   int OpenLevel[],//左眼：pnLeftEyeOpenLevel 右眼：pnRightEyeOpenLevel 嘴巴:pnMouthOpenLevel
									   int  type,//1是放大、0是缩小
									   double param, //参数 范围0--5
									   int OrganSelect,//器官选择  0-左眼,1-右眼，2-嘴唇
									   unsigned char *pDstImg//返回数据
									   );
	
	//用完句柄后，调用删除
	int   JY_OrganExaggerate_DeteleOrganExHandle(HANDLE_OrganEx  OrganEx);
#ifdef __cplusplus
}
#endif
#endif

