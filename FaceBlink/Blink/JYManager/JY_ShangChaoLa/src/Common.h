/*--------------------------------------------------------------------*/
/*  Copyright(C) 2008-2015 by JunYu Tech. Ltd.                        */
/*  All Rights Reserved.                                              */
/*--------------------------------------------------------------------*/

#ifndef	JY_COMMON
#define	JY_COMMON

#ifdef	WIN32

	#	include	<windows.h>
	typedef	signed char		INT8;
	typedef	unsigned char	UINT8;
	typedef	signed short	INT16;
	typedef	unsigned short	UINT16;
	typedef	signed int		INT32;
	typedef	unsigned int	UINT32;
	typedef	double	FLOAT64;

#else	/* WIN32 */
#	include	"JunYuDef.h"
#endif	/* WIN32 */

#include	<math.h>
#include	<stdlib.h>
#include	<string.h>
#include	"syslib.h"	

//CONST
#ifndef	CONST
#ifdef NO_CONST
	#define	CONST
#else  
	#define	CONST	const
#endif  
#endif /* CONST */


#define EXECUTEOK 1
#define PARAMEERROR -1

#ifndef WIN32   
typedef     void                VOID;      
#endif  

#ifdef WIN32
#ifdef	_DEBUG			 
	#include	<crtdbg.h>
	#define		JY_MALLOC(size)						_malloc_dbg(size, _NORMAL_BLOCK, __FILE__, __LINE__)
	#define		JY_FREE(memblock)					_free_dbg(memblock, _NORMAL_BLOCK)
#else	/* _DEBUG */	 
	#define		JY_MALLOC(size)						malloc(size)
	#define		JY_FREE(memblock)					free(memblock)
#endif	/* _DEBUG */
#else	/* WIN32 */
	#define		JY_MALLOC(size)						malloc(size)
	#define		JY_FREE(memblock)					free(memblock)
#endif	/* WIN32 */

/* Face Area Struct definition */

typedef struct tagFACEAREA {
	POINT ptLeftTop;		/* left top */
	POINT ptRightTop;		/* right top */
	POINT ptLeftBottom;		/* left bottom */
	POINT ptRightBottom;	/* right bottom */
} FACEAREA;
typedef unsigned char	RAWIMAGE;

#define PI		3.14159265359		/* PI*/

#define	MAX(a, b) (((a) > (b)) ? (a) : (b))	 
#define	MIN(a, b) (((a) < (b)) ? (a) : (b))	 
#define ABS(a)	  (((a) > 0	)  ? (a) : (-(a)))

/*-RGB----->Gray Scale Image */
#define	RGB2G(r, g, b) (UINT8)((11L * (UINT32)(r) + ((UINT32)(g) << 4) + 5L * (UINT32)(b)) >> 5)



#endif	/* JY_COMMON */

