/*--------------------------------------------------------------------*/
/*  Copyright(C) 2008-2012 by Wuxi JunYu Technology Ltd.              */
/*  All Rights Reserved.                                              */
/*--------------------------------------------------------------------*/

#ifndef	SYSLIB_H__
#define	SYSLIB_H__

/* Win32 for Visual C 6.0 */

#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>
#include	<memory.h>
#include	<stdlib.h>
#include	<float.h>
#include	<math.h>
#include	<time.h>

//#include	<crtdbg.h>

#ifdef	_DEBUG		 
#define		OV_MALLOC(size)		_malloc_dbg(size, _NORMAL_BLOCK, __FILE__, __LINE__)
#define		OV_FREE(memblock)	_free_dbg(memblock, _NORMAL_BLOCK)
#else				 
#define		OV_MALLOC(size)						malloc(size)
#define		OV_FREE(memblock)					free(memblock)
#endif

#define		OV_ABS(n)							abs(n)
#define		OV_ACOS(x)							acos(x)
#define		OV_ASIN(x)							asin(x)
#define		OV_ATAN(x)							atan(x)				 
#define		OV_ATAN2(y, x)						atan2(y, x)
#define		OV_ATOF(str)						atof(str)
#define		OV_ATOI(str)						atoi(str)
#define		OV_CLOCK()							clock()
#define		OV_COS(x)							cos(x)
#define		OV_EXP(x)							exp(x)
#define		OV_FABS(x)							fabs(x)
#define		OV_FLOOR(x)							floor(x)			 
#define		OV_ISNAN(x)							_isnan(x)			 
#define		OV_LOG(x)							log(x)
#define		OV_MEMCPY(dest, src, count)			memcpy(dest, src, count)
#define		OV_MEMSET(dest, c, count)			memset(dest, c, count)
#define		OV_POW(x, y)						pow(x, y)
#define		OV_QSORT(base, num, width, compare)	qsort(base, num, width, compare)
#define		OV_RAND()							rand()
#define		OV_SIN(x)							sin(x)
 
#define		OV_SPRINTF							sprintf				 
#define		OV_SQRT(x)							sqrt(x)
#define		OV_SRAND(seed)						srand(seed)
#define		OV_STRLEN(str)						strlen(str)
#define		OV_STRSTR(str1, str2)				strstr(str1, str2)
#define		OV_TANH(x)							tanh(x)

#endif	/* SYSLIB_H__ */
