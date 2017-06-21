/*--------------------------------------------------------------------*/
/*  Copyright(C) 2008-2012 by JunYu Technology Ltd.                   */
/*  All Rights Reserved.                                              */
/*  Ver 2.2.3.920													  */
/*--------------------------------------------------------------------*/



#ifndef	SDKFPGE_H__
#define	SDKFPGE_H__


/*------------------------------------------------------------------*/
/* Error Code */
/*------------------------------------------------------------------*/
#define	FPGE_NORMAL					0	/* Exit without error */
#define	FPGE_ERR_UNDEF				-1	/* Undefined error */
#define	FPGE_ERR_INITIALIZE			-2	/* Initialization error */
#define	FPGE_ERR_INVALIDPARAM		-3	/* Invalid parameters */
#define	FPGE_ERR_ALLOCMEMORY		-4	/* Memory allocation failed */


/*----- Index of Key Facial Points -----*/
enum FPGE_FEATURE_POINT_INDEX {
	FPGE_FEATURE_LEFT_EYE = 0,				/* Center of Left Eye */
		FPGE_FEATURE_RIGHT_EYE,					/* Center of Right Eye */
		FPGE_FEATURE_MOUTH,						/* Center of Mouth */
		FPGE_FEATURE_LEFT_EYE_IN,				/* inner left eye corner */
		FPGE_FEATURE_LEFT_EYE_OUT,				/* outer left eye corner */
		FPGE_FEATURE_RIGHT_EYE_IN,				/* inner right eye corner */
		FPGE_FEATURE_RIGHT_EYE_OUT,				/* outer right eye corner */
		FPGE_FEATURE_MOUTH_LEFT,					/* left mouth corner */
		FPGE_FEATURE_MOUTH_RIGHT,				/* right mouth corner */
		FPGE_FEATURE_LEFT_EYE_PUPIL,				/* center of left eye */
		FPGE_FEATURE_RIGHT_EYE_PUPIL,			/* center of right eye  */
		FPGE_FEATURE_KIND_MAX					/* number of facial points of simplified version*/
};

	/* Facial points of detailed version */
	#define FPGEPS_FEATURE_NUM				38


	/* Index of facial points of detailed version */
	#define FPGEPS_EYE_L_OUT				0
	#define FPGEPS_EYE_L_IN					1
	#define FPGEPS_EYE_L_UP					2
	#define FPGEPS_EYE_L_DOWN				3
	#define FPGEPS_EYE_L_L_UP				4
	#define FPGEPS_EYE_L_R_UP				5
	#define FPGEPS_EYE_L_L_DOWN				6
	#define FPGEPS_EYE_L_R_DOWN				7
	#define FPGEPS_EYE_R_OUT				8
	#define FPGEPS_EYE_R_IN					9
	#define FPGEPS_EYE_R_UP					10
	#define FPGEPS_EYE_R_DOWN				11
	#define FPGEPS_EYE_R_L_UP				12
	#define FPGEPS_EYE_R_R_UP				13
	#define FPGEPS_EYE_R_L_DOWN				14
	#define FPGEPS_EYE_R_R_DOWN				15
	#define FPGEPS_MOUTH_L					16
	#define FPGEPS_MOUTH_R					17
	#define FPGEPS_MOUTH_UP					18
	#define FPGEPS_UPLIP_CENTER				19
	#define FPGEPS_DOWNLIP_CENTER			20
	#define FPGEPS_MOUTH_DOWN				21
	#define FPGEPS_MOUTH_UP_L_L				22
	#define FPGEPS_UPLIP_L_L				23
	#define FPGEPS_DOWNLIP_L_L				24
	#define FPGEPS_MOUTH_DOWN_L_L			25
	#define FPGEPS_MOUTH_UP_L_R				26
	#define FPGEPS_UPLIP_L_R				27
	#define FPGEPS_DOWNLIP_L_R				28
	#define FPGEPS_MOUTH_DOWN_L_R			29
	#define FPGEPS_MOUTH_UP_R_L				30
	#define FPGEPS_UPLIP_R_L				31
	#define FPGEPS_DOWNLIP_R_L				32
	#define FPGEPS_MOUTH_DOWN_R_L			33
	#define FPGEPS_MOUTH_UP_R_R				34
	#define FPGEPS_UPLIP_R_R				35
	#define FPGEPS_DOWNLIP_R_R				36
	#define FPGEPS_MOUTH_DOWN_R_R			37

