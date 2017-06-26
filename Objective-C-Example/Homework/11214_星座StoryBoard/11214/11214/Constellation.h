//
//  Constellation.h
//  11214
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constellation : NSObject

@property(nonatomic,copy)NSString *image,*Name,*Fortune,*Text,*Date;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)ConstellationWithDict:(NSDictionary *)dict;
@end
