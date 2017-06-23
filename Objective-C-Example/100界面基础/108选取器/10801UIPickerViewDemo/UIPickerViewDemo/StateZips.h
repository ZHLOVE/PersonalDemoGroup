//
//  StateZips.h
//  UIPickerViewDemo
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateZips : NSObject

// 州名字列表
+ (NSArray *)states;

// 某州对应的邮编列表
+ (NSArray *)zipsFor:(NSString *)state;

@end
