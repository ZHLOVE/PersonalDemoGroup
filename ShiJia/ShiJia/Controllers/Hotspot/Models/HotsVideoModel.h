//
//  HotsVideoModel.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/22.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotsVideoModel : NSObject

@property (nonatomic,copy) NSString *videoId;
@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,copy) NSString *poster;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *timeLength;
@property (nonatomic,copy) NSString *playCounts;
@property (nonatomic,copy) NSString *programSeriesId;
@property (nonatomic,copy) NSString *programSeriesName;
@property (nonatomic,copy) NSString *programSeriesPoster;
@property (nonatomic,copy) NSString *actionType;
@property (nonatomic,copy) NSString *actionValue;
@property (nonatomic,copy) NSString *actionPoster;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end

/*  热点视频详情
 1	id	        String	是	视频ID
 2	videoUrl	String	是	播放地址
 3	poster   	String	是	视频海报
 4	title	    String	是	标题
 */

@interface hotVideoDetail : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *poster;
@property (nonatomic, strong) NSString *title;

@end


/**
 *  @brief 热点视频生成分享Web
 */
@interface requestWebLink : NSObject
@property (nonatomic, strong) NSString *ability;
@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userImg;

@end


@interface webLinkModel : NSObject
@property (nonatomic, strong) NSString *visitUrl;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *resultCode;
@property (nonatomic, strong) NSString *resultMessage;
@end
