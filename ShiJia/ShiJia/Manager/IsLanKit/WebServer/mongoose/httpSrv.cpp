//
//  httpSrv.c
//  httpSrv
//
//  Created by Jian Huang on 8/24/16.
//  Copyright © 2016 Jian Huang. All rights reserved.
//

#include "httpSrv.h"

#if defined(ANDROID) || defined(__ANDROID__)
#include "logger/mongoose.h"
#include "logger/HttpLoguper.h"
#include "logger/Config.h"
#include "logger/ystCommonThread.h"
#else
#include "mongoose.h"
#include "HttpLoguper.h"
#include "Config.h"
#include "ystCommonThread.h"
#endif

#include <iostream>
#include <boost/lexical_cast.hpp>

static void ev_handler(struct mg_connection *nc, int ev, void *ev_data);
static void signal_handler(int sig_num);

#include <boost/bind.hpp>
#include <boost/asio.hpp>
#include <boost/asio/ssl.hpp>
#include <boost/signals2/signal.hpp>
boost::signals2::signal<void (char*, unsigned int)> g_Sig; // 多屏回调
static struct mg_serve_http_opts s_http_server_opts;
static int s_sig_num = 0;
class httpSrv;
static httpSrv* m_HttpSrv = NULL;
static const struct mg_str s_get_method = MG_MK_STR("GET");
class receiverSrv;
static receiverSrv* g_receiverSrv = NULL;
class logSrv;
static logSrv* g_logSrv = NULL;
static const short multicast_port = 5003;

using boost::asio::ip::udp;
using boost::asio::ip::tcp;

class receiver
{
public:
    receiver(boost::asio::io_service& io_service,
             const boost::asio::ip::address& listen_address,
             const boost::asio::ip::address& multicast_address)
    : socket_(io_service),
    timer_(io_service)
    {
        LOGD("receiver IN\n");
        // Create the socket so that multiple may be bound to the same address.
        boost::asio::ip::udp::endpoint listen_endpoint(listen_address, multicast_port);
        socket_.open(listen_endpoint.protocol());
        socket_.set_option(boost::asio::ip::udp::socket::reuse_address(true));
        boost::system::error_code ec;
        socket_.bind(listen_endpoint, ec);
        if (ec != 0) {
            //LOGD("\nERR bind %s\n", boost::system::system_error(ec).what());
            LOGD("ERR receiver OUT\n");
            return;
        }
        // Join the multicast group.
        socket_.set_option(
                           boost::asio::ip::multicast::join_group(multicast_address));
        
        socket_.async_receive_from(
                                   boost::asio::buffer(data_, max_length), sender_endpoint_,
                                   boost::bind(&receiver::handle_receive_from, this,
                                               boost::asio::placeholders::error,
                                               boost::asio::placeholders::bytes_transferred));
        LOGD("receiver OUT\n");
    }
    
    void handle_receive_from(const boost::system::error_code& error,
                             size_t bytes_recvd)
    {
        if (!error)
        {
            g_Sig(data_, (unsigned int)bytes_recvd);
            //address
            std::cout << sender_endpoint_.address().to_string()<< ", bytes count: " << bytes_recvd<< std::endl;
            
            timer_.expires_from_now(boost::posix_time::seconds(10));
            timer_.async_wait(
                              boost::bind(&receiver::handle_timeout, this,
                                          boost::asio::placeholders::error));
            
            
        }
    }
    
    void handle_timeout(const boost::system::error_code& error)
    {
        socket_.async_receive_from(
                                   boost::asio::buffer(data_, max_length), sender_endpoint_,
                                   boost::bind(&receiver::handle_receive_from, this,
                                               boost::asio::placeholders::error,
                                               boost::asio::placeholders::bytes_transferred));
        
    }
private:
    boost::asio::ip::udp::socket socket_;
    boost::asio::ip::udp::endpoint sender_endpoint_;
    enum { max_length = 1024 };
    char data_[max_length];
    boost::asio::deadline_timer timer_;
};

