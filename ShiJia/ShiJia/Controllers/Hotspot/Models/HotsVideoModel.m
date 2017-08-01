//
//  HotsVideoModel.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/22.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "HotsVideoModel.h"

@implementation HotsVideoModel

- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.videoId = dict[@"id"];
//        self.videoUrl = dict[@"videoUrl"];
        self.videoUrl = [dict[@"videoUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.poster = dict[@"poster"];
        self.title = dict[@"title"];
        self.timeLength = dict[@"timeLength"];
        self.playCounts = dict[@"playCounts"];
        self.programSeriesId = dict[@"programSeriesId"];
        self.programSeriesName = dict[@"programSeriesName"];
        self.programSeriesPoster = dict[@"programSeriesPoster"];
        self.actionType = dict[@"actionType"];
        self.actionValue = dict[@"actionValue"];
        self.actionPoster = dict[@"actionPoster"];

    }
    return self;
}

@end

@implementation hotVideoDetail


@end

@implementation requestWebLink


@end

@implementation webLinkModel


@end
