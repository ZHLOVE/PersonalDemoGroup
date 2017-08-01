//
//  DLNADevice.h
//  ShiJia
//
//  Created by 峰 on 2017/3/14.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLNADevice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, assign) BOOL  isOffline;//isOffline:1 新的设备 0:该设备已经移除

@end
