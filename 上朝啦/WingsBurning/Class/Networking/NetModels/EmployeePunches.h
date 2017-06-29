//
//  EmployeePunches.h
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmployeePunches : NSObject

/**
 *  图片Hash
 */
@property(nonatomic,copy) NSString *imageHash;
/**
 *  无线接入点名称
 */
@property(nonatomic,copy) NSString *wirelessAp;

/**
 *  操作系统名称及版本号
 */
@property(nonatomic,copy) NSString *operatingSystem;
/**
 *  经度
 */
@property(nonatomic,copy)  NSNumber *longitude;
/**
 *  纬度
 */
@property(nonatomic,copy)  NSNumber *latitude;

/**
 *  手机信号
 */
@property(nonatomic,copy) NSString *phone_model;


@end
