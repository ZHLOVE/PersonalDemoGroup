/*--------------------------------------------------------------------*/
/*  Copyright(C) 2008-2012 by Wuxi JunYu Technology Ltd.              */
/*  All Rights Reserved.                                              */
/*--------------------------------------------------------------------*/


#ifndef	IMAGE_H__
#define	IMAGE_H__
#include "JY_Head.h"
#include	"common.h"
#include	"CommonDef.h"

#ifndef		IMG_MALLOC
#define		IMG_MALLOC(size)	OV_MALLOC(size)		/* RAWIMAGE �m�ۗp */
#define		IMG_FREE(memblock)	OV_FREE(memblock)	/* RAWIMAGE �J���p */
#endif		/* IMG_MALLOC */

#ifdef	__cplusplus
extern "C" {
#endif	/* __cplusplus */

/*
	RAWIMAGE *ImgXXXXXXX() �ō쐬�����o�b�t�@�́AImgFree() �ō폜����
*/
void ImgFree(					/* �C���[�W�o�b�t�@�̍폜 */
	RAWIMAGE *pImage);				/* (I)	�j������o�b�t�@ */

RAWIMAGE *ImgRotate(			/* �摜�̉�] */
	INT32		*pnNewWidth,		/* (O)	��]�摜�� */
	INT32		*pnNewHeight,		/* (O)	��]�摜���� */
	RAWIMAGE	*pSrcImage,			/* (I)	���摜 */
	INT32		nWidth,				/* (I)	���摜�� */
	INT32		nHeight,			/* (I)	���摜���� */
	INT32		nDepth,				/* (I)	�[��(�a�f�q�[or�O���[) */
	double		dRadian,			/* (I)	��]�p�i���W�A���j */
	BYTE		byFillData);		/* (I)	��Ԓl */

RAWIMAGE *ImgBilinearReduce(	/* �摜�̊g��E�k�� */
	INT32		nNewWidth,			/* (I)	�ύX�㕝 */
	INT32		nNewHeight,			/* (I)	�ύX�㍂�� */
	RAWIMAGE	*pSrcImage,			/* (I)	���摜 */
	INT32		nWidth,				/* (I)	���摜�� */
	INT32		nHeight,			/* (I)	���摜���� */
	INT32		nDepth);			/* (I)	�[��(�a�f�q�[or�O���[) */
	
RAWIMAGE *ImgConvertBMPtoRAW(	/* BITMAP�摜��RAW�f�[�^ */
	BYTE		*pSrcImage,			/* (I)	BITMAP�摜(8bit�O���Cor24�J���[) */
	INT32		nWidth,				/* (I)	�摜�� */
	INT32		nHeight,			/* (I)	�摜���� */
	INT32		nLine,				/* (I)	�P���C���f�[�^�� */
	INT32		nBitCount);			/* (I)	�[��(�a�f�qor�O���[) */

RAWIMAGE *ImgResizeBound(		/* �摜�̒P�����T�C�Y */
	INT32		nNewWidth,			/* (I)	�ύX��摜�� */
	INT32		nNewHeight,			/* (I)	�ύX��摜���� */
	RAWIMAGE	*pSrcImage,			/* (I)	���摜 */
	INT32		nWidth,				/* (I)	���摜�� */
	INT32		nHeight,			/* (I)	���摜���� */
	INT32 		nDepth);			/* (I)	�[��(�a�f�qor�O���[) */

RAWIMAGE *ImgClip(				/* �摜�̐؂�o�� */
	RAWIMAGE	*pSrcImage,			/* (I)	���摜 */
	INT32		nWidth,				/* (I)	���摜�� */
	INT32		nHeight,			/* (I)	���摜���� */
	INT32		nDepth,				/* (I)	�[��(�a�f�qor�O���[) */
	RECT		rect,				/* (I)	�؂�o���ʒu */
	BYTE		byFillData);		/* (I)	��Ԓl */

RAWIMAGE *ImgFastClip(			/* �摜�̍����؂�o���i��]�{���T�C�Y�{�N���b�s���O�j */
	RAWIMAGE	*pSrcImage,			/* (I)	���摜 */
	INT32		nWidth,				/* (I)	���摜�� */
	INT32		nHeight,			/* (I)	���摜���� */
	INT32		nDepth,				/* (I)	�[��(�a�f�qor�O���[) */
	POINT		ptLeftTop,			/* (I)	�؂�o����`�ʒu�i����j */
	double		dAngle,				/* (I)	��]�p�i���W�A���j */
	double		dScaleX,			/* (I)	�䗦�i���j */
	double		dScaleY,			/* (I)	�䗦�i�����j */
	INT32		nClipWidth,			/* (I)	�؂�o�����摜�� */
	INT32		nClipHeight,		/* (I)	�؂�o�����摜���� */
	BYTE		byFillData);		/* (I)	��Ԓl */

RAWIMAGE *ImgFastClipToGray(	/* �摜�̍����؂�o���i�O���[�ϊ�����j */
	RAWIMAGE	*pSrcImage ,		/* (I)	���摜 */
	INT32		nWidth ,			/* (I)	���摜�� */
	INT32		nHeight ,			/* (I)	���摜���� */
	INT32		nDepth ,			/* (I)	�[��(�a�f�qor�O���[) */
	POINT		ptLeftTop ,			/* (I)	�؂�o����`�ʒu�i����j */
	double		dAngle ,			/* (I)	��]�p�i���W�A���j */
	double		dScaleX ,			/* (I)	�䗦�i���j */
	double		dScaleY ,			/* (I)	�䗦�i�����j */
	INT32		nClipWidth ,		/* (I)	�؂�o�����摜�� */
	INT32		nClipHeight ,		/* (I)	�؂�o�����摜���� */
	BYTE		byFillData);		/* (I)	��Ԓl */

RAWIMAGE *ImgConvertBGRtoGRAY(	/* BGR�f�[�^��GRAY�f�[�^ */
	RAWIMAGE	*pSrcImage,			/* (I)	BGR */
	INT32		nWidth,				/* (I)	�摜�� */
	INT32		nHeight);			/* (I)	�摜���� */

void ImgGammaCorrectGS(			/* ���␳�i�O���C�̂݁j */
	RAWIMAGE	*pSrcImage,			/* (I)	���摜 */
	INT32		nWidth,				/* (I)	���摜�� */
	INT32		nHeight,			/* (I)	���摜���� */
	double		dGamma);			/* (I)	���l */

int ImgCalcAverageGS(			/* ��f�l���ρi�O���C�̂݁j */
	RAWIMAGE	*pSrcImage,			/* (I)	���摜 */
	INT32		nWidth,				/* (I)	���摜�� */
	INT32		nHeight,			/* (I)	���摜���� */
	INT32		nSkipping);			/* (I)	�X�L�b�v�� */

#ifdef	__cplusplus
}
#endif	/* __cplusplus */

#endif	/* IMAGE_H__ */
