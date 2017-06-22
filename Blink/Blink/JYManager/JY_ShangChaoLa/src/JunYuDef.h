/*--------------------------------------------------------------------*/
/*  Copyright(C) 2008-2011 by JunYu Tech. Ltd.                        */
/*  All Rights Reserved.                                              */
/*--------------------------------------------------------------------*/

/*
	Used on Windows platform to replace windows.h
*/


#ifndef	JUNYUDEF_H__
#define	JUNYUDEF_H__

typedef		signed char			INT8;
typedef		unsigned char		UINT8;
typedef		signed short		INT16;
typedef		unsigned short		UINT16;
typedef		signed int			INT32;
typedef		unsigned int		UINT32;

typedef		float		FLOAT32;
typedef		double		FLOAT64;

typedef		unsigned char		BYTE;
typedef		unsigned short		WORD;
typedef		unsigned long		DWORD;

typedef		int					BOOL;

typedef		char				CHAR;
#ifndef 	FALSE
#define 	FALSE				0
#endif
#ifndef 	TRUE
#define 	TRUE				1
#endif

typedef	struct tagJYPOINT {
	INT32	x;
	INT32	y;
} JY_POINT;

typedef struct tagJYSIZE {
	INT32	cx;
	INT32	cy;
} JY_SIZE;

typedef struct tagJYRECT {
	INT32	left;
	INT32	top;
	INT32	right;
	INT32	bottom;
} JY_RECT;

typedef   JY_POINT   POINT;    
typedef   JY_RECT    RECT;
typedef   JY_SIZE    SIZE; 




#endif	/* JUNYUDEF_H__ */