class receiverSrv: public CYstCommonThread
{
    boost::asio::io_service io_service;
protected:
    virtual void Run()
    {
        try
        {
            receiver r(io_service,
                       boost::asio::ip::address::from_string("0.0.0.0"),
                       boost::asio::ip::address::from_string("239.255.0.1"));
            io_service.run();
        }
        catch (std::exception& e)
        {
            std::cerr << "Exception: " << e.what() << "\n";
        }
    }
public:
    receiverSrv() {
    }
    
    virtual ~receiverSrv(){
        io_service.stop();
        Wait();
    }
    
};

#include <boost/tuple/tuple.hpp>
std::vector<boost::tuple<unsigned long, int, std::string, int> >& DB_select();
void DB_deleteItem(unsigned long index);

class logCase {
    boost::asio::deadline_timer timer_;
    HttpLoguper* weakRefLoguper;
    unsigned int interval;
public:
    logCase(boost::asio::io_service& io_service, HttpLoguper* loguper):timer_(io_service), weakRefLoguper(loguper)
    {
        char* uploadInterval = getenv("YST_MOBILE_uploadInterval");
        interval = boost::lexical_cast<unsigned int>(uploadInterval);
        timer_.expires_from_now(boost::posix_time::seconds(interval));
        timer_.async_wait(boost::bind(&logCase::handle_timeout, this,
                                      boost::asio::placeholders::error));
    }
    void handle_timeout(const boost::system::error_code& error) {
        
        //std::cout << "################################################" << std::endl;
        std::vector<boost::tuple<unsigned long, int, std::string, int> > &v = DB_select();
        if (weakRefLoguper) {
            weakRefLoguper->taskSequence = TaskUnit();
        }
        for (std::vector<boost::tuple<unsigned long, int, std::string, int> >::iterator iter = v.begin(); iter != v.end(); iter ++) {
            if (weakRefLoguper) {
                
                weakRefLoguper->taskSequence.logNum = v.size();
                weakRefLoguper->taskSequence.loginfo += boost::get<2>(*iter);
                weakRefLoguper->taskSequence.loginfo += "<yst>";
            }
        }
        bool isSuccess = false;
        
        if (v.size() > 0) {
            weakRefLoguper->taskSequence.loginfo.erase(weakRefLoguper->taskSequence.loginfo.length() - strlen("<yst>"));
            isSuccess = weakRefLoguper->UpLog(weakRefLoguper->taskSequence, true);
        }
        
        if (isSuccess) {
            // uploaded data, delete DB data.
            for (std::vector<boost::tuple<unsigned long, int, std::string, int> >::iterator iter = v.begin(); iter != v.end(); iter ++) {
                DB_deleteItem(boost::get<0>(*iter));
            }
            
        } else {
            // network may be traffical or no DB logs.
            
        }

        timer_.expires_from_now(boost::posix_time::seconds(interval));
        timer_.async_wait(boost::bind(&logCase::handle_timeout, this,
                                      boost::asio::placeholders::error));
    }
    
};

class logSrv:public CYstCommonThread
{
    boost::asio::io_service io_service;
protected:
    virtual void Run()
    {
        try
        {
            logCase caseInst(io_service, m_HttpLoguper);
            io_service.run();
        }
        catch (std::exception& e)
        {
            std::cerr << "Exception: " << e.what() << "\n";
        }
    }
public:
    HttpLoguper *m_HttpLoguper;
    logSrv() {
        m_HttpLoguper = new HttpLoguper();
    }
    
    virtual ~logSrv(){
        io_service.stop();
        Wait();
        
        if (m_HttpLoguper!=NULL) {
            delete m_HttpLoguper;
            m_HttpLoguper = NULL;
        }
    }
};


class httpSrv :public CYstCommonThread
{
    struct mg_mgr mgr;
    struct mg_connection *nc;
   
public:
    
