//
//  AnalysisHelper.h
//  TestAge
//
//  Created by niit on 16/4/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 解析数据模块
@interface AnalysisHelper : NSObject

// 分析网页解析出图片数组
+ (NSArray *)analysisImagesResult:(NSData *)data;

// 解析出所需要的年龄性别信息
+ (NSDictionary *)analysisInfo:(NSString *)str;

@end
