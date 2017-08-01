//
//  CollectionVideo.m
//  HiTV
//
//  Created by 蒋海量 on 15/5/13.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "CollectionVideo.h"

@implementation CollectionVideo
#pragma mark - NSCoding Methods

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.videoID = dict[@"objectid"];
        self.name = dict[@"objectname"];
        self.action = dict[@"objectaction"];
        self.director = dict[@"objecdirector"];
        self.actor = dict[@"objecactor"];
        self.actionUrl = dict[@"objectactionurl"];
        self.imageUrl = dict[@"objectext"];
        self.length = dict[@"length"];
        self.objecttype = dict[@"objecttype"];

    }
    return self;
}
- (instancetype)initWatchtvWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.videoID = dict[@"catgId"];
        self.name = dict[@"catgName"];
        self.director = dict[@"director"];
        self.actor = dict[@"leading"];
        self.imageUrl = dict[@"img"];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.videoID = [aDecoder decodeObjectForKey:@"objectid"];
    self.name = [aDecoder decodeObjectForKey:@"objectname"];
    self.action = [aDecoder decodeObjectForKey:@"objectaction"];
    self.director = [aDecoder decodeObjectForKey:@"objecdirector"];
    self.actor = [aDecoder decodeObjectForKey:@"objecactor"];
    self.actionUrl = [aDecoder decodeObjectForKey:@"objectactionurl"];
    self.imageUrl = [aDecoder decodeObjectForKey:@"objectext"];
    self.length = [aDecoder decodeObjectForKey:@"length"];
    self.objecttype = [aDecoder decodeObjectForKey:@"objecttype"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.videoID forKey:@"objectid"];
    [aCoder encodeObject:self.name forKey:@"objectname"];
    [aCoder encodeObject:self.action forKey:@"objectaction"];
    [aCoder encodeObject:self.director forKey:@"objecdirector"];
    [aCoder encodeObject:self.actor forKey:@"objecactor"];
    [aCoder encodeObject:self.actionUrl forKey:@"objectactionurl"];
    [aCoder encodeObject:self.imageUrl forKey:@"objectext"];
    [aCoder encodeObject:self.length forKey:@"length"];
    [aCoder encodeObject:self.objecttype forKey:@"objecttype"];

}
@end
