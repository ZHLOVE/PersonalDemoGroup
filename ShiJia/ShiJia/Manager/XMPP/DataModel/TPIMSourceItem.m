//
//  TPPlayerListItem.m
//  HiTV
//
//  Created by yy on 15/12/2.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPIMSourceItem.h"
#import "AES128Util.h"
#import "VideoSource.h"

/*
 {
 "mAction":"OpenMedia",
 "mUrl":"http://m.icntvcdn.com/media/new/2013/icntv2/media/2014/08/14/48215dc6d54c40f2a01be00f1edec0f6.ts",
 "mId":"9922713",
 "mName":"[HD]01_催眠大师（蓝光）",
 "mFileSize":1353876548
 },
 */

@implementation TPIMSourceItem

- (instancetype)initWithVideoSource:(VideoSource *)videosource
{
    self = [super init];
    
    if (self) {
        
        self.mAction = videosource.action;
        self.mUrl = [self convertActionUrl:videosource.actionURL];
        self.mId = videosource.sourceID;
        self.mName = videosource.name;
        self.mFileSize = videosource.fileSize;
    }
    return self;
}

- (NSString *)convertActionUrl:(NSString *)urlString
{
    NSString *key = @"36b9c7e8695468dc";
    
    if ([urlString rangeOfString:@"yst://"].location != NSNotFound) {
        
        NSString *strUrl = [urlString stringByReplacingOccurrencesOfString:@"yst://" withString:@""];
        
        return [AES128Util AES128Decrypt:strUrl key:key];
    }
    else{
        return urlString;
    }
}

- (VideoSource *)convertToVideoSource
{
    VideoSource *data = [[VideoSource alloc] init];
    data.actionURL = self.mUrl;
    data.name = self.mName;
    data.action = self.mAction;
    data.fileSize = self.mFileSize;
    data.sourceID = self.mId;
    return data;
}

#pragma mark - MJExtension
//+ (NSDictionary *)objectClassInArray
//{
//    //stype liveTag time resultCode
//    return @{@"startTime":MJTypeFloat,@"liveTag":MJTypeInt,@"time":MJTypeFloat,@"resultCode":MJTypeInt};
//}

@end
