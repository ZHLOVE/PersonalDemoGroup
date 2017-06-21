/*--------------------------------------------------------------------*/
/*  Copyright(C) 2008-2013 by JunYu Technology Ltd.                   */
/*  All Rights Reserved.                                              */
/*  Ver 2.2.4.1030													  */
/*--------------------------------------------------------------------*/


#ifndef	SDKDT_H__
#define	SDKDT_H__



/*------------------------------------------------------------------*/
/* Definitions */
/*------------------------------------------------------------------*/

//definitions for detection pose (Yaw angle) configuration 
#define	DT_POSE_FRONT			0x01	/* Detection of front face */
#define	DT_POSE_HALF_PROFILE	0x03	/* Detection of (left, right) half profile & front face*/
#define	DT_POSE_FULL_PROFILE	0x07	/* Detection of (left, right) full profile & 
                                               (left, right) half profile & front face*/
//definitions for detection angle (Roll angle, part 1) configuration
#define	DT_ANGLE_1WAY			0x01	/* Detection of upright faces(0), actually range [-15,15] */
#define	DT_ANGLE_3WAY			0x03	/* Detection of upright, left & right rotated faces(0,-30,+30), actually range [-45, 45] */

//definitions for detection angle (Roll angle, part 2) configuration
/* the user can specify any combinations of the following four directions, 
  for example
  dir = DT_DIRECTION_UP | DT_DIRECTION_RIGHT | DT_DIRECTION_LEFT | DT_DIRECTION_DOWN  to select all four directions;
  dir = DT_DIRECTION_UP  to detect only upright faces;
*/
#define	DT_DIRECTION_UP			0x01	/* Detection of up direction, actual maximum range [-45,45] */
#define	DT_DIRECTION_RIGHT		0x02	/* Detection of right direction, actually range [45, 135] */
#define	DT_DIRECTION_LEFT		0x04	/* Detection of left direction, actually range [-135, -45] */
#define	DT_DIRECTION_DOWN		0x08	/* Detection of down directions, actually range [-180, -135] U [135, 180] */


/*------------------------------------------------------------------*/
/* Error Code */
/*------------------------------------------------------------------*/
#define		DT_NORMAL				 0		/*   */
#define		DT_TIMEOUT			     1		/*   */
#define		DT_ERR_VARIOUS	     	-1		/*   */
#define		DT_ERR_INITIALIZE		-2		/*   */
#define		DT_ERR_INVALIDPARAM  	-3		/*   */
#define		DT_ERR_ALLOCMEMORY	    -4		/*   */
#define		DT_ERR_MODEDIFFERENT	-5		/*   */
#define		DT_ERR_NOALLOC		    -6		/*   */
#define		DT_ERR_NOHANDLE		    -7		/*   */
#define		DT_ERR_DUPLICATE		-8		/*   */



