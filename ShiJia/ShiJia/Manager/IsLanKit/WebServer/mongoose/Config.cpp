///////////////////////////////////////////////////////////
//  Config.cpp
//  Implementation of the Class Config
//  Created on:      26-∆ﬂ‘¬-2012 17:51:10
//  Original author: weiming
///////////////////////////////////////////////////////////

#include <string.h>
#if defined(ANDROID) || defined(__ANDROID__)
#include "rapidjson/rapidjson.h"
#include "rapidjson/stringbuffer.h"
#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/filewritestream.h"
#include "rapidjson/filereadstream.h"
#else
#include "rapidjson.h"
#include "stringbuffer.h"
#include "document.h"
#include "writer.h"
#include "filewritestream.h"
#include "filereadstream.h"
#endif

#include "Config.h"
#include <boost/lexical_cast.hpp>

static string	CD_PORT_CDN		 = "8090";

Config * Config::m_pConfig = NULL;
Config::Config()
{
	m_RetryCnt = 0;
	m_loginSrvPort = CD_PORT_CDN;
	m_logSrv = "";
}

Config::~Config()
{

}

Config * Config::Instance()
{
	if (m_pConfig==NULL)
	{
		m_pConfig = new Config();
	}
	return  m_pConfig;
}

int Config::GetRetryCnt()
{
	int tRetryCnt=0;
	m_RWMutex.rLock();
	tRetryCnt = m_RetryCnt;
	m_RWMutex.rUnlock();
	return tRetryCnt;
}

void Config::SetRetryCnt(int _retryCnt)
{
	m_RWMutex.wLock();
	m_RetryCnt = _retryCnt;
	m_RWMutex.wUnlock();
}


unsigned long Config::GetLogSrv( char * szLogHostRet)
{
	if (!m_logSrv.empty())
	{
		strcpy(szLogHostRet,m_logSrv.c_str());
		return m_logSrv.size();
	}
	return -1;
}


void Config::SetLogSrv( string szLogHostRet )
{
	m_logSrv = szLogHostRet;
}

void Config::SetLoginSrvPort( string port )
{
	m_loginSrvPort = port;
}

std::string Config::GetLoginSrvPort()
{
	return m_loginSrvPort;
}

int Config::setSeqId(unsigned long long id) {
    rapidjson::Document document;
    rapidjson::Document::AllocatorType& allocator = document.GetAllocator();
    rapidjson::Value root(rapidjson::kObjectType);
    
    rapidjson::Value seqId(rapidjson::kStringType);
    
    seqId.SetUint64(id);
    
    root.AddMember("seqId", seqId, allocator);
    string webRoot = getenv("YST_SERVER_webRoot");
    webRoot += "config.json";
    FILE* fp = fopen(webRoot.c_str(), "w"); // 非 Windows 平台使用 "w"
    if (fp == NULL) {
        return -1;
    }
    
    char writeBuffer[1024] = {0};
    rapidjson::FileWriteStream os(fp, writeBuffer, sizeof(writeBuffer));
    rapidjson::Writer<rapidjson::FileWriteStream> writer(os);
    root.Accept(writer);
    fclose(fp);
    
    return 0;
}

#include <time.h>
#include <sys/timeb.h>
#include <boost/xpressive/xpressive.hpp>
using namespace boost;
using namespace xpressive;

unsigned long long Config::getSeqId()
{
    string webRoot = getenv("YST_SERVER_webRoot");
    webRoot += "config.json";
    FILE* fp = fopen(webRoot.c_str(), "r"); // 非 Windows 平台使用 "r"
    if (fp == NULL) {
        
        struct timeb tp;
        struct tm  tv;
        
        string usrId = getenv("YST_MOBILE_UserId");
        
        sregex re = +_d; // find a date
        string value;
        
        sregex_token_iterator begin( usrId.begin(), usrId.end(), re),end;
        if (begin != end) {
            value = *begin;
        } else {
            value = "0";
        }
        
        unsigned long long valuel = boost::lexical_cast<unsigned long long>(value);
       
        ftime ( &tp );
        tv = *localtime ( & (tp.time) );
        
        unsigned long year_l = 0;
        char szYear[10] = {0};
        sprintf(szYear,"%04d",tv.tm_year + 1900);
        year_l = boost::lexical_cast<unsigned long>(szYear);
        
        unsigned long month_l = 0;
        char szMonth[10] = {0};
        sprintf(szMonth,"%02d",tv.tm_mon + 1);
        month_l = boost::lexical_cast<unsigned long>(szMonth);
        
        
        unsigned long days_l = 0;
        char szDay[10] = {0};
        sprintf(szDay,"%02d",tv.tm_mday);
        days_l = boost::lexical_cast<unsigned long>(szDay);
        
        
        unsigned long hours_l = 0;
        char szHour[10] = {0};
        sprintf(szHour,"%02d",tv.tm_hour);
        hours_l = boost::lexical_cast<unsigned long>(szHour);
        
        unsigned long min_l = 0;
        char szMin[10] = {0};
        sprintf(szMin,"%02d",tv.tm_min);
        min_l = boost::lexical_cast<unsigned long>(szMin);

        unsigned long sec_l = 0;
        char szSec[10] = {0};
        sprintf(szSec,"%02d",tv.tm_sec);
        sec_l = boost::lexical_cast<unsigned long>(szSec);
        
        unsigned long millitm_l = 0;
        char szMillitm[10] = {0};
        sprintf(szMillitm,"%03d",tp.millitm);
        millitm_l = boost::lexical_cast<unsigned long>(szMillitm);
        
        valuel += year_l + month_l + days_l + hours_l + min_l  + sec_l + millitm_l ;
  
        LOGE("\nseqid: %llu\n", valuel);
        if (0 == setSeqId(valuel)){
            return getSeqId();
        }
        return 0;
    }
    
    char readBuffer[1024] = {0};
    fscanf(fp,"%s",readBuffer);
    
    rapidjson::Document root;
    root.Parse<0>(readBuffer);
    
    if (root.HasParseError()) {
        rapidjson::ParseErrorCode code = root.GetParseError();
        printf("err %d", code);
        return 0;
    }

    rapidjson::Value & v1 = root["seqId"];
    return v1.GetUint64();
}