    bool Init() {
        try {
            s_sig_num = 0;
            mg_mgr_init(&mgr, NULL);
            nc = mg_bind(&mgr,  Config::Instance()->GetLoginSrvPort().c_str(), ev_handler);
            if (nc == NULL) {
                int port = atoi(Config::Instance()->GetLoginSrvPort().c_str());
                port ++;
                char sPort[64] = {0};
                sprintf(sPort, "%d", port);
                Config::Instance()->SetLoginSrvPort(sPort);
                return false;
            }
            mg_set_protocol_http_websocket(nc);

            signal(SIGINT, signal_handler);
            signal(SIGTERM, signal_handler);
   
            /* Run event loop until signal is received */
            LOGD("\nStarting RESTful server on port %s\n", Config::Instance()->GetLoginSrvPort().c_str());
        } catch (...) {
            LOGD("\nStart RESTful server FAILED, port %s has been occupied.", Config::Instance()->GetLoginSrvPort().c_str());
            return false;
        }

        return true;
    }

    httpSrv(const char* webRoot) {
        /* Open listening socket */
        s_http_server_opts.document_root = webRoot;
        mgr.hexdump_file = webRoot;
    }

    virtual ~httpSrv(){
        /* Cleanup */
        LOGD("~httpSrv IN\n");
        Close();
 
        LOGD("Exiting on signal %d\n", s_sig_num);
        LOGD("~httpSrv OUT\n");
    }

    virtual void Run()
    {
        while (s_sig_num == 0) {
            mg_mgr_poll(&mgr, 1000);
            
        }
    }
private:
    void Close()
    {
        s_sig_num = -1;
        Wait();
    }
};

#if defined(ANDROID) || defined(__ANDROID__)
#include "rapidjson/rapidjson.h"
#include "rapidjson/document.h"

#else
#include "rapidjson.h"
#include "document.h"
#include "stringbuffer.h"
#include "writer.h"
#endif

/*启动http service*/
void startHttpService(const char* json)
{
    LOGD("startHttpService IN");
    using rapidjson::Document;
    Document doc;
    doc.Parse<0>(json);
    if (doc.HasParseError()) {
        rapidjson::ParseErrorCode code = doc.GetParseError();
        LOGE("err %d", code);
        return;
    }

    // use values in parse result.
    using rapidjson::Value;
    Value & v1 = doc["webRoot"];
    if (v1.IsString()) {
        setenv("YST_SERVER_webRoot", v1.GetString(), 1);
        
        string filePath = v1.GetString();
        filePath += "/ysten.db";
        setenv("YST_DATABASE_PATH", filePath.c_str(), 1);
    }

    Value & v2 = doc["host"];
    if (v2.IsString()) {
        setenv("YST_SERVER_host", v2.GetString(), 1);
    }

    Value & v3 = doc["port"];
    if (v3.IsString()) {
        setenv("YST_SERVER_port", v3.GetString(), 1);
    }

    Value & v4 = doc["mobileType"];
    if (v4.IsString()) {
        setenv("YST_MOBILE_mobileType", v4.GetString(), 1);
    }

    bool isValidUsrId = true;
    Value & v5 = doc["mobileUserId"];
    if (v5.IsString()) {
        string uid = v5.GetString();
        if (uid.length() == 0) {
            isValidUsrId = false;
        }
        setenv("YST_MOBILE_UserId", v5.GetString(), 1);
    }

    Value & v6 = doc["app_version"];
    if (v6.IsString()) {
        setenv("YST_MOBILE_app_version", v6.GetString(), 1);
    }

    Value & v7 = doc["sys_version"];
    if (v7.IsString()) {
        setenv("YST_MOBILE_sys_version", v7.GetString(), 1);
    }

    Value & v8 = doc["imsi"];
    if (v8.IsString()) {
        setenv("YST_MOBILE_imsi", v8.GetString(), 1);
    }

    Value & v9 = doc["network"];
    if (v9.IsString()) {
        setenv("YST_MOBILE_network", v9.GetString(), 1);
    }

    Value & v10 = doc["packageCount"];
    if (v10.IsString()) {
        setenv("YST_PACKAGE_SIZE", v10.GetString(), 1);
    }

    bool isAddrValid = false;
    Value & v11 = doc["uploadAddr"];
    if (v11.IsString()) {
        string addr = v11.GetString();
        if (addr.length() == 0) {
            isAddrValid = false;
        }
        setenv("YST_MOBILE_uploadAddr", v11.GetString(), 1);
    }

    //uploadInterval
    Value & v12 = doc["uploadInterval"];
    if (v12.IsString()) {
        string interval = v12.GetString();
        if (interval.length() == 0) {
            LOGE("\nuploadInterval parrm ERR!!! service launch failed.\n");
            LOGD("startHttpService OUT\n");
            return;
        }
        
        setenv("YST_MOBILE_uploadInterval", v12.GetString(), 1);
    }

    Config::Instance()->SetLoginSrvPort(getenv("YST_SERVER_port"));
    Config::Instance()->SetLogSrv(getenv("YST_SERVER_host"));

    if (m_HttpSrv == NULL) {
        m_HttpSrv =  new httpSrv(getenv("YST_SERVER_webRoot"));
        bool ret = m_HttpSrv->Init();
        while (false == ret) {
            ret = m_HttpSrv->Init();
        }
        m_HttpSrv->Start();
    }
    
    if (g_logSrv == NULL) {
        g_logSrv = new logSrv();
        g_logSrv ->Start();
    }
    LOGD("startHttpService OUT\n");
}

