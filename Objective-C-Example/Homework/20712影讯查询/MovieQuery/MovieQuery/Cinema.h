//
//  Cinema.h
//  MovieQuery
//
//  Created by student on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cinema : NSObject

@property(nonatomic,copy)NSString *uid,*cityName,*cinemaName,*address,*telephone,*distance;



- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)dataWithDict:(NSDictionary *)d;

@end
