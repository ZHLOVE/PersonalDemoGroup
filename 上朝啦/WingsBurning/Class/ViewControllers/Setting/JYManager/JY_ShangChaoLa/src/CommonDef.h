/*--------------------------------------------------------------------*/
/*  Copyright(C) 2008-2015 by JunYu Tech. Ltd.                        */
/*  All Rights Reserved.                                              */
/*--------------------------------------------------------------------*/

#ifndef	COMMONDEF_H__
#define	COMMONDEF_H__

	

/*-----    -----*/
enum FEATURE_POINT {
	FEATURE_LEFT_EYE = 0,				 
	FEATURE_RIGHT_EYE,					 
	FEATURE_MOUTH,						 
 
	FEATURE_LEFT_EYE_IN,				 
	FEATURE_LEFT_EYE_OUT,				 
	FEATURE_RIGHT_EYE_IN,				 
	FEATURE_RIGHT_EYE_OUT,				 
	FEATURE_MOUTH_LEFT,					 
	FEATURE_MOUTH_RIGHT,				 
	FEATURE_LEFT_EYE_PUPIL,				 
	FEATURE_RIGHT_EYE_PUPIL,			 
	FEATURE_KIND_MAX					 
};

/*----------*/
#define	FEATURE_NO_POINT		-1			/* not valid point (x,y) */

/*----- API return code -----*/
#define		JUNYU_OK				0	 
#define		JUNYU_ERR_UNKNOWN		-1	
#define		JUNYU_ERR_INITIAL		-2		 
#define		JUNYU_ERR_INVALIDPARAM	-3		 
#define		JUNYU_ERR_ALLOCMEMORY	-4		 
#define		JUNYU_ERR_INVALIDHANDLE	-5		 
	 
 

#endif	/* COMMONDEF_H__ */

