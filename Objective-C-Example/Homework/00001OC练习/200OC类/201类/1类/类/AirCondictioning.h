//
//  AirCondictioning.h
//  类
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "def.h"

@interface AirCondictioning : NSObject

// 模式
@property (nonatomic,assign) AirCondictioningModel model;

// 状态
@property (nonatomic,assign) AirCondictioningStatus status;




@end
