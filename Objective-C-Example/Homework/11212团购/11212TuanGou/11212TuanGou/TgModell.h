//
//  TgModell.h
//  11212TuanGou
//
//  Created by 马千里 on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TgModell : NSObject

@property(nonatomic,copy) NSString *title,*price,*icon,*buyCount;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)tgWithDict:(NSDictionary *)dict;

+ (NSArray *)tgList;

@end
