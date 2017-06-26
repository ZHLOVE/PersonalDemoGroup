//
//  CityWeatherInfo.m
//  YLWeather
//
//  Created by student on 16/3/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CityWeatherInfo.h"

@implementation CityWeatherInfo

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)weatherInfoWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