#ifdef __cplusplus
extern "C" {
#endif

typedef  void*   HANDLE_FPGE;

/*------------------------------------------------------------------*/
/* Parameters */
/*------------------------------------------------------------------*/

/* Face Area */
typedef struct  {
	POINT ptLeftTop;		/* left top */
	POINT ptRightTop;		/* right top */
	POINT ptLeftBottom;		/* left bottom */
	POINT ptRightBottom;	/* right bottom */
} FPGE_FACEAREA;   /* because of rotation in image plane*/


/* Face Area Information */
typedef struct {
	FPGE_FACEAREA faceArea;			/*  face rectangular coordinates */
	int nFaceDirection;	    	/*  face pose/direction	*/
} FPGE_FACEINFO;



/****************************************************************************/
/* Function:  Parameter initialization										*/
/* Return:    Error code													*/
/* Description:    Initialize handle and parameters							*/
/****************************************************************************/

HANDLE_FPGE  JY_FACE_CreateFPGEHandle(const void  *pBIN);

/****************************************************************************/
/* Function:  Release parameters 										*/
/* Return:    Error code													*/
/* Description:    Release handle and parameters								*/
/****************************************************************************/
int  JY_FACE_DeleteFPGEHandle(
										 HANDLE_FPGE  hFPGE					/* (I/O) parameters */
										 );

/****************************************************************************/
/* Function:    Localize facial points														*/
/* Return:      Error code  												*/
/* Description: To localize pre-defined facial points												*/
/****************************************************************************/
int   JY_FACE_LocRoughFP(
							   HANDLE_FPGE		hFPGE,					        /* (I) handle */
							   uint8_t		        *pRawImage,				/* (I) RAW image data */
							   int			    nWidth,					/* (I) image width */
							   int			    nHeight,				/* (I) image height */
							   int			    nDepth,					/* (I) image color */
							   FPGE_FACEINFO	*pFaceInfo,				/* (I) face information */
							   POINT			aptFeature[],			/* (O) facial points */
							   int			    anConfidence[],			/* (O) confidence of every facial points */
							   int			    *pnPitch,				/* (O) pitch angle (up/down) */
							   int			    *pnYaw,					/* (O) yaw angle (left/right) */
							   int			    *pnRoll				/* (O) roll angle (in image plane) */
							   );



/****************************************************************************/
/* Function: Gaze estimation														*/
/* Return: Error code													*/
/* Description: Estimate gaze and localize facial points											*/
/****************************************************************************/
int  JY_FACE_LocDetailedFPandGE(
									  HANDLE_FPGE		hFPGE,					        /* (I) handle */
									  uint8_t		        *pRawImage, 						/* (I) RAW image data						*/
									  int				nWidth,							/* (I) image width								*/
									  int				nHeight,						/* (I) image height									*/
									  int				nDepth,							/* (I) image color depth								*/
									  FPGE_FACEINFO	*pFaceInfo,						/* (I) face information							*/
									  int				*pnGazeLR,						/* (O) Gaze direction (left/right)					*/
									  int				*pnGazeUD,						/* (O) Gaze direction (up/down)					*/
									  int				*pnConfidenceGaze,				/* (O) confidence of gaze estimation					*/
									  POINT			aptFeatureDetail[],				/* (O) please refer above definitions			*/
									  int				anConfidenceDetail[],			/* (O) ~~~ */
									  POINT			aptFeature[],					/* (O) ~~~					*/
									  int				anConfidence[],					/* (O) ~~~						*/
									  int				*pnLeftEyeOpenLevel,			/* (O) ~~~						*/
									  int				*pnRightEyeOpenLevel,			/* (O) ~~~						*/
									  int				*pnMouthOpenLevel,				/* (O) ~~~							*/
									  int				*pnLeftEyeOpenLevelConfidence,	/* (O) ~~~				*/
									  int				*pnRightEyeOpenLevelConfidence,	/* (O) ~~~				*/
									  int				*pnMouthOpenLevelConfidence,	/* (O) ~~~					*/
									  int				*pnPitch,						/* (O) ~~~					*/
									  int				*pnYaw,							/* (O) ~~~				*/
									  int				*pnRoll						    /* (O) ~~~					*/
									  );

#ifdef __cplusplus
}
#endif

#endif	/* SDKDT_H__ */
