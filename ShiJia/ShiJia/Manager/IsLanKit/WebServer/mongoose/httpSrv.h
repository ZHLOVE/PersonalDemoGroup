//
//  httpSrv.h
//  httpSrv
//
//  Created by Jian Huang on 8/24/16.
//  Copyright © 2016 Jian Huang. All rights reserved.
//

#ifndef httpSrv_h
#define httpSrv_h
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
    
    /*
     
     "{
     \"webRoot\":\"/private/var/mobile/Containers/Data/Application/121A537E-1A2A-4D03-8489-4B52142AC05D/tmp/\",
     \"host\":\"http://172.16.15.172\",
     \"port\":\"8090\",
     \"mobileType\":\"iPhone 6s Plus\",
     \"mobileUUID\":\"F18NNB2WG5MN\",
     \"app_version\":\"1.2.1\",
     \"sys_version\":\"10.0\",
     \"imis\":\"XXXXXXX\",
     \"network\":\"4G\",
     }"
     
     */
    /*启动http service*/
    /*
     CallBack 组播回调函数
     */
    typedef void (*CallBack)(char* , unsigned int);
    
    void startHttpService(const char* json);
    /*停止http service*/
    void stopHttpService();
    
    
    int sendUdp(void* data, const char* host, int port);
    
    // 获取端口号
    int getHttpSrvPort();
    
    
    typedef enum  {
        _UsrId = 0,
        _PhoneNum,
        _NetStatus,
        _UploadAddr
    } SrvInfoType;
    
    bool updateSrvInfo(const char* value, SrvInfoType type);
    
    void startMonitoring(CallBack cb);
    void stopMonitoring();

#if 0
    // dlna
    typedef enum  {
        _Pause = 0,
        _Resume,
        _Stop,

        
        _Seek,
        _GetTvStatus,
        _positionCheck,
    }ActionType;
    
    typedef void (*dlnaDevicesCallback)(const char* uuid, const char* deviceName, bool isOffline);
    void startDlnaService(dlnaDevicesCallback cb);
    void stopDlnaService();
    
    typedef void (*resultCallBack)(int status, const char* reason);
    void broadcast2Tv(const char* url, resultCallBack cb, const char* uuid);
    void doAction(ActionType type, resultCallBack cb, const char* uuid, const char* pos);
#endif
#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* httpSrv_h */
