//
//  HiTVGlobals.h
//  HiTV
//
//  Created by 蒋海量 on 15/3/11.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

/**
 *  全局变量管理
 */

#import <Foundation/Foundation.h>
//用户中心：社交电视系统
//#define SOCIALHOST @"http://social.demo.taipan.ysten.com"
#define SOCIALHOST [HiTVGlobals sharedInstance].getsocial_host

//电视行为记录
//#define WXSEEN @"http://wxseen.demo.taipan.ysten.com"
#define WXSEEN [HiTVGlobals sharedInstance].getUic

//消息中心
//#define MSGCENTERHOST @"http://msg.demo.taipan.ysten.com"
//#define MSGCENTERHOST @"http://msg.formal.taipan.ysten.com:8080"
#define MSGCENTERHOST [HiTVGlobals sharedInstance].getBims_msg

//多屏系统
//#define MultiHost @"http://mc.formal.taipan.ysten.com:8080"
#define MultiHost [HiTVGlobals sharedInstance].getBims_multiscreen

//看点、频道
//#define LOOKTVEPG @"http://looktvepgjx.formal.taipan.ysten.com:8080"
//#define LOOKTVEPG @"http://looktvepg.jx.ysten.com:8080"
#define LOOKTVEPG [HiTVGlobals sharedInstance].getLive_epg

//看点分组id
#define WATCHTVGROUPID [HiTVGlobals sharedInstance].getLiveepg_groupId

//个人节目单
//#define MYEPG @"http://myepg.formal.taipan.ysten.com:8080"
#define MYEPG [HiTVGlobals sharedInstance].getBims_mylook

//XMPP_Host
#define XMPPHOST [HiTVGlobals sharedInstance].getxmpp_host

//XMPP_HostName
//#define XMPP_HostName [HiTVGlobals sharedInstance].getxmpp_hostName

//搜索
#define SEARCH_HOST [HiTVGlobals sharedInstance].getBims_search

//直播
#define LIVE_HOST   [HiTVGlobals sharedInstance].live_epg

//又拍云的key
#define CLOUD_SERVER [HiTVGlobals sharedInstance].cloud_server

////又拍云上传URL
//#define CLOUD_UPLOAD_SERVER [HiTVGlobals sharedInstance].bims_clouduploadUrl

//分享
#define SHARE_SERVER [HiTVGlobals sharedInstance].share_server

//播控能力串
#define T_STBext [HiTVGlobals sharedInstance].STBext
//直播开关   0关闭  1打开
#define OPENFLAG [HiTVGlobals sharedInstance].open_flag

//服务集id
//#define CHANNELID @"DTP63"   //6.3
//#define CHANNELID @"X2GWTP"   //6.4
//#define CHANNELID @"SCTP"     //四川
//#define CHANNELID @"JSTPTP"     //江苏
//#define CHANNELID @"TPBJBJ"     //北京

//定向IP
#define DINGXIANG [HiTVGlobals sharedInstance].dingxiangIP
/*
 *  6.4新增
 */
//业务系统
//#define BUSINESSHOST @"http://192.168.1.71:8080"
#define BUSINESSHOST [HiTVGlobals sharedInstance].facadeUrl
//域
#define BIMS_DOMAIN [HiTVGlobals sharedInstance].domain
//云相册上传
#define BIMS_CLOUD_ALBUMS_UPLOAD_URL [HiTVGlobals sharedInstance].clouduploadUrl
//云相册新增查询
#define BIMS_CLOUD_ALBUMS [HiTVGlobals sharedInstance].cloudalbumsUrl
//支付
#define BIMS_YSTEN_PAY [HiTVGlobals sharedInstance].ystenapyUrl
//缩略图后缀
#define BIMS_THUMB_SUFFIX [HiTVGlobals sharedInstance].thumbSuffix

//融合EPG
//!!!:
//!!!:
//!!!:
#define FUSE_EPG [HiTVGlobals sharedInstance].cos_epg
//业务支撑  江苏版本登录
#define BSS_HOST [HiTVGlobals sharedInstance].bssUserHost

//DMS系统
#define DMS_HOST [HiTVGlobals sharedInstance].dmsHost

//热点短视频生产系统
#define HOTPRODUCT_HOST [HiTVGlobals sharedInstance].productHost

//热点短视频分享
#define HOTSHARE_HOST [HiTVGlobals sharedInstance].shareServiceHost
//测试uid
#define TestUID @"20916088"
//当前版本号
#define VERSION @"taipan6.4"   //

static NSString* const taipanTest63 = @"DTP63";
static NSString* const taipanTest64 = @"X2GWTP";
static NSString* const X2GWTP = @"X2GWTP";

@interface HiTVGlobals : NSObject
@property(nonatomic) BOOL formal;               //环境配置:正式环境:YES；测试环境:NO

