//
//  WatchingEntity.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "WatchingEntity.h"

@implementation WatchingEntity
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.uid = [dict objectForKey:@"uid"];
        self.programSeriesId = [dict objectForKey:@"programSeriesId"];
        self.programId = [dict objectForKey:@"programId"];
        self.programName = [dict objectForKey:@"programName"];
        self.type = [dict objectForKey:@"type"];
        self.second = [dict objectForKey:@"second"];
        self.channelUuid = [dict objectForKey:@"channelUuid"];
        self.catg = [dict objectForKey:@"catg"];
        self.deviceType = [dict objectForKey:@"deviceType"];
        
    }
    
    return self;
    
}
@end
