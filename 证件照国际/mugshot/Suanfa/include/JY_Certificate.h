#ifndef  JY_CERTIFICATE_H_
#define  JY_CERTIFICATE_H_



#define		IDPHOTO_TYPE_1INCH		0
#define		IDPHOTO_TYPE_S2INCH		1
#define		IDPHOTO_TYPE_2INCH		2
#define		IDPHOTO_TYPE_USAVISA	3
#define		IDPHOTO_TYPE_NOUSE1		4
#define		IDPHOTO_TYPE_GUOKAO1	5
#define		IDPHOTO_TYPE_GUOKAO2	6
#define		IDPHOTO_TYPE_GUOKAO3	7
#define		IDPHOTO_TYPE_GUOKAO4	8

#define		IDPHOTO_TYPES			9



#ifdef __cplusplus
 extern "C" {
 #endif
//#include <android/log.h>
/*
#ifndef _MYPOINT_
#define _MYPOINT_

typedef struct tagPOINT
{
	long  x;
	long  y;
} POINT;

#endif
*/
#include "JY_Head.h"
typedef void * HANDLE_Certi;


struct POINT_F
{
    double  x1;
    double  x2;
    double  y1;
    double  y2;
};

#ifndef __IDPhotoInfo_t
#define __IDPhotoInfo_t
struct IDPhotoInfo_t
{
	int photow;
	int photoh;
	double x1;
	double x2;
	double y1;
	double y2;
	double headlen1;
	double headlen2;
	double eyebtm1;
	double eyebtm2;
	double headtop1;
	double headtop2;
};
#endif
     

//获取5个框
/**
_width：宽
_height：高
ft：37个定位点
//rectangle：20个值，对应5个框  每个框顺序顶点x,y底端x,y
*/
//void JY_CertiArea(int _width,int _height,POINT ft[],int rectangle[]);

//获取9个框
/**
_width：宽
_height：高
ft：38个定位点
rectangle：36个值，对应9个框  每个框顺序顶点x,y底端x,y

*/
void JY_CertiArea(int _width,int _height,POINT ft[],int rectangle[]);

//获取最终框add by zhou 
void JY_CertiDstArea(int _width,int _height,POINT ft[],IDPhotoInfo_t _info,int rectoutput[]);


//分割原图像 得到黑白图
/************耗时函数*/
/**
_src:bgr 
_width:宽
_height:高
ft:37个定位点
pt88:88个定位点
_dst:灰度图 
*/



void JY_CertiGetAlpha(
	void* FA,
	unsigned char*_src,
	int _width,int _height,IDPhotoInfo_t info,
	POINT apt[],
	POINT ft[],
	POINT pt88[],
	unsigned char *_dst				//(O) foreground object mask image (size: _width*_height)
	);



/***************************************///
//下面的功能函数是第一版本使用，这个版本已经全部取消掉
/***************************************///

//下面的操作都是基于原图和黑白图进行的
//获取句柄 一张图片一个句柄，用来释放再进行下一张
/**
_src:bgr   
_bg：灰度 
_width:宽
_height:高
_param:背景  0--红  1--白  2--蓝
_dst:bgr生成图像  显示出来
HANDLE_Certi ：返回句柄，以供下面增加删除区域使用
*/
HANDLE_Certi JY_CertiCreateImg(unsigned char *_src,unsigned char *_bg,int _width,int _height,int _param,unsigned char *_dst);

//删除背景点
/**
_certi：句柄
_seedx：点x
_seedy：点y
_r：半径 1--7
_dst:bgr生成图像  显示出来
*/

void JY_CertiDelete(HANDLE_Certi _certi,int _seedx,int _seedy,int _r,unsigned char *_dst);

//增加背景点
/**
_certi：句柄
_seedx：点x
_seedy：点y
_r：半径 1--7
_dst:bgr生成图像  显示出来
*/
void JY_CertiInert(HANDLE_Certi _certi,int _seedx,int _seedy,int _r,unsigned char *_dst);


//切换显示背景
/**
_certi：句柄
_param:背景  0--红  1--白  2--蓝
_dst:bgr生成图像  显示出来
*/
void JY_CertiCos(HANDLE_Certi _certi,int _param,unsigned char *_dst);

//返回经过涂抹的新的黑白图  用于上传服务器
/**
_certi：句柄
_bg:黑白图  
*/
void JY_CertiReturnBG(HANDLE_Certi _certi,unsigned char *_bg);

//涂抹前的备份
/**
_certi：句柄
*/
void JY_CerBackup(HANDLE_Certi _certi);

//涂抹后的撤销
/**
_certi：句柄
_src:bgr 用来显示
*/
void JY_CerRevoke(HANDLE_Certi _certi,unsigned char *_src);

//释放句柄
/**
_certi：句柄
*/
void JY_CerFreeHandle(HANDLE_Certi _certi);

void BilinearRGB(unsigned char * src,int width,int height,int neww,int newh,unsigned char * dst);

void   _get_idphotoinfo(
		unsigned char const	*mask,
		int		nMaskWidth,
		int		nMaskHeight,
		POINT	pt88[],				//(I)
		int     headarea[],			//(O) head area boundary rect
		int		hsarea[]			//(O) head shoulder boundary rect
	);
//bool	_adjustclipbox(
//	const int		headarea[4],		//(I)
//	const int		hsarea[4],
//	const POINT		eyepos[2],			//(I)
//	const int		centerX,
//	const int		clipbox[],			//(I)
//	const int		idtype,
//	int				adbox[]			//(O)	
//	);
	bool	_adjustclipbox(
		const int		headarea[4],		//(I)
		const int		hsarea[4],
		const POINT		eyepos[2],			//(I)
		const int		centerX,
		const int		clipbox[],			//(I)
		const IDPhotoInfo_t	info,
		int				adbox[]			//(O)	
	);

//void   _orgrect2maskrect(
//		const	int		nRectNO,	//(I)
//		const	int		orgrect[],	//(I)
//		const   int     topx,
//		const   int		topy,		
//		int		maskrect[] 			//(O)
//	);
	void _orgrect2maskrect(
		const int orgrect[],    //(I)
		const int topx,         //(I)
		const int topy, 
		int maskrect[]          //(O)
	);


#ifdef __cplusplus
}
#endif
#endif