@property(nonatomic,strong) NSString *xmppUserId;       //连接xmpp用户id
@property(nonatomic,strong) NSString *xmppCode;         //xmpp帐号密码
@property(nonatomic,strong) NSString *serviceAddrs;     //服务节点
@property(nonatomic,strong) NSString *xmppService;      //xmpp服务器
@property(nonatomic,strong) NSString *xmppResource;     //xmpp resource
@property(nonatomic,assign) BOOL xmppConnected;           //是否已连接xmpp

@property(nonatomic,strong) NSString *epg_id;           //推送影片id
@property(nonatomic) BOOL IsPush;                       //推送
@property(nonatomic) BOOL Isplaying;

@property(nonatomic, assign) BOOL   isWatchingVideo;    //正在观看视频标志位

@property(nonatomic,strong) NSString *deviceId;       //设备标识
@property(nonatomic,strong) NSString *uid;       //用户中心id
@property(nonatomic,strong) NSString *anonymousUid;       //匿名用户id

@property(nonatomic,assign) BOOL isLogin;       //用户中心id
@property(nonatomic,assign) BOOL isManualLogIn; //手动登录标志位

@property(nonatomic,strong) NSString *faceImg;       //用户头像
@property(nonatomic,strong) NSString *nickName;       //用户昵称

@property(nonatomic,strong) NSString *cos_epg;              //融合EPG

@property(nonatomic,strong) NSString *epg_30;               //手机EPG3.0入口
@property(nonatomic,strong) NSString *epg_20;               //手机EPG2.0入口
@property(nonatomic,strong) NSString *epg_groupId;          //EPG分组ID
@property(nonatomic,strong) NSString *liveepg;              //直播epg地址
@property(nonatomic,strong) NSString *liveepg_groupId;       //直播epg分组ID
@property(nonatomic,strong) NSString *uic;                  //UIC入口
@property(nonatomic,strong) NSString *projection_low_domain;     //手机播放媒体低码率兑换
@property(nonatomic,strong) NSString *projection_domain;     //点播投屏域名入口
@property(nonatomic,strong) NSString *projection_live_domain;           //直播投屏域名入口
@property(nonatomic,strong) NSString *recommend;           //推荐位地址
@property(nonatomic,strong) NSString *loading;              //启动画面地址
@property(nonatomic,strong) NSString *bims_search;              //搜索资源
@property(nonatomic,strong) NSString *bims_mylook;              //看单EPG
@property(nonatomic,strong) NSString *live_epg;              //看点EPG
@property(nonatomic,strong) NSString *live_templateId;              //看点分组
@property(nonatomic,strong) NSString *bims_multiscreen;              //多屏入口
@property(nonatomic,strong) NSString *bims_msg;              //消息中心入口
@property(nonatomic,strong) NSString *bims_mylookcenter;              //看单中心入口
@property(nonatomic,strong) NSString *xmpp_host;              //XMPP_Host
@property(nonatomic,strong) NSString *xmpp_hostName;              //XMPP_Hostname

@property(nonatomic,strong) NSString *social_host;              //社交系统域名
@property(nonatomic,strong) NSString *cloud_server;              //又拍云
@property(nonatomic,strong) NSString *share_server;              //分享
@property(nonatomic,strong) NSString *STBext;              //播控能力串
@property(nonatomic,strong) NSString *open_flag;              //直播开关
@property(nonatomic,strong) NSString *library_url;              //敏感词库
@property(nonatomic,strong) NSString *dingxiangIP;              //定向ip
@property(nonatomic,strong) NSString *domain;              //域
@property(nonatomic,strong) NSString *clouduploadUrl;              //云相册上传
@property(nonatomic,strong) NSString *cloudalbumsUrl;              //云相册新增查询
@property(nonatomic,strong) NSString *ystenapyUrl;              //支付系统
@property(nonatomic,strong) NSString *thumbSuffix;              //缩略图后缀
@property(nonatomic,strong) NSString *facadeUrl;              //业务系统

@property(nonatomic,strong) NSArray *disable_moudles;              //过滤业务
@property(nonatomic,strong) NSString *offline_COLUMN;              //下线的栏目id
@property(nonatomic,strong) NSString *offline_CHANNEL;              //下线的频道id

@property(nonatomic,strong) NSString *screenId;       //屏幕模板ID
@property(nonatomic,strong) NSString *ystenId;       //易视腾编号
@property(nonatomic,strong) NSString *templateId;       //模板ID,终端认证服务下发ID

@property(nonatomic,strong) NSString *username;       //用户名称

//设备信息
@property(nonatomic,strong) NSString *latitude;       //经度
@property(nonatomic,strong) NSString *longitude;       //纬度
@property(nonatomic,strong) NSString *intranetIp;       //内网ip
@property(nonatomic,strong) NSString *ssid;       //热点名称
@property(nonatomic,strong) NSString *gateWay;       //网关
@property(nonatomic,strong) NSString *gateWayMac;       //wifi的mac地址
@property(nonatomic,strong) NSString *phoneNo;       //手机号
@property(nonatomic,strong) NSString *tvAnonymousUid;       //组播收到盒子uid
@property(nonatomic,strong) NSMutableArray *tvAnonymousUidArray;       //缓存上报过的盒子id

