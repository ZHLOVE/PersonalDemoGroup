//
//  WatchListEntity.h
//  HiTV
//
//  Created by lanbo zhang on 8/3/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchListEntity : NSObject
/*
 *所属时段，看点为节目播出时段，点播为用户上次行为产生的时段
 */
@property (nonatomic, copy) NSString* hour;
/*
 *横版海报地址，若是非看点类型则横版海报为空
 */
@property (nonatomic, copy) NSString* posterAddr;
/*
 *推荐解释，html代码，有颜色
 */
@property (nonatomic, copy) NSString* reason;
/*
 *所属时段，看点为节目播出时段，点播为用户上次行为产生的时段
 */
@property (nonatomic, copy) NSString* resultId;
/*
 *结果类型：0:CRS机器推荐，1:人工推荐，2:内容强相关
 */
@property (nonatomic, copy) NSString* resultType;
/*
 *推荐位属于的用户ID，当多个用户时，以’|’分隔
 */
@property (nonatomic, copy) NSString* userId;
/*
 *竖版海报地址
 */
@property (nonatomic, copy) NSString* verticalPosterAddr;

@property (nonatomic, copy) NSString *islive;



/*
 *内容ID
 */
@property (nonatomic, copy) NSString* contentId;
/*
 *内容类型，vod：点播；watchtv：看点；live：直播；ad：广告；app：应用；weburl：网页。
*/
@property (nonatomic, copy) NSString* contentType;
@property (nonatomic, copy) NSString* contentInfo;
/*
 *所属栏目ID---[watchtv]
 */
@property (nonatomic, copy) NSString* categoryId;
/*
 *频道台标---[watchtv][live]
 */
@property (nonatomic, copy) NSString* channelLogo;
/*
 *频道名称---[watchtv][live]
 */
@property (nonatomic, copy) NSString* channelName;
/*
 *节目开始时间，毫秒数---[watchtv][live]
 */
@property (nonatomic) double startTime;
/*
 *节目结束时间，毫秒数---[watchtv][live]
 */
@property (nonatomic) double endTime;

@property (nonatomic, copy) NSString* duration;


/*
 *节目集描述---[watchtv][live]
 */
@property (nonatomic, copy) NSString* programSeriesDesc;
/*
  *节目集ID---[watchtv][vod]
 */
@property (nonatomic, copy) NSString* programSeriesId;
/*
 *节目集名称---[watchtv][vod][live]
 */
@property (nonatomic, copy) NSString* programSeriesName;
/*
 *节目集类型---[watchtv][live]
  节目集类型，当为综艺和新闻时，显示已播出XX期
 */
@property (nonatomic, copy) NSString* programSeriesType;
/*
 *集号---[watchtv][live]
 */
@property (nonatomic, copy) NSString* setNumber;

@property (nonatomic, copy) NSString* setNumberWord;

/*
 *频道UUID---[live]
 */
@property (nonatomic, copy) NSString* channelUuid;
/*
 *广告跳转地址---[ad]
 */
@property (nonatomic, copy) NSString* url;
/*
 *包名---[app]
 */
@property (nonatomic, copy) NSString* package;
/*
 *类名---[app]
 */
//@property (nonatomic, copy) NSString* class;
/*
 *版本---[app]
 */
@property (nonatomic, copy) NSString* version;
/*
 *下载地址---[app]
 */
@property (nonatomic, copy) NSString* downUrl;
/*
 *是否强制升级---[app]
 */
@property (nonatomic, copy) NSString* forceUpdate;
/*
 *自定义子json---[app]
 */
@property (nonatomic, copy) NSString* param;

/*
 * 设备类型：STB／MOBILE
 */
@property (nonatomic, copy) NSString* deviceType;

/*
 * 业务类型
 */
@property (nonatomic, copy) NSString* businessType;

/*
 * 好友ids
 */
@property (nonatomic, copy) NSString* friendIds;


//6.0数据实体
/*
 * 影片id
 */
@property (nonatomic, copy) NSString* videoID;
/*
 * 节目集
 */
@property (nonatomic, copy) NSString* categoryID;
/*
 * 弹出框类型
 */
@property (nonatomic, copy) NSString* promptType;

@property (nonatomic, copy) NSString* lastProgramId;


- (instancetype)initWithDictionary:(NSDictionary*)dict;


@end
