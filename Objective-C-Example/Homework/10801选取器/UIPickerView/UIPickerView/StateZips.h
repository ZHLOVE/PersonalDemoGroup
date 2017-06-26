//
//  StateZips.h
//  UIPickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StateZips : NSObject
//州名字列表
+ (NSArray *)states;
//当前州对应的邮编列表
+ (NSArray *)zipsFor:(NSString *)state;
@end