@property(nonatomic,strong) NSString *iniT;       //标识是否为正常的基础信息初始化，true：正常初始化（原来的机制不变）；false：为xmpp掉线自动重连，终端在线状态初始化


@property(nonatomic,assign) BOOL isPublicRecord;       //是否公开观看记录
@property(nonatomic,assign) BOOL isReceiveMsg;       //是否接收新通知
@property(nonatomic,assign) BOOL isShowRemoteIcon;       //遥控器浮标
@property(nonatomic,assign) BOOL isChatRoomWatchingVideo;//是否在聊天室
@property(nonatomic,assign) BOOL isBarrageOn;            //弹幕开启标志位
@property(nonatomic,assign) BOOL isFullScreenWatchingVideo;//是否为全屏模式观看视频

@property (nonatomic, assign) NSTimeInterval timeIntervalDifferece; //系统与服务器时间差

@property(nonatomic,strong) NSArray *wordfilterArray;       //敏感词库

@property(nonatomic,strong) NSString *shareContent;       //短信分享内容

@property(nonatomic,assign) BOOL VIP;       //是否是会员
@property(nonatomic,strong) NSString *expireDate;       //会员有效期
@property(nonatomic,strong) NSString *marketingDesc;       //营销描述信息

@property(nonatomic,strong) NSString *getTvType;       //获取疑似列表type

@property(nonatomic) BOOL isXmppConflicted;//xmpp是否被踢掉

@property(atomic,strong) NSString *loggerAddr;

@property(nonatomic,strong) NSString *apkUpdateHost;       //升级请求地址
@property(nonatomic,strong) NSString *softCode;       //升级code
@property(nonatomic,strong) NSString *imei;       //设备唯一编号
@property(nonatomic,assign) int delaySecond;       //直播延时
@property (nonatomic, strong) NSArray *friendsArray; //好友列表
@property (nonatomic, strong) NSString *phoneApk; //下载地址
@property(nonatomic,strong) NSString *bssUserHost;       //业务平台
@property(nonatomic,strong) NSString *shareUrl;       //业务平台
@property(nonatomic,strong) NSString *dmsHost;       //DMS平台
@property(nonatomic,strong) NSString *productHost;       //短视频生产系统
@property(nonatomic,strong) NSString *shareServiceHost;       //短视频分享系统
@property (nonatomic, assign) BOOL DLNASuccess;


@property(nonatomic,strong) NSString *shareType;       //短视频,常规视频  用于分享回调判断
@property(nonatomic,strong) NSString *shareWay;       //用于区别微信与朋友圈

/*------6.6------*/
@property(nonatomic,strong) NSString *districtCode;       //地市code，取于登录下发，用于DMS传参
@property(nonatomic,strong) NSString *livingToken;       //手机获取生活缴费用户登录token

@property(nonatomic,strong) NSString *interested;       //默认点亮标签

+ (instancetype)sharedInstance;
/**
 *  手机EPG3.0入口
 */
-(NSString *)getEpg_30;
/**
 *  手机EPG2.0入口
 */
-(NSString *)getEpg_20;
/**
 *  EPG分组ID
 */
-(NSString *)getEpg_groupId;

/**
 *  直播epg分组ID
 */
-(NSString *)getLiveepg_groupId;
/**
 *  UIC入口
 */
-(NSString *)getUic;
/**
 *  手机播放媒体低码率兑换
 */
-(NSString *)getProjection_low_domain;
/**
 *  点播投屏域名入口
 */
-(NSString *)getProjection_domain;
/**
 *  直播投屏域名入口
 */
-(NSString *)getProjection_live_domain;
/**
 *  推荐位地址
 */
-(NSString *)getRecommend;

/**
 *  启动画面地址
 */
-(NSString *)getLoading;
/**
 *  搜索资源
 */
-(NSString *)getBims_search;
/**
 *  看单EPG
 */
-(NSString *)getBims_mylook;
/**
 *  看点EPG
 */
-(NSString *)getLive_epg;
/**
 *  看点分组
 */
-(NSString *)getLive_templateId;
/**
 *  多屏入口
 */
-(NSString *)getBims_multiscreen;
/**
 *  消息中心入口
 */
-(NSString *)getBims_msg;
/**
 *  看单中心入口
 */
-(NSString *)getBims_mylookcenter;
/**
 *  XMPP_Host
 */
-(NSString *)getxmpp_host;
/**
 *  XMPP_HostName
 */
-(NSString *)getxmpp_hostName;

/**
 *  社交系统
 */
-(NSString *)getsocial_host;


/**
 *  色值转换
 */
+ (UIColor *) colorFromHexCode:(NSString *)hexString;
/**
 *  定向IP
 */
+ (NSURL *)dingxiangIpForPlayUrl:(NSURL *)url;

@end
