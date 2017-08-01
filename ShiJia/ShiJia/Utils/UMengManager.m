//
//  UMengManager.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/17.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "UMengManager.h"

@implementation UMengManager
+(void)start{
    UMConfigInstance.appKey = UMengAppKey;
    UMConfigInstance.channelId = @"APP Store";
    [MobClick setAppVersion:APPVersion];
    [MobClick startWithConfigure:UMConfigInstance];
    
    [MobClick setCrashReportEnabled:NO];
}
+(void)event:(NSString *)eventId{
    [MobClick event:eventId];
}
+(void)event:(NSString *)eventId attributes:(NSDictionary *)attributes{
    [MobClick event:eventId attributes:attributes];

}
@end
