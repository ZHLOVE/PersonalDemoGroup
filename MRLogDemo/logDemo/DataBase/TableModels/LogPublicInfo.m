//
//  LogPublicInfo.m
//  logDemo
//
//  Created by MccRee on 2017/7/25.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "LogPublicInfo.h"
#import "Utils.h"
#import "LCGetWiFiSSID.h"
#import "MRLog.h"

@implementation LogPublicInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _uid = [MRLog sharedMRLog].uid;
        _phone_no = [MRLog sharedMRLog].phone_no;
        _brand = [MRLog sharedMRLog].brand;
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970]*1000;
        _t = [NSString stringWithFormat:@"%13.0f",interval];
        _versionid = [MRLog sharedMRLog].versionid;
        _nettype = [MRLog sharedMRLog].nettype;
        _wifiid = [MRLog sharedMRLog].wifiid;
        _innerip = [MRLog sharedMRLog].innerip;
        _gatwaymac = [MRLog sharedMRLog].gatwaymac;
    }
    return self;
}


@end




