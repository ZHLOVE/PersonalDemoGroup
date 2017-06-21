/*--------------------------------------------------------------------*/
/*  Copyright(C) 2008-2012 by Wuxi JunYu Technology Ltd.              */
/*  All Rights Reserved.                                              */
/*--------------------------------------------------------------------*/


#ifndef IMAGEFORMAT_H__
#define IMAGEFORMAT_H__


/* malloc(), free()���}�N���Œ�`���Ă��� */
#ifndef		SS_MALLOC
//#include	<malloc.h>
#define		SS_MALLOC( nSize )		OV_MALLOC( nSize )
#define		SS_FREE( pMemArea )		OV_FREE( pMemArea )
#endif		/* SS_MALLOC */

typedef struct tagIMG8_RGB {
	unsigned char r;
	unsigned char g;
	unsigned char b;
} IMG8_RGB;

/* RGB->Lab�ϊ��pdefine */
typedef struct tagLAB_DATA {
	double l;		/* �k�����̂k */
	double a;		/* �k�����̂� */
	double b;		/* �k�����̂� */
} LAB_DATA;

#ifdef __cplusplus
extern "C" {
#endif
	extern IMG8_RGB **AllocIMG8_RGB(int width, int height);
	extern void FreeIMG8_RGB(IMG8_RGB **img);

	extern void GetBGR_888( void *image, int width, int height, IMG8_RGB **fimg);
	extern int ReduceImage8(unsigned char *org_c, int width, int height, unsigned char *org0_p, int per);
	extern int ReduceImageGray(unsigned char *org_c, int width, int height, unsigned char *org0_p, int per);

	extern int ExpandSkin8_GRAY(unsigned char *skin_all_g, int width, int height, unsigned char *skin_g, int per);
	extern int ExpandSkin8_RGB(unsigned char *src, int width, int height, unsigned char *dst, int per);
	extern int ExpandSkin8_RGBx4(unsigned char *src, int width, int height, unsigned char *dst);

	extern void DbgImgOutRawRGB(char *fname, unsigned char *dat, int width, int height);
	extern void DbgImgOutRawBGR(char *fname, unsigned char *dat, int width, int height);
	extern void DbgImgOutRawGray(char *fname, unsigned char *dat, int width, int height);

	extern void SS_ErosionImage(unsigned char *in_g, int width, SS_MASKRECT maskrt, unsigned char *out_g);
	extern void SS_BlurImage(unsigned char *in_g, int width, SS_MASKRECT maskrt, int nMinData, unsigned char *out_g);
	extern void SS_DilationImage(RAWIMAGE *pIn, INT32 nWidth, INT32 nFaceNum, SS_MASKRECT *pMask, RAWIMAGE *pOut);

#ifdef __cplusplus
}
#endif

#endif	/* IMAGEFORMAT_H__ */
