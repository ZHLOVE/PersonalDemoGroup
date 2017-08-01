//
//  logTable.m
//  logDemo
//
//  Created by MccRee on 2017/7/19.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "LogTable.h"


@implementation LogTable

- (instancetype)init
{
    self = [super init];
    if (self) {
        _logId = [NSString generateUUID];
        _curtime = [Utils getCurrentTimetamp];
        _state = 0;
    }
    return self;
}


@end
