/*--------------------------------------------------------------------*/
/*  Copyright(C) 2008-2012 by JunYu Technology Ltd.                   */
/*  All Rights Reserved.                                              */
/*  Ver 1.0.0.1													      */
/*--------------------------------------------------------------------*/



#ifndef	SDKFA_H__
#define	SDKFA_H__


#ifdef __cplusplus
extern "C" {
#endif

/*------------------------------------------------------------------*/
/* Error Code */
/*------------------------------------------------------------------*/
#define		FA_NORMAL				 0		/*   */
#define		FA_TIMEOUT			     1		/*   */
#define		FA_ERR_VARIOUS	     	-1		/*   */
#define		FA_ERR_INITIALIZE		-2		/*   */
#define		FA_ERR_INVALIDPARAM  	-3		/*   */
#define		FA_ERR_ALLOCMEMORY	    -4		/*   */
#define		FA_ERR_MODEDIFFERENT	-5		/*   */
#define		FA_ERR_NOALLOC		    -6		/*   */
#define		FA_ERR_NOHANDLE		    -7		/*   */

#ifndef _MYPOINT_
#define _MYPOINT_
    typedef struct tagPOINT
    {
        int  x;
        int  y;
    } POINT;
#endif

typedef  void*   HANDLE_FA;


HANDLE_FA  JY_FACE_CreateFAHandle(const void  *pBIN);
int        JY_FACE_DeleteFAHandle(
									   HANDLE_FA  hFA					/* (I/O) parameters */
									   );

int		    JY_FACE_Alignment(
								   HANDLE_FA		hFA,					/* (I/O) parameters */
								   uint8_t		    *pRawImage,				    /* (I) RAW image data */
								   int			    nWidth,					/* (I) image width */
								   int			    nHeight,				/* (I) image height */
								   int			    nDepth,					/* (I) image color */
								   POINT			aptFeature[],			/* (I) key facial points returned by FPGE_LocRoughFP()*/
								   int			    anConfidence[],			/* (I) confidence of all key facial points */
								   int			    nPitch,					/* (I) pitch angle (up/down) */
								   int			    nYaw,					/* (I) yaw angle (left/right) */
								   int			    nRoll,					/* (I) roll angle (in image plane) */
								   POINT			aptFA[]				    /* (O) detailed 88 points of face alignment*/
		  );





#ifdef __cplusplus
}
#endif





#endif	/* SDKDT_H__ */
