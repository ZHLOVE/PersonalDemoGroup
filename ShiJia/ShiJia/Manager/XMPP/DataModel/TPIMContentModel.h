//
//  TPIMContentModel.h
//  HiTV
//
//  Created by yy on 15/8/14.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPIMEpgData;

/**
 *  播放器视频类型
 */
extern NSString * const VideoTypeLookback;//手机回看
extern NSString * const VideoTypeNative;//本地视频
extern NSString * const VideoTypeNetwork;//点播
extern NSString * const VideoTypeKanDianDianBo;//看点-点播
extern NSString * const VideoTypeKanDianZuiXin;//看点-最新
extern NSString * const VideoTypeChannelZuiXin;//频道直播


@interface TPIMContentModel : NSObject

@property (nonatomic, copy) NSString *content;//html描述
@property (nonatomic, copy) NSString *url;//节目播放地址url
@property (nonatomic, copy) NSString *startTime;//节目开始时间
@property (nonatomic, copy) NSString *endTime;//节目结束时间
@property (nonatomic, copy) NSString *directors;//导演
@property (nonatomic, copy) NSString *actors;//主演
@property (nonatomic, copy) NSString *programSeriesId;//节目集ID
@property (nonatomic, copy) NSString *programId;//节目ID
@property (nonatomic, copy) NSString *programName;//节目名称
@property (nonatomic, copy) NSString *roomId;//聊天室ID
@property (nonatomic, copy) NSString *datePoint;//节目断点时间，原来的"startTime"
@property (nonatomic, copy) NSString *videoType;//视频类型vod,watchtv,live,replay
@property (nonatomic, copy) NSString *thumPath;//海报url
@property (nonatomic, copy) NSString *channelUuid;//频道uuid
@property (nonatomic, copy) NSString *faceImg;//用户头像
@property (nonatomic, copy) NSString *pId;//节目集ID
@property (nonatomic, copy) NSString *icon;//聊天消息头像
@property (nonatomic, copy) NSString *from;//聊天消息发送者
@property (nonatomic, copy) NSString *seconds;//语音消息时长
@property (nonatomic, copy) NSString *video_url;//语音消息url

@property (nonatomic, copy) NSString *albumShareType;//云相册分享类型：0为短视频，1为图片

@property (nonatomic, copy) NSString *fromphone;//发送消息者电话号码
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *psId;
@property (nonatomic, copy) NSString *pImg;
@property (nonatomic, copy) NSString *stype;//投屏网络类型
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uuId;//看点，直播回看，必填
@property (nonatomic, copy) NSString *catgId;
@property (nonatomic, copy) NSString *playerType;//投屏类型
@property (nonatomic, copy) NSString *action;//动作类型
@property (nonatomic, copy) NSString *liveTag;//1-直播   2-回看   3-点播
@property (nonatomic, copy) NSString *assortId;//一级分类ID   看点、直播回看 情况下有就带上
@property (nonatomic, copy) NSString *time;//退出时播放断点
@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *contents;
@property (nonatomic, copy) NSString *deadLine;
@property (nonatomic, copy) NSString *progName;//节目名称  看点、直播回看必传
@property (nonatomic, copy) NSString *channelLogo;//频道logo
@property (nonatomic, copy) NSString *channelName;//频道名称
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *filesdpath;
@property (nonatomic, copy) NSString *hotspotID;//有料视频的ID

//用于弹幕消息投屏
@property (nonatomic, copy)   NSString    *isMyself;
@property (nonatomic, copy)   NSString    *haveDanmu;//是否显示弹幕  点播、看点、直播回看必填
@property (nonatomic, copy)   NSString    *type;
@property (nonatomic, strong) TPIMEpgData *epgDataModel;
@property (nonatomic, copy)   NSString    *epgData;
@property (nonatomic, assign) BOOL         showToast;
@property (nonatomic, copy)   NSString    *curPosition;
//@property (nonatomic, copy)   NSString    *toTV;

//用于遥控器控制
@property (nonatomic, copy)   NSString    *keyEvent;

@property (nonatomic, copy)   NSString    *stamp;


@end
