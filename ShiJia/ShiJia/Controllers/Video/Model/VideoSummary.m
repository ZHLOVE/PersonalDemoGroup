//
//  VideoSummary.m
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoSummary.h"
#import "CornerEntity.h"

@implementation VideoSummary

- (instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
        self.bitrate = dict[@"bitrate"];
        self.catgItemId = dict[@"catgItemId"];
        self.cumulAttentions = dict[@"cumulAttentions"];
        self.descript = dict[@"descript"];
        self.enName = dict[@"enName"];
        self.fans = dict[@"fans"];
        self.grade = dict[@"grade"];
        self.videoID = dict[@"id"];
        self.imgUrl = dict[@"vImg"];
        if (self.imgUrl.length == 0) {
            self.imgUrl = dict[@"vimg"];
        }
        if (self.imgUrl.length == 0) {
            self.imgUrl = dict[@"hImg"];
        }
        self.imgUrl_m = dict[@"imgUrl_m"];
        self.imgUrl_s = dict[@"imgUrl_s"];
        self.name = dict[@"name"];
        self.nowCount = dict[@"nowCount"];
        self.playCounts = dict[@"playCounts"];
        self.ppvId = dict[@"ppvId"];
        self.rcmLevel = dict[@"rcmLevel"];
        self.subCaption = dict[@"subCaption"];
        self.totalCount = dict[@"totalCount"];
        self.updateComment = dict[@"updateComment"];
        self.updateDate = dict[@"updateDate"];
        
        //轮播添加
        self.imageUrl = dict[@"image"];

        //融合epg 20161027
        self.psId = dict[@"psId"];
        self.contentType = dict[@"contentType"];
        self.channelLogo = dict[@"channelLogo"];

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