#ifdef __cplusplus
extern "C" {
#endif


/*------------------------------------------------------------------*/
/* Types */
/*------------------------------------------------------------------*/
#ifndef _JYPOINT_
#define _JYPOINT_
    typedef	struct tagJYPOINT {
        int	x;
        int	y;
    } JY_POINT;
#endif
#ifndef _MYPOINT_
#define _MYPOINT_
    typedef struct tagPOINT
    {
        int  x;
        int  y;
    } POINT;
#endif
typedef  void*   HANDLE_DT;

typedef struct tagDTResult
{
	POINT		ptLeftTop;            /* left top position */
	POINT		ptRightTop;           /* right top position */
	POINT		ptLeftBottom;         /* left bottom position */
	POINT		ptRightBottom;        /* right bottom position */
	int         nConf;                /* detection confidence */
	int         nPose;                /* estimated Yaw angle of detection*/
} stDTResult;


//*********************************************************************
//Function: create face detection handle;
//Return value:  error code, 
//               the return value is NULL when the call fails;
//Note: 
//*********************************************************************
HANDLE_DT  JY_FACE_CreateDTHandle(const void  *pBIN);


//*********************************************************************
//Function: create face detection handle;
//Return value:  error code, 
//               the return value is NULL when the call fails;
//Note: 
//*********************************************************************

int  JY_FACE_DeleteDTHandle(
						 HANDLE_DT  hDT               /* (I)		  */
						 );				

//*********************************************************************
//Function: create face detection handle;
//Return value:  error code, 
//               the return value is NULL when the call fails;
//Note: 
//*********************************************************************
int  JY_FACE_Detection(
	HANDLE_DT		hDT,					/* (I)		  */
	unsigned char		*pImage,			/* (I)		  */
	int				nWidth,				/* (I)		  */
	int				nHeight,			/* (I)		  */
	int				nDepth,				/* (I)		    */
	stDTResult      **ppDTResult,
	int             *pnDTCount);		/* (O)	  */


//*********************************************************************
//Function: create face detection handle;
//Return value:  error code, 
//               the return value is NULL when the call fails;
//Note: 
//*********************************************************************
int  JY_FACE_DeleteDTResult(
						stDTResult      *pDTResult
						);			/* (I)	*/




//*********************************************************************
//Parameters setup functions
//*********************************************************************

int  JY_FACE_GetDTPose(
								  HANDLE_DT		hDT,			/* (I)		  */
								  int*             pnPose);			/* (O)	 nPose */

int  JY_FACE_SetDTPose(
								  HANDLE_DT		hDT,			/* (I)		  */
								  int           nPose);			/* (I)	 nPose */


//---------------------------------------------------------------------
//Function: Set the face detection step;
//Return value:  error code, 
//---------------------------------------------------------------------
int  JY_FACE_GetDTStep(
								  HANDLE_DT		hDT,			/* (I)		  */
								  int*			pnStep)	;		/* (O)	 10<=nStep<=40 */
int  JY_FACE_SetDTStep(
								  HANDLE_DT		hDT,			/* (I)				   */
								  int			nStep);			/* (I)	 10<=nStep<=40 */

//---------------------------------------------------------------------
//Function: Set the face detection angle & direction;
//Return value:  error code, 
//---------------------------------------------------------------------

int  JY_FACE_GetDTAngle(
								   HANDLE_DT		hDT,		/* (I)		  */
								   int*				pnAngle);   /* (O)	 Angle*/

int  JY_FACE_SetDTAngle(
								   HANDLE_DT		hDT,			/* (I)		  */
								   int              nAngle);		/* (I) Please refer to the SdkDT.h for the valid values*/

int  JY_FACE_GetDTDirection(
									   HANDLE_DT		hDT,		/* (I)		  */
									   int*				pnDirection);   /* (O)	 Direction*/

int  JY_FACE_SetDTDirection(
									   HANDLE_DT		hDT,			/* (I)		  */
									   int              nDirection);		/* (I) Please refer to the SdkDT.h for the valid values*/

//*********************************************************************
//Function:  ;
//Return value:  error code, 
//*********************************************************************
int  JY_FACE_SetDTFaceSizeRange(
						   HANDLE_DT		hDT,			/* (I)		  */
						   int				nMinSize,			/* (I)		  */
						   int				nMaxSize);			/* (I)		  */


int  JY_FACE_GetDTFaceSizeRange(
							HANDLE_DT		hDT,					/* (I)		  */
							int				*pnMinSize,			/* (O)		  */
							int				*pnMaxSize)	;		/* (O)		  */

//*********************************************************************
//Function:  ;
//Return value:  error code, 
//*********************************************************************
int  JY_FACE_GetDTThreshold(
									   HANDLE_DT		hDT,					/* (I)		  */
									   int				*pnThresh			/* (O)		  */
									   );			

int  JY_FACE_SetDTThreshold(
									   HANDLE_DT		hDT,			/* (I)		  */
									   int				nThresh			/* (I)		  */
									   );

#ifdef __cplusplus
}
#endif

#endif	/* SDKDT_H__ */