/*停止http service*/
void stopHttpService()
{
    LOGD("stopHttpService IN\n");
    if (m_HttpSrv != NULL) {
        delete m_HttpSrv;
        m_HttpSrv = NULL;
    }
    if (g_logSrv != NULL) {
        delete g_logSrv;
        g_logSrv = NULL;
    }
    LOGD("stopHttpService OUT\n");
}

#include <boost/tokenizer.hpp>
bool updateSrvInfo(const char* value, SrvInfoType type)
{
    LOGD("updateSrvInfo IN\n");
    
    if (value == NULL) {
        LOGD("updateSrvInfo OUT\n");
        return false;
    }
    std::string info = isNullString(getenv("YST_MOBILE_UserId"));
    
    std::vector<string> vect;
    typedef boost::tokenizer<boost::char_separator<char> >
    tokenizer;
    boost::char_separator<char> sep("|");
    tokenizer tokens(info, sep);
    for (tokenizer::iterator tok_iter = tokens.begin(); tok_iter != tokens.end(); ++tok_iter) {
        std::cout << "<" << *tok_iter << "> ";
        vect.push_back(*tok_iter);
    }
    
    std::string usrId;
    std::string phoneNum;
    std::string networkStatus;
    std::string uploadAddr;
    
    switch (vect.size()) {
        case 1:
        {
            LOGD("\norigin YST_MOBILE_UserId param is invalid.\n");
            return false;
        }
            break;
        case 2:
        {
            LOGD("\norigin YST_MOBILE_UserId param is invalid.\n");
            return false;
        }
            break;
        case 3:
        {
            usrId = vect[0];
            phoneNum = vect[1];
            networkStatus = vect[2];
        }
            break;
            
        default:
            break;
    }

    uploadAddr = getenv("YST_MOBILE_uploadAddr");
    
    
    switch(type) {
        case _UsrId:
        {
            usrId = value;
            unsigned long seqId = Config::Instance()->getSeqId();
            unsigned long usrId = boost::lexical_cast<unsigned int>(value);
            if (usrId > seqId) {
                Config::Instance()->setSeqId(usrId + seqId);
            }
        }
            break;
        case _PhoneNum:
        {
            phoneNum = value;
        }
            break;
        case _NetStatus:
        {
            networkStatus = value;
        }
            break;
        case _UploadAddr:{
            uploadAddr = value;
            
            setenv("YST_MOBILE_uploadAddr", uploadAddr.c_str(), 1);
            return true;
        }
            break;
    }
    
    std::string mobileStr = usrId + "|" + phoneNum + "|" + networkStatus;
    setenv("YST_MOBILE_UserId", mobileStr.c_str(), 1);
    LOGD("updateSrvInfo OUT\n");
    return true;
    
}

