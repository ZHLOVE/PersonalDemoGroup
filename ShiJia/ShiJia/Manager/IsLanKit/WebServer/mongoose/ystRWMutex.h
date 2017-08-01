/**
*\file ystRWMutex.h
* Copyright 2009 ���������ڿƼ����޹�˾, Inc.
*����ʱ�䣺2011/11/12
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

#ifndef YSTRWMUTEX_H_
#define YSTRWMUTEX_H_

#ifdef WIN32
#include <Windows.h>
#include <WinBase.h>
#else
#include <pthread.h>
#endif

class ystRWMutex
{
public:
	ystRWMutex()
	{
		///////////////////////////////////////////////////////////////////////////////////////
		// 	ѡ��Critical Section��ΪC_Lock��ʵ��, ����Ϊ���ٶ����, Mutex������1000���Ĳ��.

		// ��ʼ��
#ifdef _WIN32
		InitializeCriticalSection(&m_rCS);
		InitializeCriticalSection(&m_wCS);
		m_uReadCount = 0;
		m_hEvent	 = CreateEvent(0, TRUE, TRUE, 0);
		// if (! m_hEvent) ������ʧ��, ����ϵͳҲ�ñ�����
#else
		pthread_mutex_init(&m_wMutex, 0);
		pthread_mutex_init(&m_rMutex, 0);
		pthread_cond_init(&m_condReadCountZero, 0);
		m_uReadCount = 0;
#endif	// _WIN32
	}

	~ystRWMutex()
	{	
#ifdef _WIN32	
		CloseHandle(m_hEvent);
		DeleteCriticalSection(&m_wCS);
		DeleteCriticalSection(&m_rCS);
#else
		pthread_mutex_destroy(&m_wMutex);
		pthread_mutex_destroy(&m_rMutex);
		pthread_cond_destroy(&m_condReadCountZero);
#endif	// _WIN32
	}

	inline void rLock()
	{
		// ��������1
#ifdef _WIN32
		EnterCriticalSection(&m_wCS);	// ��ֹ��д������ͻ
		EnterCriticalSection(&m_rCS);	// ��ֹ����m_uReadCount��ͻ
		if (++m_uReadCount == 1)
			ResetEvent(m_hEvent);		// ����д����Ҫ�ȴ�, ע��ֻ�����ź�״̬�Ÿ�λ
		LeaveCriticalSection(&m_rCS);
		LeaveCriticalSection(&m_wCS);
#else
		pthread_mutex_lock(&m_wMutex);	// ��ֹ��д������ͻ
		pthread_mutex_lock(&m_rMutex);	// ��ֹ����m_uReadCount��ͻ
		++m_uReadCount;
		pthread_mutex_unlock(&m_rMutex);
		pthread_mutex_unlock(&m_wMutex);
#endif	// _WIN32
	}

	inline void rUnlock()
	{
		// ��������1, =0ʱ֪ͨд��������
#ifdef _WIN32
		EnterCriticalSection(&m_rCS);
		m_uReadCount ? (--m_uReadCount ? 0: SetEvent(m_hEvent)): 0;		// û��wLock()�ȴ�, ��ʲôҲ������
		LeaveCriticalSection(&m_rCS);
#else
		pthread_mutex_lock(&m_rMutex);
		m_uReadCount ? (--m_uReadCount ? 0: pthread_cond_signal(&m_condReadCountZero)): 0;
		pthread_mutex_unlock(&m_rMutex);
#endif	// _WIN32
	}

	inline void wLock()
	{
#ifdef _WIN32	
		EnterCriticalSection(&m_wCS);				// д����, �ܾ��ٽ��ܶ�д
		WaitForSingleObject(m_hEvent, INFINITE);	// �ȴ�����ȫ���. �ȴ��ĸ�����, ���˴�û�� 
#else
		pthread_mutex_lock(&m_wMutex);	// д����
		pthread_mutex_lock(&m_rMutex);	// �ȴ�����ȫ���

		// ������ =0, ���صȴ�. ����pthread_cond_waitû���źŶ������˳�
		if (m_uReadCount == 0) {
			pthread_mutex_unlock(&m_rMutex);
			return ;
		}
		pthread_cond_wait(&m_condReadCountZero, &m_rMutex);	// �ȴ�������==0. ע��: �ȴ��ڼ�, m_rMutex������, ���źŲ��ټ���.

		pthread_mutex_unlock(&m_rMutex);
#endif	// _WIN32
	}

	inline void wUnlock()
	{
#ifdef _WIN32
		LeaveCriticalSection(&m_wCS);
#else
		pthread_mutex_unlock(&m_wMutex);
#endif	// _WIN32
	}
private:
	unsigned long	m_uReadCount;	// �����ļ���

#ifdef _WIN32
	CRITICAL_SECTION m_rCS;			// ����
	CRITICAL_SECTION m_wCS;			// д��
	HANDLE			 m_hEvent;		// CriticalSection�����ں˶���, WaitForSingleObject���ܵȴ�. ע��Event���Զ����õġ�
#else
	pthread_mutex_t m_wMutex;		// ����ͬ����Դ
	pthread_mutex_t m_rMutex;		// ����iReadCount, m_condReadCountZero
	pthread_cond_t	m_condReadCountZero;	// ��������, ������Ϊ0��֪ͨ
#endif
};

#endif//~YSTRWMUTEX_H_