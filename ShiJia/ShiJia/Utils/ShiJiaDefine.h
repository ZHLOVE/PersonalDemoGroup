//
//  ShiJiaDefine.h
//  ShiJia
//
//  Created by 峰 on 16/7/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#ifndef ShiJiaDefine_h
#define ShiJiaDefine_h
/**
 *  Header
 */
#import "MBProgressHUD+AddHUD.h"


//weakSelf
#define WEAKOBJECT(obj,objName) typeof(obj) __weak objName = obj;

#define WEAKSELF WEAKOBJECT(self,weakSelf);

//---DDLogInfo---打印
#define DDLogLine(xx, ...)   NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define LOG_INFO(x) \
do { \
YLogOper logOper;\
logOper.SetInitInfo(__FILE__, __LINE__,LOG_LEVEL_INFO);\
logOper.LogWrite x ;\
} while (0)

#define LOG_DEBUG(x) \
do { \
YLogOper logOper;\
logOper.SetInitInfo(__FILE__, __LINE__,LOG_LEVEL_DEBUG);\
logOper.LogWrite x ;\
} while (0)

#define LOG_ERROR(x) \
do { \
YLogOper logOper;\
logOper.SetInitInfo(__FILE__, __LINE__,LOG_LEVEL_ERROR);\
logOper.LogWrite x ;\
} while (0)

//判空
#define StringNotEmpty(str)                 (str && (str.length > 0))
#define ArrayNotEmpty(arr)                  (arr && (arr.count > 0))

#define UPaiYunKey1 @"ysten"
#define UPaiYunKey2 @"UXghDVSCeCOzfRhD6zk9A8AJyc0="

#define SJERROR(string) [NSError errorWithDomain:@"SJerror" code:-100 userInfo:@{ NSLocalizedDescriptionKey:string }]


//资源类型
typedef enum {
    Media_Photo=0,
    Media_Vedio
    
}Media_TYPE;

typedef enum {
    CLOUD_TYPE=0,
    LOCAL_TYPE,
}Album_Type;
//社交平台
typedef NS_ENUM(NSUInteger, Platform) {
    ShiJia = 0,
    WeChat,
    WeChatFriend,
    SinaWeiBo,
    Contact
};

//分享类型
typedef NS_ENUM(NSUInteger, shareMessageType) {
    ShareMessageTypeImage=0,//图片
    ShareMessageTypeVideo=1,//视频
    ShareMessageTypeUrl  =2,//URL链接
    ShareMessageTypeText    //文字
};




#define BD_UPLOAD_ADDR [@"http://" stringByAppendingFormat:@"%@:%@/logup/%@/module=%@&action=%@&content=%@", @"127.0.0.1", [mgServer currentPort],@"%d",@"%@", @"%@", @"%@"]

#ifndef isNullString
#define isNullString(x) (x == nil || [x isKindOfClass:[NSNull class]]) ? @"": x
#define isBlankString(x) (x == nil || [x isKindOfClass:[NSNull class]] || x.length == 0) ? @" ": x
#endif




/**
 *  @brief 6为效果图UI尺寸
 */

//以 iPhone6 为效果设计图 填写6
#define SJRealValue_W(value) ((value)/375.0f*[UIScreen mainScreen].bounds.size.width)
#define SJRealValue_H(value) ((value)/667.0f*[UIScreen mainScreen].bounds.size.height)


#pragma mark - 根据分辨率设定 定值
/**
 *  默认返回 ip6
 *
 *  @param ip4  iPhone4、4s及更低设备
 *  @param ip5  iPhon5、5s设备
 *  @param ip6  iPhone6
 *  @param ip6p iPhone6P
 *
 *  @return 对应设备所需要的值
 */
#define AutoSize(ip4, ip5, ip6, ip6p)    \
({                                                                         \
float x = 0;                                                               \
UIDeviceResolution resolution = [UIDevice currentResolution];              \
switch (resolution) {                                                      \
case UIDevice_iPhoneStandardRes:                                           \
case UIDevice_iPhoneHiRes:                                                 \
x = (ip4);                                                                 \
break;                                                                     \
case UIDevice_iPhoneTallerHiRes:                                           \
x = (ip5);                                                                 \
break;                                                                     \
case UIDevice_iPhone6:                                                     \
x = (ip6);                                                                 \
break;                                                                     \
case UIDevice_iPhone6P:                                                    \
x = (ip6p);                                                                \
break;                                                                     \
default:                                                                   \
break;                                                                     \
}                                                                          \
x;                                                                         \
})

//-------------------------------


#if TARGET_IPHONE_SIMULATOR

#define AutoSize_W(ip4, ip5, ip6, ip6p)                                      \
AutoSize((ip4)*320. / 414, (ip5)*320. / 414, (ip6)*375. / 414,             \
(ip6p)*414. / 414 * 1)//1025 / 1242.

#define AutoSize_W_IP6(ip6p) AutoSize_W(ip6p, ip6p, ip6p, ip6p)

#define AutoSize_H(ip4, ip5, ip6, ip6p)                                      \
AutoSize((ip4)*568. / 736, (ip5)*568. / 736, (ip6)*667. / 736,             \
(ip6p)*736. / 736 * 1)//2001 / 2208.

#define AutoSize_H_IP6(ip6p) AutoSize_H(ip6p, ip6p, ip6p, ip6p)

#else//-------------------------------

#define AutoSize_W(ip4, ip5, ip6, ip6p)                                      \
AutoSize((ip4)*320. / 414, (ip5)*320. / 414, (ip6)*375. / 414,             \
(ip6p)*414. / 414 * 1)

#define AutoSize_W_IP6(ip6) AutoSize_W(ip6, ip6, ip6, ip6)

#define AutoSize_H(ip4, ip5, ip6, ip6p)                                      \
AutoSize((ip4)*568. / 736, (ip5)*568. / 736, (ip6)*667. / 736,             \
(ip6p)*736. / 736 * 1)

#define AutoSize_H_IP6(ip6) AutoSize_H(ip6, ip6, ip6, ip6)

#endif//-------------------------------



#define kCacheData    @"CacheData"//缓存的Data
#define kCacheObject  @"CacheObject" //对象
#define kCacheMD5     @"kCacheMD5"//MD5 值
#define kDownSuccess  @"kDownSuccess"//下载是否完成


#endif /* ShiJiaDefine_h */
