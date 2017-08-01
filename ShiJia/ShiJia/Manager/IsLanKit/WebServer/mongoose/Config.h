///////////////////////////////////////////////////////////
//  Config.h
//  Implementation of the Class Config
//  Created on:      26-����-2012 17:51:10
//  Original author: weiming
///////////////////////////////////////////////////////////

#ifndef CONFIG_H_
#define CONFIG_H_

#include <string>
#include "stdio.h"
#include "stdlib.h"
#include "ystRWMutex.h"

#if defined(ANDROID) || defined(__ANDROID__)
#include <android/log.h>
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, "HttpStatisticsNative", __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, "HttpStatisticsNative", __VA_ARGS__)
#define LOG_FLAG
#include "rapidjson/stringbuffer.h"
#else
#include "stringbuffer.h"
#endif

using namespace std;


class Config
{
public:

public:
	virtual ~Config();

	static Config * Instance();
	
    int		GetRetryCnt();
    void	SetRetryCnt(int _retryCnt);

	unsigned long		GetLogSrv( char * szLogHostRet);
	void    SetLogSrv(string szLogHostRet);
    
	void    SetLoginSrvPort(string port );
	string  GetLoginSrvPort();


    unsigned long GetLogNumber();

    int setSeqId(unsigned long long id);
    unsigned long long getSeqId();
    
private:
    Config();

private:
	static Config * m_pConfig;

	int		m_RetryCnt;
    int     m_WebSrvInterval;
	ystRWMutex m_RWMutex;
	string  m_logSrv;
	string  m_loginSrvPort;
    
    rapidjson::StringBuffer m_Buffer;

};

class TaskUnit
{
public:
    int			retryCnt;
    unsigned long long		retryseqId;
    string		loginfo;
    unsigned long		logNum;
    unsigned long	m_seqId;
    TaskUnit(unsigned long	seqId = Config::Instance()->getSeqId()): m_seqId(seqId)
    {
        retryCnt = 0;
        retryseqId = 0;
        loginfo = "";
        logNum =0;
    }
    
    TaskUnit(string info, unsigned long	num, unsigned long	seqId = Config::Instance()->getSeqId()):loginfo(info), logNum(num), m_seqId(seqId)
    {
        retryCnt = 0;
        retryseqId = 0;
    }
} ;


#ifndef LOG_FLAG
#define LOGD(...) printf(__VA_ARGS__)
#define LOGE(...) printf(__VA_ARGS__)
#endif


#ifndef isNullString
#define isNullString(x) (x == NULL) ? "": x
#endif
#endif // CONFIG_H_
