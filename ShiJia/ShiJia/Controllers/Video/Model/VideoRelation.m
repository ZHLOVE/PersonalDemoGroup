//
//  VideoRelation.m
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoRelation.h"

@implementation VideoRelation

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.videoID = dict[@"id"];
        self.name = dict[@"name"];
        self.imageUrl = dict[@"image"];
        self.action = dict[@"action"];
        self.actionUrl = dict[@"actionURL"];
    }
    return self;
}

@end
