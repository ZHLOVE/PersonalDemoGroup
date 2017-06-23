//
//  ChinaArea.h
//  UIPickerViewDemo
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChinaArea : NSObject

// 得到省会列表
+ (NSArray *)provinces;

// 得到某省会的城市数组
+ (NSArray *)citsForProvince:(NSString *)province;

// 得到某省会的某城市下的区数组
//+ (NSArray *)zoneForProvince:(NSString *)province andCity:(NSString *)city;

@end
