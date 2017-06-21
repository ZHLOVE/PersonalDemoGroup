#ifndef CCL_H
#define CCL_H

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include "Common.h"

////////////////////////////////////////////////////////////////////////////
//#ifndef _WINDOWS_
//typedef unsigned char       BYTE;
//typedef struct tagPOINT {
//	long x;
//	long y;
//} POINT;
//#endif
////////////////////////////////////////////////////////////////////////////
typedef struct _vector_t
{
	void *data;
	int nsize;
	int nalloc;
	int typesize;
}vector_t;

void vector_init(vector_t* pthis,int typesize);
void vector_free(vector_t* pthis);
void vector_pushback(vector_t* pthis,void *pushone);
void vector_popback(vector_t* pthis);
void* vector_at(vector_t* pthis,int i);

//////////////////////////////////////////////////////////////////////////
typedef struct _KNode
{
	struct _KNode* ngNext;
	struct _KNode* sgNext;
	int data;
}KNode;

typedef struct _KBox
{
	POINT topLeft;
	POINT bottomRight;
	int ID;
}KBox;

//////////////////////////////////////////////////////////////////////////
typedef struct _KLinkedList
{
	KNode * header;
	int  regionCount;
}KLinkedList;

void KLinkedList_printTable(KLinkedList* pthis);
void KLinkedList_Search(KLinkedList* pthis,int data, KNode** p);
void KLinkedList_InsertData1(KLinkedList* pthis,int data);
void KLinkedList_InsertData2(KLinkedList* pthis,int addGroup,int searchGroup);

void KLinkedList_init(KLinkedList* pthis);
void KLinkedList_free(KLinkedList* pthis);



//////////////////////////////////////////////////////////////////////////

typedef struct _KCCL
{
	int        m_ObjectNumber;
	int*       m_MaskArray;
	
	//	int        m_nAreaThreshold;
	int        m_height;
	int        m_width;
	
	vector_t   m_Components;
}KCCL;


void KCCL_init(KCCL* pthis);
void KCCL_free(KCCL* pthis);


//��ֵ��
void KCCL_Binarize(KCCL* pthis);
void KCCL_Clear(KCCL* pthis);

void KCCL_SetMask(KCCL* pthis,BYTE* mask, int width, int height);

//ȥ��
//void KCCL_InitConfig(KCCL* pthis, int AreaThreshold );
void KCCL_Process(KCCL* pthis,int AreaThreshold );

//��ý��
int* KCCL_GetOutput(KCCL* pthis);



//////////////////////////////////////////////////////////////////////////

#endif
