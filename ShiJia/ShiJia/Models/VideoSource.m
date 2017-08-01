//
//  VideoSource.m
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoSource.h"
#import "CornerEntity.h"

@implementation VideoSource

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.sourceID = dict[@"id"];
        self.name = dict[@"name"];
        self.fileSize = dict[@"fileSize"];
        self.action = dict[@"action"];
        self.actionURL = dict[@"actionURL"];
        self.setNumber = dict[@"setNumber"];
        self.trialDura = dict[@"trialDura"];
        self.mediaType = dict[@"mediaType"];
        self.channelUuid = dict[@"channelUuid"];
        self.ppvList = dict[@"ppvList"];
        self.startTime = [dict[@"startTime"] description];
        self.endTime = [dict[@"endTime"] description];
        
        self.cornerArray = [NSMutableArray arrayWithArray:[self getCorners:dict[@"corner"]]];
        /* NSMutableArray* returnMenus = [[NSMutableArray alloc] init];
         CornerEntity *entity = [CornerEntity new];
         entity.position = @"2";
         entity.cornerImg = @"http://192.168.1.5:8083/poster/alice091203/specialpt/corner/ffjb.png";
         [returnMenus addObject:entity];
         self.cornerArray = returnMenus;*/

        self.isEnable = YES;
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
