//
//  Shop.h
//  综合练习1
//
//  Created by niit on 16/2/26.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *icon;

// 初始化方法
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)shopWithDictionary:(NSDictionary *)dict;

@end
