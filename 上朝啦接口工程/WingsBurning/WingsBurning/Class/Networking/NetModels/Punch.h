//
//  Punch.h
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  打卡信息
 */
@interface Punch : NSObject

/** 打卡编号 */
@property (copy, nonatomic) NSString *ID;

/** 打卡时间 */
@property(nonatomic,copy) NSString *created_at;
@end
