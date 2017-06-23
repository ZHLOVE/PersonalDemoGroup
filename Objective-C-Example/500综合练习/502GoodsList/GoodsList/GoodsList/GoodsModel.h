//
//  GoodsModel.h
//  GoodsList
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

// 商品属性
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,copy) NSString *alreadyCount;
@property (nonatomic,copy) NSString *totalCount;

// 自定义初始化方法
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)goodsModelWithDict:(NSDictionary *)dict;

// 封装了从plist得到一组该模型对象数组的方法
+ (NSArray *)goodsArr;

@end
