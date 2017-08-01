/**
*\file ystRWMutex.h
* Copyright 2009 北京易视腾科技有限公司, Inc.
*创建时间：2011/11/12
*在这里添加文件的注释
*\author 宛朝冬
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
		// 	选用Critical Section作为C_Lock的实现, 是因为其速度最快, Mutex与其有1000倍的差距.

		// 初始化
#ifdef _WIN32
		InitializeCriticalSection(&m_rCS);
		InitializeCriticalSection(&m_wCS);
		m_uReadCount = 0;
		m_hEvent	 = CreateEvent(0, TRUE, TRUE, 0);
		// if (! m_hEvent) 这样都失败, 估计系统也该崩溃了
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
		// 读计数加1
#ifdef _WIN32
		EnterCriticalSection(&m_wCS);	// 防止与写操作冲突
		EnterCriticalSection(&m_rCS);	// 防止访问m_uReadCount冲突
		if (++m_uReadCount == 1)
			ResetEvent(m_hEvent);		// 随后的写操作要等待, 注意只在有信号状态才复位
		LeaveCriticalSection(&m_rCS);
		LeaveCriticalSection(&m_wCS);
#else
		pthread_mutex_lock(&m_wMutex);	// 防止与写操作冲突
		pthread_mutex_lock(&m_rMutex);	// 防止访问m_uReadCount冲突
		++m_uReadCount;
		pthread_mutex_unlock(&m_rMutex);
		pthread_mutex_unlock(&m_wMutex);
#endif	// _WIN32
	}

	inline void rUnlock()
	{
		// 读计数减1, =0时通知写操作进行
#ifdef _WIN32
		EnterCriticalSection(&m_rCS);
		m_uReadCount ? (--m_uReadCount ? 0: SetEvent(m_hEvent)): 0;		// 没有wLock()等待, 则什么也不发生
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
		EnterCriticalSection(&m_wCS);				// 写加锁, 拒绝再接受读写
		WaitForSingleObject(m_hEvent, INFINITE);	// 等待读锁全解除. 等待的副作用, 但此处没有 
#else
		pthread_mutex_lock(&m_wMutex);	// 写加锁
		pthread_mutex_lock(&m_rMutex);	// 等待读锁全解除

		// 读计数 =0, 不必等待. 避免pthread_cond_wait没有信号而不能退出
		if (m_uReadCount == 0) {
			pthread_mutex_unlock(&m_rMutex);
			return ;
		}
		pthread_cond_wait(&m_condReadCountZero, &m_rMutex);	// 等待读计数==0. 注意: 等待期间, m_rMutex被解锁, 有信号才再加锁.

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
	unsigned long	m_uReadCount;	// 读锁的计数

#ifdef _WIN32
	CRITICAL_SECTION m_rCS;			// 读锁
	CRITICAL_SECTION m_wCS;			// 写锁
	HANDLE			 m_hEvent;		// CriticalSection不是内核对象, WaitForSingleObject不能等待. 注意Event是自动重置的。
#else
	pthread_mutex_t m_wMutex;		// 锁定同步资源
	pthread_mutex_t m_rMutex;		// 锁定iReadCount, m_condReadCountZero
	pthread_cond_t	m_condReadCountZero;	// 条件变量, 读计数为0的通知
#endif
};

#endif//~YSTRWMUTEX_H_