//
//  TgModel.h
//  TuanGou
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TgModel : NSObject

@property (nonatomic,copy) NSString *title,*price,*icon,*buyCount;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)tgWithDict:(NSDictionary *)dict;

+ (NSArray *)tgList;

@end
