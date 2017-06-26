//
//  ChinaArea.h
//  10803省市PickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarsModel : NSObject

@property(nonatomic,strong) NSArray *filePlist;
// 保存所有首字母
@property(nonatomic,strong) NSMutableArray *title;

// 保存所有汽车品牌名字
@property(nonatomic,strong) NSMutableArray *cars;

//得到首字母列表
+ (NSArray *)title;
//得到某首字母的品牌数组
+ (NSArray *)carsForTitle:(NSString *)title;
@end
