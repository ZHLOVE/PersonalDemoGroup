#if !defined(HTTPLOGUPER_H_)
#define HTTPLOGUPER_H_

#include "Config.h"

class HttpLoguper
{

public:
	HttpLoguper();
	virtual ~HttpLoguper();

    static void ProcessCritical(struct mg_connection *conn, const struct http_message *ri, void *user_data);
    static void ProcessDebug(struct mg_connection *conn, const struct http_message *ri, void *user_data);
    static void ProcessError(struct mg_connection *conn, const struct http_message *ri, void *user_data);
    static void ProcessInfo(struct mg_connection *conn, const struct http_message *ri, void *user_data);
    static void ProcessRightNow(struct mg_connection *conn, const struct http_message *ri, void *user_data);
	static void ProcessExit(struct mg_connection *conn, const struct http_message *ri, void *user_data);

    TaskUnit taskImmediately;
    TaskUnit taskSequence;
    
    bool UpLog(TaskUnit& dataUnit , bool isFromDB = false);
private:
    void CollectLog( TaskUnit tmpTask );
    int CombineLog( const struct http_message *ri, std::string &logInfo );
};

#endif // !defined(HTTPLOGUPER_H_)