int getHttpSrvPort()
{
    const char* str = Config::Instance()->GetLoginSrvPort().c_str();
    return atoi(str);
}

int sendUdp(void* data, const char* host, int port)
{
    LOGD("sendUdp IN\n");
    std::string strData = (char* )data;
    boost::asio::io_service io_service;
    boost::asio::ip::udp::endpoint endpoint(boost::asio::ip::address::from_string(host), port );
    boost::asio::ip::udp::socket socket(io_service, endpoint.protocol());
    size_t ret = 0;
    ret = socket.send_to(boost::asio::buffer(strData), endpoint);
    io_service.poll();
    LOGD("sendUdp OUT size :%zu\n", ret);
    return ret;
}

void startMonitoring(CallBack cb)
{
    LOGD("startmonitoring IN\n");
    
    if (g_receiverSrv == NULL) {
        if (cb != NULL) {
            g_Sig.disconnect_all_slots();
            g_Sig.connect(cb);
        }

        g_receiverSrv = new receiverSrv();

        if (g_receiverSrv && g_Sig.num_slots() != 0) {
            g_receiverSrv->Start();
        }
    }
    LOGD("startmonitoring OUT\n");
}

void stopMonitoring()
{
    LOGD("stopMonitoring IN\n");
    if (g_receiverSrv != NULL) {
        delete g_receiverSrv;
        g_receiverSrv = NULL;
        g_Sig.disconnect_all_slots();
    }
    LOGD("stopMonitoring OUT\n");
}

static void signal_handler(int sig_num) {
    signal(sig_num, signal_handler);
    s_sig_num = sig_num;
}

static int has_prefix(const struct mg_str *uri, const struct mg_str *prefix) {
    return uri->len >= prefix->len && memcmp(uri->p, prefix->p, prefix->len) == 0;
}

static int is_equal(const struct mg_str *s1, const struct mg_str *s2) {
    return s1->len == s2->len && memcmp(s1->p, s2->p, s2->len) == 0;
}

static void ev_handler(struct mg_connection *nc, int ev, void *ev_data) {
    static const struct mg_str api_prefix = MG_MK_STR("/logup/0");
    static const struct mg_str api_prefix1 = MG_MK_STR("/logup/1");
    static const struct mg_str api_prefix2 = MG_MK_STR("/logup/2");
    static const struct mg_str api_prefix3 = MG_MK_STR("/logup/3");
    
    static const struct mg_str api_prefix6 = MG_MK_STR("/boot");
    
    struct http_message *hm = (struct http_message *) ev_data;
    struct mg_str key;
    
    switch (ev) {
        case MG_EV_HTTP_REQUEST: {
            if (has_prefix(&hm->uri, &api_prefix)) {
                key.p = hm->uri.p + api_prefix.len;
                key.len = hm->uri.len - api_prefix.len;
                if (is_equal(&hm->method, &s_get_method)) {
                    if (g_logSrv) {
                        HttpLoguper::ProcessDebug(nc, hm, g_logSrv->m_HttpLoguper);
                        
                        mg_printf(nc, "%s",
                                  "HTTP/1.0 200\r\n"
                                  "Content-Length: 0\r\n\r\n");
                    }
                    
                }
            } else if (has_prefix(&hm->uri, &api_prefix1)) {
                if (g_logSrv) {
                    LOGD("\n DELAY log is come in.\n");
                    HttpLoguper::ProcessInfo(nc, hm, g_logSrv->m_HttpLoguper);
                    mg_printf(nc, "%s",
                              "HTTP/1.0 200\r\n"
                              "Content-Length: 0\r\n\r\n");
                    
                }
            } else if (has_prefix(&hm->uri, &api_prefix2)) {
                if (g_logSrv) {
                    LOGD("\n EMERGENT log is come in.\n");
                    HttpLoguper::ProcessRightNow(nc, hm, g_logSrv->m_HttpLoguper);
                    
                    mg_printf(nc, "%s",
                              "HTTP/1.0 200\r\n"
                              "Content-Length: 0\r\n\r\n");
                    
                }
            } else if (has_prefix(&hm->uri, &api_prefix3)) {
                if (g_logSrv) {
                    HttpLoguper::ProcessError(nc, hm, g_logSrv->m_HttpLoguper);
                    mg_printf(nc, "%s",
                              "HTTP/1.0 200\r\n"
                              "Content-Length: 0\r\n\r\n");
                    
                }
            } else if (has_prefix(&hm->uri, &api_prefix6)) {
                mg_printf(nc, "%s%s",
                          "HTTP/1.0 200\r\n"
                          "Content-Length: 2\r\n\r\n"
                          ,hm->body.p);
                
            }
            
            {
                mg_serve_http(nc, hm, s_http_server_opts); /* Serve static content */
            }
        }
            break;
        default:
            break;
    }
}

