/**
*\file ystCommonThread.h
* Copyright 2009 北京易视腾科技有限公司, Inc.
*创建时间：2011/03/29
*在这里添加文件的注释
*\author 宛朝冬
*\version 1.0 
*
*/
///////////////////////////////////////////////
//Change Logo
//1.增加线程创建状态返回
//2.增加线程等待机制
//
///////////////////////////////////////////////

#ifndef YSTCOMMONTHREAD_H_
#define YSTCOMMONTHREAD_H_


#ifdef WIN32
#include <windows.h>
#include <winbase.h> //Sleep
//Windows does not define these signals
#if !defined(SIGKILL)
#define SIGKILL  9
#endif
#if !defined(SIGSTOP)
#define SIGSTOP  24
#endif
#if !defined(SIGCONT)
#define SIGCONT  26
#endif

#else  //Else !WIN32
#include <unistd.h>
#include <sys/time.h>
#endif  //End if WIN32

#include <time.h>
#include <signal.h>

#include <setjmp.h>
#include <stdlib.h>

#ifndef WIN32
#include <unistd.h>
#include <sys/time.h>
#include <pthread.h>

#ifndef _SYSV_SEMAPHORES
#include <semaphore.h>
#endif

#endif


class CYstCommonThread
{
public:
	CYstCommonThread()
	{
#ifdef WIN32
		Thread=0;
#endif
	}
	virtual ~CYstCommonThread(){};

public:
    
	int Start(bool bDetach=false)
	{
#ifdef WIN32
		//DWORD dwThreadId;
		Thread = CreateThread(
			NULL, // default security attributes
			0, // use default stack size
			RunAs, // thread function
			(void*)this, // argument to thread function
			0, // use default creation flags
			&dwThreadId); 
		return (Thread?0:-1);
#else
		pthread_attr_init(&attr);

		if(bDetach)
		{
			pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
		}
		else
		{
			pthread_attr_setdetachstate(&attr,PTHREAD_CREATE_JOINABLE);
		}

		int ret = pthread_create(&m_Tid, &attr, CYstCommonThread::RunAs, (void *)this);

		pthread_attr_destroy(&attr);

		return (!ret?0:-1);
#endif
	};
#ifdef WIN32
	static DWORD WINAPI RunAs( void *args )
#else
	static void* RunAs(void *args)
#endif
	{
		CYstCommonThread *thr = (CYstCommonThread *)args;
		// Execute the operation overrided by subclasses
		thr->Run();
		return 0;
	};
	virtual void Run()
	{

	};

	unsigned long Wait()
	{
		unsigned long m_ret;
#ifdef WIN32
		if(Thread)
			m_ret = WaitForSingleObject(Thread,INFINITE);
#else
		int ret = pthread_join(m_Tid,NULL); 
		m_ret = (unsigned long) ret;
#endif
		return  m_ret;
	};
private:
#ifdef WIN32
	yUint32 dwThreadId;
	HANDLE Thread;
#else
	pthread_t m_Tid;
	pthread_attr_t attr;
#endif
};


#endif//~YSTCOMMONTHREAD_H_
