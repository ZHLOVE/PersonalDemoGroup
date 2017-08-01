//
//  TPPlayerListItem.h
//  HiTV
//
//  Created by yy on 15/12/2.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VideoSource;

/*
 {
 "mAction":"OpenMedia",
 "mUrl":"http://m.icntvcdn.com/media/new/2013/icntv2/media/2014/08/14/48215dc6d54c40f2a01be00f1edec0f6.ts",
 "mId":"9922713",
 "mName":"[HD]01_催眠大师（蓝光）",
 "mFileSize":1353876548
 },
 */

@class VideoSource;

@interface TPIMSourceItem : NSObject

@property (nonatomic, copy) NSString *mAction;
@property (nonatomic, copy) NSString *mUrl;
@property (nonatomic, copy) NSString *mId;
@property (nonatomic, copy) NSString *mName;
@property (nonatomic, copy) NSString *mFileSize;

- (instancetype)initWithVideoSource:(VideoSource *)videosource;
- (VideoSource *)convertToVideoSource;

@end