#if 0
#if defined(ANDROID) || defined(__ANDROID__)
#include "dlna/MediaRendererTest.hpp"
#else
#include "MediaRendererTest.hpp"
#endif

class postionTrack
{
    boost::asio::deadline_timer timer_;
    std::string uuid;
public:
    postionTrack(boost::asio::io_service& io_service,std::string uuidPar):timer_(io_service), uuid(uuidPar)
    {
        timer_.expires_from_now(boost::posix_time::seconds(1));
        timer_.async_wait(boost::bind(&postionTrack::handle_timeout, this,
                                      boost::asio::placeholders::error));
    }
    void handle_timeout(const boost::system::error_code& error) {
        
        GetDMRPlaybackTime(uuid.c_str());
        timer_.expires_from_now(boost::posix_time::seconds(1));
        timer_.async_wait(boost::bind(&postionTrack::handle_timeout, this,
                                      boost::asio::placeholders::error));
        
    }

};

class dlnaSrv :public CYstCommonThread {
    boost::asio::io_service io_service;
    std::string uuid;
public:
    virtual void Run()
    {
        postionTrack track(io_service, uuid);
        io_service.run();
    }
    
    dlnaSrv(std::string uuidPar):uuid(uuidPar) {
    
    }
    ~dlnaSrv() {
        io_service.stop();
        Wait();
    }
};


boost::signals2::signal<void (const char*, const char*, bool)> g_device_signal;
boost::signals2::signal<void (int status, const char* reason)> g_result_signal;
boost::signals2::signal<void (int status, const char* reason)> g_action_signal;

static dlnaSrv* dlnaPosSrv = NULL;

void startDlnaService(dlnaDevicesCallback cb)
{
    if (cb != NULL) {
        g_device_signal.connect(cb);
    }
    startUpnp();
}
void stopDlnaService()
{
    g_device_signal.disconnect_all_slots();
    stopUpnp();
}

void broadcast2Tv(const char* url, resultCallBack cb, const char* uuid)
{
    if (cb == NULL || url == NULL || uuid == NULL) {
        g_result_signal(-1, "param error.");
        g_result_signal.disconnect_all_slots();
    } else {
        g_result_signal.connect(cb);
        SetAVTransportURI(uuid, url);
    }
}

void doAction(ActionType type, resultCallBack cb, const char* uuid, const char* pos)
{
    g_action_signal.disconnect_all_slots();
    if (cb != NULL) {
        g_action_signal.connect(cb);
    }
    
    switch (type) {
        case _Pause:
        {
            Pause();
        }
            break;
        case _Resume:
        {
            Play();
        }
            break;
        case _Stop:
        {
            Stop();
        }
            break;
        case _Seek:
        {
            Seek(pos);
        }
            break;

            
        case _GetTvStatus:
        {
            GetTransportInfo(uuid);
        }
            break;
        case _positionCheck:
        {
            if (NULL == dlnaPosSrv) {
                dlnaPosSrv = new dlnaSrv(uuid);
                dlnaPosSrv->Start();
            }
            
        }
            break;
        default:
            break;
    }

}
#endif
