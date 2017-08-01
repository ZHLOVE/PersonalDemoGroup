//
//  SJ30SVedioRequestModel.h
//  ShiJia
//
//  Created by 峰 on 16/7/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJ30SVedioRequestModel : NSObject

@property (nonatomic) NSInteger videoSecond;//(30 60)
//(节目id,类型是直播时传入uuid,其他传入播放地址（截取/media/之后相对路径)  短视频 传 完整的地址
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *videoTitle;
@property (nonatomic, strong) NSString *videoType;//直播-live 点播-vod 回看-lookback 看点-looktv 短视频-rec 图片：photo
@property (nonatomic) NSInteger videoTime;//(单位是秒（s）)
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userHeadImageUrl;
@property (nonatomic, strong) NSString *videoImg;

@end
/**
 *  获取30 秒短视频 model
 */
@interface SJ30SVedioModel : NSObject
@property (nonatomic) NSInteger code;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userHeadImageUrl;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *modeltype;


@end
/*
 1	psId	        String	是	内容id
 2	pId	            String	是	节目id
 3	uuid	        String	是	频道UUID/直播或回看透传该字段
 4	contentType	    String	否	分享类型 vod:点播 watchTv:看点 newWatchTv: 看点(有直播)
 5	mediaType	    String	否	媒体类型 vod:点播 live:直播 replay:回看
 6	contentName	    String	是	内容名称
 7	startTime	    String	是	视频分享的起始时间
 8	shareSeconds	String	是	分享秒数
 9	uid	            String	否	用户标识
 10	userName	    String	是	用户名称
 11	userImgUrl	    String	是	用户头像
 12	phoneNo	        String	否	手机号码
 13	domain	        String	是	用户所属域
 14 channelBeginTime String 否  节目开始时间
 15 channelEndTime   String 否  节目结束时间
 */
@interface SMSRequestParams : NSObject

@property (nonatomic, strong) NSString *psId;
@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *contentName;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *shareSeconds;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userImgUrl;
@property (nonatomic, strong) NSString *phoneNo;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *channelBeginTime;
@property (nonatomic, strong) NSString *channelEndTime;

@end
/*
 1	resultCode	    String	否	000：成功，其他：失败
 2	resultMessage	String	否	返回信息描述
 3	imageUrl	    String	是	图片地址
 4	title	        String	是	标题
 5	visitUrl	    String	是	请求地址
 */

@interface SMSResponseModel : NSObject

@property (nonatomic, strong) NSString *resultCode;
@property (nonatomic, strong) NSString *resultMessage;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *visitUrl;

@end
/*
1	contentType	String	否	分享类型 rec：本地短视频 photo：本地图片
2	shareUrl	String	否	终端分享本地短视频或者本地图片的播放url
3	uid	        String	否	用户标识
4	userName	String	是	用户名称
5	userImgUrl	String	是	用户头像
6	phoneNo	    String	否	手机号码
7	domain	    String	是	用户所属域 */

@interface SMSLocalRequestParams : NSObject
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userImgUrl;
@property (nonatomic, strong) NSString *phoneNo;
@property (nonatomic, strong) NSString *domain;
@end

/*
 1	resultCode	    String	否	000：成功，其他：失败
 2	resultMessage	String	否	返回信息描述
 3	imageUrl	    String	是	图片地址
 4	title	        String	是	标题
 5	visitUrl	    String	是	请求地址


@interface SMSLocalResponseModel : NSObject

@property (nonatomic, strong) NSString *resultCode;
@property (nonatomic, strong) NSString *resultMessage;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *visitUrl;

@end
 */
