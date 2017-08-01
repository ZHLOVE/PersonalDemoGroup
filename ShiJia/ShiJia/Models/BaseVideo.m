//
//  BaseVideo.m
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "BaseVideo.h"

@implementation BaseVideo

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.videoID = [aDecoder decodeObjectForKey:@"id"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.action = [aDecoder decodeObjectForKey:@"action"];
    self.director = [aDecoder decodeObjectForKey:@"director"];
    self.actor = [aDecoder decodeObjectForKey:@"actor"];
    self.actionUrl = [aDecoder decodeObjectForKey:@"actionUrl"];
    self.imageUrl = [aDecoder decodeObjectForKey:@"picurl"];
    self.length = [aDecoder decodeObjectForKey:@"length"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.videoID forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.action forKey:@"action"];
    [aCoder encodeObject:self.director forKey:@"director"];
    [aCoder encodeObject:self.actor forKey:@"actor"];
    [aCoder encodeObject:self.actionUrl forKey:@"actionUrl"];
    [aCoder encodeObject:self.imageUrl forKey:@"picurl"];
    [aCoder encodeObject:self.length forKey:@"length"];

}

/*- (NSString*)actionUrl{
    return [NSString stringWithFormat:@"http://epg.is.ysten.com:8080/yst-epg/web/program!getMovieDetailList.action?programSeriesId=%@&templateId=61", self.videoID];
}*/
@end
