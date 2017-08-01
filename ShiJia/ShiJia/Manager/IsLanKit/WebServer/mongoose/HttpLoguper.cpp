
#include "HttpLoguper.h"
#if defined(ANDROID) || defined(__ANDROID__)
#include "logger/Mongoose.h"
#include "logger/Config.h"
#include "boost/asyncUdpSocket.hpp"
#include "sqlite/sqliteAdapter.hpp"
#else
#include "Mongoose.h"
#include "Config.h"
#include "asyncUdpSocket.hpp"
#include "sqliteAdapter.hpp"
#endif

#include <string>
#include <boost/lexical_cast.hpp>




HttpLoguper::HttpLoguper()
{
}

HttpLoguper::~HttpLoguper()
{
}

void HttpLoguper::ProcessDebug(struct mg_connection *conn, const struct http_message *ri, void *user_data)
{

    int nRet = 0;

    if( NULL == conn || NULL == ri || NULL == user_data )
    {
        nRet = 1;
    }
    else
    {
        HttpLoguper *pLogger = (HttpLoguper *)(user_data);
        std::string logInfo;

        if( 0 == pLogger->CombineLog(ri, logInfo) )
        {
           // nRet = ((Loguper*)pLogger)->ProcessDebug(logInfo);
        }
        else
        {
            nRet = 2;
        }
    }

    mg_printf(conn, "HTTP/1.1 200 OK\r\n\r\n%d", nRet);
}


void HttpLoguper::ProcessInfo(struct mg_connection *conn, const struct http_message *ri, void *user_data)
{
    int nRet = 0;

    if( NULL == conn || NULL == ri || NULL == user_data )
    {
        nRet = 1;
    }
    else
    {
        HttpLoguper *pLogger = (HttpLoguper *)(user_data);
        std::string logInfo;

        if( 0 == pLogger->CombineLog(ri, logInfo) ) {
            DB_insert(logInfo, 1, 0);
        }
        else
        {
            nRet = 2;
        }
    }

    mg_printf(conn, "HTTP/1.1 200 OK\r\n\r\n%d", nRet);
}


void HttpLoguper::ProcessRightNow(struct mg_connection *conn, const struct http_message *ri, void *user_data)
{
    int nRet = 0;

    if( NULL == conn || NULL == ri || NULL == user_data )
    {
        nRet = 1;
    }
    else
    {
        HttpLoguper *pLogger = (HttpLoguper *)(user_data);
        std::string logInfo;

        if( 0 == pLogger->CombineLog(ri, logInfo) )
        {

            pLogger->taskImmediately = TaskUnit();
            pLogger->taskImmediately.logNum = 1;
            pLogger->taskImmediately.loginfo = logInfo;
            pLogger->UpLog(pLogger->taskImmediately);

        }
        else
        {
            nRet = 2;
        }
    }

    mg_printf(conn, "HTTP/1.1 200 OK\r\n\r\n%d", nRet);
}


void HttpLoguper::ProcessError(struct mg_connection *conn, const struct http_message *ri, void *user_data)
{
    int nRet = 0;

    if( NULL == conn || NULL == ri || NULL == user_data )
    {
        nRet = 1;
    }
    else
    {
        HttpLoguper *pLogger = (HttpLoguper *)(user_data);
        std::string logInfo;

        if( 0 == pLogger->CombineLog(ri, logInfo) )
        {
            //nRet = ((Loguper*)pLogger)->ProcessError(logInfo);
        }
        else
        {
            nRet = 2;
        }
    }

    mg_printf(conn, "HTTP/1.1 200 OK\r\n\r\n%d", nRet);
}



#include <time.h>
#include <sys/timeb.h>

std::string getCurrentTime()
{
    char szDate[100] = {0};
    struct timeb tp;
    struct tm  tv;

    memset(szDate, 0, sizeof(szDate));
    ftime ( &tp );
    tv = *localtime ( & (tp.time) );
    sprintf(szDate,"%04d:%02d:%02d",tv.tm_year + 1900,tv.tm_mon + 1,tv.tm_mday);
    sprintf(szDate,"%s:%02d:%02d:%02d.%03d", szDate, tv.tm_hour,tv.tm_min,tv.tm_sec,tp.millitm);

    return szDate;
}

#include <boost/algorithm/string.hpp>
#include <boost/algorithm/string/trim.hpp>
#include <boost/algorithm/string/classification.hpp>
int HttpLoguper::CombineLog( const struct http_message *ri, std::string &logInfo )
{
    std::string uri;

    if( NULL == ri || ri->uri.len == 0 )
    {
        return -1;
    }

    uri = ri->uri.p;
    uri = uri.substr(strlen("/logup/"), ri->uri.len - strlen("/logup/"));

    logInfo  = getCurrentTime();

    mg_str str = mg_mk_str(uri.c_str());
    const struct mg_str *body = &str;

    char level[200] = {0};
    char module[200] = {0};
    char action[200] = {0};
    char content[1024] = {0};

    mg_get_http_var(body, "level", level, sizeof(level));
    mg_get_http_var(body, "module", module, sizeof(module));
    mg_get_http_var(body, "action", action, sizeof(action));
    mg_get_http_var(body, "content", content, sizeof(content));

    strncpy(level, body->p, 1);

    string tmp = body->p;

    size_t nPos1 = tmp.find("&", 0);
    size_t nPos = tmp.find("module=", 0);

    tmp = tmp.substr(nPos + strlen("module="), nPos1 - (nPos + strlen("module=")));


    string s = body->p;
    size_t nPos3 = s.find("&content=");
    s = s.substr(nPos3 + strlen("&content="), body->len - (nPos3 + strlen("&content=")));

    logInfo += "/";
    logInfo += level;
    logInfo += "/";
    logInfo += tmp.c_str();
    logInfo += "/";
    logInfo += action;
    logInfo += "/";
    logInfo += s.c_str();

    logInfo = boost::replace_all_copy( logInfo, "&", "%26" );
    return 0;
}

