//
//  TipsEntity.m
//  ShiJia
//
//  Created by 蒋海量 on 16/7/15.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SearchEntity.h"
#import "CornerEntity.h"

@implementation SearchEntity
- (instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
        self.bitrate = dict[@"bitrate"];
        self.desc = dict[@"desc"];
        if ((![self.desc hasSuffix:@"..."]) &&self.desc) {
            self.desc = [NSString stringWithFormat:@"%@...",self.desc];
        }
        self.grade = dict[@"grade"];
        self.hlContent = dict[@"hlContent"];
        self.hlPosition = dict[@"hlPosition"];
        self.Id = dict[@"id"];
        self.imgUrl = dict[@"verticalPosterAddr"];
        if (self.imgUrl.length == 0) {
            self.imgUrl = dict[@"imgUrl"];
        }
        self.name = dict[@"name"];
        self.playCounts = dict[@"playCounts"];
        self.ppvId = dict[@"ppvId"];
        self.programType = dict[@"programType"];
        self.searchType = dict[@"searchType"];
        self.cornerArray = [NSMutableArray arrayWithArray:[self getCorners:dict[@"corner"]]];
    }
    return self;
}


- (NSArray*)getCorners:(id)responseObject{
    NSMutableArray* returnMenus = [[NSMutableArray alloc] init];
    for (NSDictionary* aMenu in responseObject) {
        [returnMenus addObject:[[CornerEntity alloc] initWithDict:aMenu]];
    }
    return returnMenus;
}

@end
