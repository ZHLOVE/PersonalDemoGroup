/*------------------------------------------------------------------------*/
/*  Copyright(C) 2008-2012 by Wuxi JunYu Technology Ltd.                  */
/*  All Rights Reserved.                                                  */
/*------------------------------------------------------------------------*/


#ifndef SS_EDGE
#define SS_EDGE
#include "JY_Head.h"
#include "Image.h"
#include "JY_SmartSkinSDK.h"
#include "SS_ImageForm.h"

int MakeEdgeMask
(
 RAWIMAGE	*pIn,
 INT32		nWidth,
 INT32		nHeight,
 FACEAREA	*pFaceArea,
 INT32		nFaceNum,
 int			per,
 INT32		nOutWidth,
 INT32		nOutHeight,
 RAWIMAGE	**pOut
 );

#endif
