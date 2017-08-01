//
//  RecentVideo.m
//  HiTV
//
//  Created by 蒋海量 on 15/5/15.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "RecentVideo.h"
//#import "JSON.h"

@implementation RecentVideo
- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.actors = dict[@"actors"];
        self.assortId = dict[@"assortId"];
        self.bannerImg = dict[@"bannerImg"];
        self.businessType = dict[@"businessType"];
        self.dateline = dict[@"dateline"];
        self.deviceGroupId = dict[@"deviceGroupId"];
        self.deviceType = dict[@"deviceType"];
        self.directors = dict[@"directors"];
        self.endTime = dict[@"endTime"];
        self.endWatchTime = dict[@"endWatchTime"];
        self.expired = dict[@"expired"];
        self.lastProgramId = dict[@"lastProgramId"];
        self.lastProgramName = dict[@"lastProgramName"];
        self.objectId = dict[@"objectId"];
        self.objectName = dict[@"objectName"];
        self.playType = dict[@"playType"];
        self.seriesNumber = dict[@"seriesNumber"];
        self.startTime = dict[@"startTime"];
        self.startWatchTime = dict[@"startWatchTime"];
        self.templateId = dict[@"templateId"];
        self.uid = dict[@"uid"];
        self.vendor = dict[@"vendor"];
        self.verticalImg = dict[@"verticalImg"];

    }
    return self;
}
- (NSString*) duration{
    if (self.startTime == 0 || self.endTime == 0) {
        return @"";
    }
    
    static NSDateFormatter* formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
    });
    double startTime = [self.startTime floatValue];
    double endTime = [self.endTime floatValue];

    return [NSString stringWithFormat:@"%@-%@",
            [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startTime]],
            [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endTime]]];
}
@end
