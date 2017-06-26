//
//  ChinaArea.h
//  10803省市PickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChinaArea : NSObject

@property(nonatomic,strong) NSArray *filePlist;
// 保存所有省信息
@property(nonatomic,strong) NSMutableArray *provinces;

// 保存所有城市名字
@property(nonatomic,strong) NSMutableArray *cities;

//得到省会列表
+ (NSArray *)provinces;
//得到某省会的城市数组
+ (NSArray *)citiesForProvince:(NSString *)province;
@end
