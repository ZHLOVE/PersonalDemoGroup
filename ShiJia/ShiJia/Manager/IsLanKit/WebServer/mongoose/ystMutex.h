/**
*\file ystMutex.h
* Copyright 2009 ���������ڿƼ����޹�˾, Inc.
*����ʱ�䣺2011/03/29
*����������ļ���ע��
*\author �𳯶�
*\version 1.0 
*
*/
///////////////////////////////////////////////
//Change Logo
//
//
///////////////////////////////////////////////

#ifndef YSTMUTEX_H_
#define YSTMUTEX_H_

#ifdef WIN32
#include <Windows.h>
#include <WinBase.h>
#else
#include <pthread.h>
#endif

class ystMutex
{
public:
	ystMutex(void)
	{
#ifdef WIN32
		m_mutex = CreateMutex(NULL, FALSE, NULL);
#else
		pthread_mutex_init(&m_mutex , NULL);
#endif
	}

	~ystMutex(void)
	{
#ifdef WIN32
		CloseHandle(m_mutex);
#else
		pthread_mutex_destroy(&m_mutex);
#endif
	}

public:
	inline void acquire()
	{
#ifdef WIN32
		(void) WaitForSingleObject(m_mutex, INFINITE);
#else
		pthread_mutex_lock(&m_mutex);
#endif

	};

	inline void release()
	{
#ifdef WIN32
		(void) ReleaseMutex(m_mutex);
#else
		pthread_mutex_unlock(&m_mutex);
#endif
	};

public:
#ifdef WIN32
	HANDLE m_mutex;
#else
	pthread_mutex_t m_mutex;
#endif
};

#endif//~YSTMUTEX_H_