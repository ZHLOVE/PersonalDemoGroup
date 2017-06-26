//
//  Hell.h
//  MovieQuery
//
//  Created by student on 16/4/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hell : NSObject

@property(nonatomic,copy)NSString *hall,*price,*time;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)dataWithDict:(NSDictionary *)d;

@end