#include <boost/tokenizer.hpp>

bool HttpLoguper::UpLog( TaskUnit& dataUnit , bool isFromDB)
{
    LOGD("UpLog IN\n");
    string LogInfo="";
    LogInfo +="seqid="  + boost::lexical_cast<string>(dataUnit.m_seqId);
    LogInfo +="&curtime="+ getCurrentTime();

    LogInfo +="&deviceid=";
    LogInfo += isNullString(getenv("YST_MOBILE_imsi"));

    LogInfo +="&versionid=";
    LogInfo += isNullString(getenv("YST_MOBILE_app_version"));

    LogInfo +="&platformid=";
    string platformInfo = isNullString(getenv("YST_MOBILE_mobileType"));

    platformInfo += "-";
    platformInfo += isNullString(getenv("YST_MOBILE_sys_version"));
    LogInfo += platformInfo;


    // check if codition is valid.
    std::string info = isNullString(getenv("YST_MOBILE_UserId"));
    std::string usrId;
    std::string phoneNum;
    std::string networkStatus;

    std::vector<string> vect;
    typedef boost::tokenizer<boost::char_separator<char> >
    tokenizer;
    boost::char_separator<char> sep("|");
    tokenizer tokens(info, sep);
    for (tokenizer::iterator tok_iter = tokens.begin(); tok_iter != tokens.end(); ++tok_iter) {
        std::cout << "<" << *tok_iter << "> ";
        vect.push_back(*tok_iter);
    }

    if (vect.size() == 3) {
        usrId = vect[0];
        phoneNum = vect[1];
        networkStatus = vect[2];

        if (usrId == " ") {
            if (isFromDB == false) {
                DB_insert(dataUnit.loginfo, 0, 2);
            }
            LOGD("UpLog OUT\n");
            return false;
        }
    } else {
        LOGD("\norigin YST_MOBILE_UserId param is invalid.\n");
        LOGD("UpLog OUT\n");
        return false;
    }

    LogInfo +="&mac=";
    LogInfo += isNullString(getenv("YST_MOBILE_UserId"));

    LogInfo = boost::erase_all_copy(LogInfo, " ");

    LogInfo +="&retryseqid=";
    LogInfo += isNullString(boost::lexical_cast<std::string>(Config::Instance()->GetRetryCnt()).c_str());

    LogInfo +="&contentcount=" + boost::lexical_cast<string>(dataUnit.logNum);

    LogInfo +="&contenttext=" + dataUnit.loginfo;

    LOGD("\n-------------\nLogInfo>>%s\n",LogInfo.c_str());

    char* thost = getenv("YST_MOBILE_uploadAddr");

    string  sCode;
    string  sData = LogInfo;

    string host;
    string port;
    string path;

    string url = isNullString(thost);

    if (url.length() == 0) {
        DB_insert(dataUnit.loginfo, 0, 1);
        LOGD("UpLog OUT\n");
        return false;
    }

    int nRet = 0;

    if (ParseUri(url, host, port, path)) {
        path += "/logup.action";
        nRet = posts( host , port, path, sData, sCode);
    } else {
        path += "/logup.action";
        nRet = post(host, port, path, sData, sCode);
    }
    LOGD("\n[RET]ret=%d, code=%s\n", nRet, sCode.c_str());

    if (200 != nRet) {
        Config::Instance()->SetRetryCnt((int)dataUnit.m_seqId);
        dataUnit.m_seqId++;

        if (dataUnit.retryCnt >= 3) {
            LOGD("[ERR] uplog THREE times FAILED: %s\n", sCode.c_str());
            Config::Instance()->SetRetryCnt(0);

            if (isFromDB == false) {
                DB_insert(dataUnit.loginfo, 0, 3);
            }
            LOGD("UpLog OUT\n");
            return false;
        }
        dataUnit.retryCnt ++;
        LOGD("UpLog OUT 200 != nRet\n");
        return UpLog(dataUnit, isFromDB);
    } else {
        dataUnit.m_seqId++;
        dataUnit.logNum = 0;
        dataUnit.loginfo = "";
        Config::Instance()->setSeqId(dataUnit.m_seqId);
        Config::Instance()->SetRetryCnt(0);
    }

    LOGD("UpLog OUT\n");
    return  true;
}

#if 0
char* package_size = getenv("YST_PACKAGE_SIZE");
#endif
