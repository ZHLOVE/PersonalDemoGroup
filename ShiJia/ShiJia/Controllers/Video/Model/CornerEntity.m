//
//  CornerEntity.m
//  ShiJia
//
//  Created by 蒋海量 on 16/10/28.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "CornerEntity.h"

@implementation CornerEntity
- (instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
        if (![dict[@"cornerImg"] isEqual:[NSNull null]]) {
            self.cornerImg = dict[@"cornerImg"];
        }
        self.position = dict[@"position"];
        
    }
    return self;
}


@end
