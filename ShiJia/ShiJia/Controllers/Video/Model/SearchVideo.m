//
//  SearchVideo.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "SearchVideo.h"

@implementation SearchVideo

- (instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
        self.seriesId = dict[@"seriesId"];
        self.videoID = self.seriesId;
        self.name = dict[@"name"];
        self.type = dict[@"type"];
        self.classType = dict[@"classType"];
        self.createDate = dict[@"createDate"];
        self.imageUrl = dict[@"picurl"];
        self.action = dict[@"action"];
        self.actionUrl = dict[@"actionUrl"];
        self.director = dict[@"director"];
        self.actor = dict[@"leadingrole"];
        self.desc = dict[@"desc"];
        self.definition = dict[@"definition"];
    }
    return self;
}
@end