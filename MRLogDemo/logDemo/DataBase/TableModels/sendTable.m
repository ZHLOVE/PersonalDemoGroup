//
//  sendTable.m
//  logDemo
//
//  Created by MccRee on 2017/7/19.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "SendTable.h"
#import "NSString+Conversion.h"
#import "Utils.h"
#import "MJExtension.h"
#import "MRLog.h"

@interface SendTable()


@end

@implementation SendTable
MJExtensionLogAllProperties
- (instancetype)init
{
    self = [super init];
    if (self) {
        _seqid = [NSString generateUUID];
        _curtime = [Utils getCurrentTimetamp];
        _versionid = [MRLog sharedMRLog].versionid;
        _platformid = [MRLog sharedMRLog].platformid;
        _mac = [MRLog sharedMRLog].mac;
        _deviceid = [MRLog sharedMRLog].deviceid;
        _sendState = @"0";
    }
    return self;
}




/**
 移动端系统版本号，取不到时默认0，0标识为未知
 */
- (NSString *)versionid{
    if (_versionid == nil) {
        return @"0";
    }
    return _versionid;
}

/**
 如果是网页打开H5专题，获取不到deviceid或IMEI时，统一放15个0
 */
- (NSString *)deviceid{
    if (_deviceid == nil) {
        return @"000000000000000";
    }
    return _deviceid;
}


/**
 移动端型号，取不到时默认0，0标识为未知
 */
- (NSString *)platformid{
    if (_platformid == nil) {
        return @"0";
    }
    return _platformid;
}


/**
 移动端取不到时默认0，0标识为未知
 */
- (NSString *)mac{
    if (_mac == nil) {
        return @"0";
    }
    return _mac;
}



@end
