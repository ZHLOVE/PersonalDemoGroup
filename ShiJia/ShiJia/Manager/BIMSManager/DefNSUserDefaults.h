//
//  DefNSUserDefaults.h
//  HiTV
//
//  Created by 蒋海量 on 15/3/3.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

/*
 [NSUserDefaults standardUserDefaults]保存
*/

#import <Foundation/Foundation.h>

/*
 xmpp 相关
 */
#define STRLOCAL @"xmpp-ysten"

#define USERID @"USERID"
#define PASSWORD @"PASSWORD"
#define SERVER @"SERVER"

//遥控器悬浮icon是否显示
#define REMOTE_ICON_HIDDEN    @"REMOTE_ICON_HIDDEN"
//是否接收消息
#define MSG_RECEIVE    @"MSG_RECEIVE"
//是否上传观看记录
#define UPLOAD_WATCH_RECORD    @"UPLOAD_WATCH_RECORD"


//channelId环境配置
//#define channelId @"channelId"

//手机imei
#define IMEI @"imei"

//手机EPG3.0入口
#define BIMS_EPGVIPER @"BIMS_EPGVIPER"

//手机EPG2.0入口
#define BIMS_MOBILE_EPG_20 @"BIMS_MOBILE_EPG_20"

//EPG分组ID
#define BIMS_MOBILE_EPG_GROUPID @"BIMS_MOBILE_EPG_GROUPID"

//直播epg地址
#define BIMS_MOBILE_LIVE_LOOK_EPG @"BIMS_MOBILE_LIVE_LOOK_EPG"

//直播epg分组ID
#define BIMS_MOBILE_LIVE_LOOK_GROUPID @"BIMS_MOBILE_LIVE_LOOK_GROUPID"

//UIC入口(用户中心)
#define BIMS_SEEN @"BIMS_SEEN"

//手机播放媒体低码率兑换
#define BIMS_MOBILE_PROJECTION_LOW_DOMAIN @"BIMS_MOBILE_PROJECTION_LOW_DOMAIN"

//点播投屏域名入口
#define BIMS_MOBILE_PROJECTION_DOMAIN @"BIMS_MOBILE_PROJECTION_DOMAIN"

//直播投屏域名入口
#define BIMS_MOBILE_PROJECTION_LIVE_DOMAIN @"BIMS_MOBILE_PROJECTION_LIVE_DOMAIN"

//推荐位地址
#define BIMS_MOBILE_RECOMMEND @"BIMS_MOBILE_RECOMMEND"

//启动画面地址
#define BIMS_MOBILE_LOADING @"BIMS_MOBILE_LOADING"

//搜索资源
#define BIMS_SEARCH @"BIMS_SEARCH"

//看单EPG
#define BIMS_MYLOOK @"BIMS_MYLOOK"

//看点EPG
#define BIMS_LIVE_EPG @"BIMS_LIVE_EPG"

//看点分组ID
#define BIMS_LIVE_TEMPLATEID @"BIMS_LIVE_TEMPLATEID"

//多屏入口
#define BIMS_MULTISCREEN @"BIMS_MULTISCREEN"

//消息中心入口
#define BIMS_MOBILE_MSG @"BIMS_MOBILE_MSG"

//看单中心入口
#define BIMS_MOBILE_MYLOOKCENTER @"BIMS_MOBILE_MYLOOKCENTER"

//是否默认配置
#define DEFAULTSTATUS @"defaultStatus"

//模板ID
#define TEMPLATEID @"templateId"

//屏幕模板ID
#define SCREENID @"screenId"

//易视腾编号
#define YSTENID @"ystenId"

//TMS地址列表
#define ADDRESSLIST @"addressList"

//广电号
#define DEVICEID @"deviceId"

//手机用户中心ID
#define  P_UID @"p_UId"

//xmpp jid
#define XMPP_JID @"xmpp_jid"

//xmpp code
#define XMPP_CODE @"xmpp_code"

//xmpp service
#define XMPP_SERVICE @"xmpp_service"

//是否已上传设备token
#define Is_Upload_Device_Token @"Is_Upload_Device_Token"

//设备token号
#define DEVICE_TOKEN   @"device_token"

//远程推送消息
#define REMOTE_NOTIFICATION_USERINFO @"remote_notification_userInfo"

//是否已处理远程推送消息标志位
#define DID_HANDLE_REMOTE_NOTIFICATION @"did_handle_remote_notification"

//手机用户登录密钥
#define PK @"pk"

//终端用户中心ID
#define  S_YSTENUSERID @"s_ystenUserId"

//终端用户登录密钥
#define SK @"sk"
//是否第一次登录
#define ISNOTFIRSTLOGIN @"ISNOTFIRSTLOGIN"

//电视设备名称dic
#define DEVICESDIC @"DEVICESDIC"

//搜索历史记录
#define SEARCHSARRAY @"SEARCHSARRAY"

//又拍云地址
#define CLOUDSERVER @"CLOUDSERVER"

//又拍云上传地址
#define CLOUD_UP_SERVER @"BIMS_CLOUD_ALBUMS_UPLOAD_URL"

//BIMS数据缓存
#define BIMSRESULT @"BIMSRESULT"

//日志分享字段
#define LOG_SHARE_CONTENT @"share_content"

//日志分享视频时长字段
#define LOG_SHARE_VIDEO_LENGTH @"videoLength"

//日志推荐有礼朋友圈字段
#define LOG_PUSH_MOMENT @"moment_push"

//日志推荐有礼微信字段
#define LOG_PUSH_WECHAT @"wechat_push"

//本地保存首页栏目所有标签all
#define NAV_ALL @"nav_all"

//本地保存首页栏目显示标签tops
#define NAV_TOPS @"nav_tops"

//本地保存首页栏目隐藏标签bottons
#define NAV_BOTTONS @"nav_bottons"

//本地保存版本号
#define CFBundleVersion @"CFBundleVersion"

//用户信息
#define  USERINFO @"userInfo"

//匿名用户id
#define  ANONYMOUSUID @"anonymousUid"

//手机号
#define PHONENO @"phoneNo"

//频道列表
#define CHANNELLIST @"channellist"

//是否登录
#define ISLOGIN @"islogin"

//城市code
#define CITYCODE @"citycode"
