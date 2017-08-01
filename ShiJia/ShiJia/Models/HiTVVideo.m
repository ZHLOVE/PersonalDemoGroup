//
//  HiTVVideo.m
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "HiTVVideo.h"
#import "VideoSource.h"

@implementation HiTVVideo

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.actor = dict[@"actor"];
        self.alias = dict[@"alias"];
        self.audiences = dict[@"audiences"];
        self.catgId = dict[@"catgId"];
        self.character = dict[@"character"];
        self.competition = dict[@"competition"];
        self.content = dict[@"content"];
        self.contentDate = dict[@"contentDate"];
        self.cpcode = dict[@"cpcode"];
        self.defaultDefinition = dict[@"defaultDefinition"];
        self.definition = dict[@"definition"];
        self.director = dict[@"director"];
        self.extInfo = dict[@"extInfo"];
        self.guests = dict[@"guests"];
        self.hours = dict[@"hours"];
        self.videoID = dict[@"id"];
        self.information = dict[@"information"];
        self.isNew = dict[@"isNew"];
        self.language = dict[@"language"];
        self.length = dict[@"length"];
        self.maskDescription = dict[@"maskDescription"];
        self.name = dict[@"name"];
        self.picurl = dict[@"picurl"];
        if (self.picurl.length == 0) {
            self.picurl = dict[@"hImg"];
        }
        if (self.picurl.length == 0) {
            self.picurl = dict[@"vImg"];
        }
        self.playCounts = dict[@"playCounts"];
        self.playSort = dict[@"playSort"];
        self.ppvId = dict[@"ppvId"];
        self.presenter = dict[@"presenter"];
        self.producer = dict[@"producer"];
        self.programClass = dict[@"programClass"];
        self.programCount = dict[@"programCount"];
        self.programNo = dict[@"programNo"];
        self.publisher = dict[@"publisher"];
        self.rcmLevel = dict[@"rcmLevel"];
        self.relationlist = dict[@"relationlist"];
        self.releaseDate = dict[@"releaseDate"];
        self.specialInfo = dict[@"specialInfo"];
        self.specialLssueId = dict[@"specialLssueId"];
        self.style = dict[@"style"];
        self.subCaption = dict[@"subCaption"];
        self.subject = dict[@"subject"];
        self.tag = dict[@"tag"];
        self.type = dict[@"type"];
        self.typeCode = dict[@"typeCode"];
        self.zone = dict[@"zone"];
        self.contentType = dict[@"contentType"];
        self.ppvList = dict[@"ppvList"];

        NSMutableArray* sources = [[NSMutableArray alloc] init];

        NSArray* sourcesDictArray = dict[@"sources"];
        if ([sourcesDictArray isKindOfClass:[NSDictionary class]]) {
            [sources addObject:[[VideoSource alloc] initWithDict:(NSDictionary*)sourcesDictArray]];
        }else{
            for (NSDictionary* sourceDict in sourcesDictArray) {
                [sources addObject:[[VideoSource alloc] initWithDict:sourceDict]];
            }
        }

        self.sources = sources;
    }
    return self;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.actor = [aDecoder decodeObjectForKey:@"actor"];
    self.alias = [aDecoder decodeObjectForKey:@"alias"];
    self.audiences = [aDecoder decodeObjectForKey:@"audiences"];
    self.catgId = [aDecoder decodeObjectForKey:@"catgId"];
    self.character = [aDecoder decodeObjectForKey:@"character"];
    self.competition = [aDecoder decodeObjectForKey:@"competition"];
    self.content = [aDecoder decodeObjectForKey:@"content"];
    self.contentDate = [aDecoder decodeObjectForKey:@"contentDate"];
    self.cpcode = [aDecoder decodeObjectForKey:@"cpcode"];
    self.defaultDefinition = [aDecoder decodeObjectForKey:@"defaultDefinition"];
    self.definition = [aDecoder decodeObjectForKey:@"definition"];
    self.director = [aDecoder decodeObjectForKey:@"director"];
    self.extInfo = [aDecoder decodeObjectForKey:@"extInfo"];
    self.guests = [aDecoder decodeObjectForKey:@"guests"];
    self.hours = [aDecoder decodeObjectForKey:@"hours"];
    self.videoID = [aDecoder decodeObjectForKey:@"id"];
    self.information = [aDecoder decodeObjectForKey:@"information"];
    self.isNew = [aDecoder decodeObjectForKey:@"isNew"];
    self.language = [aDecoder decodeObjectForKey:@"language"];
    self.length = [aDecoder decodeObjectForKey:@"length"];
    self.maskDescription = [aDecoder decodeObjectForKey:@"maskDescription"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.picurl = [aDecoder decodeObjectForKey:@"picurl"];
    self.playCounts = [aDecoder decodeObjectForKey:@"playCounts"];
    self.playSort = [aDecoder decodeObjectForKey:@"playSort"];
    self.ppvId = [aDecoder decodeObjectForKey:@"ppvId"];
    self.presenter = [aDecoder decodeObjectForKey:@"presenter"];
    self.producer = [aDecoder decodeObjectForKey:@"producer"];
    self.programClass = [aDecoder decodeObjectForKey:@"programClass"];
    self.programCount = [aDecoder decodeObjectForKey:@"programCount"];
    self.programNo = [aDecoder decodeObjectForKey:@"programNo"];
    self.publisher = [aDecoder decodeObjectForKey:@"publisher"];
    self.rcmLevel = [aDecoder decodeObjectForKey:@"rcmLevel"];
    self.relationlist = [aDecoder decodeObjectForKey:@"relationlist"];
    self.releaseDate = [aDecoder decodeObjectForKey:@"releaseDate"];
    self.specialInfo = [aDecoder decodeObjectForKey:@"specialInfo"];
    self.specialLssueId = [aDecoder decodeObjectForKey:@"specialLssueId"];
    self.style = [aDecoder decodeObjectForKey:@"style"];
    self.subCaption = [aDecoder decodeObjectForKey:@"subCaption"];
    self.subject = [aDecoder decodeObjectForKey:@"subject"];
    self.tag = [aDecoder decodeObjectForKey:@"tag"];
    self.type = [aDecoder decodeObjectForKey:@"type"];
    self.typeCode = [aDecoder decodeObjectForKey:@"typeCode"];
    self.zone = [aDecoder decodeObjectForKey:@"zone"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.actor forKey:@"actor"];
    [aCoder encodeObject:self.alias forKey:@"alias"];
    [aCoder encodeObject:self.audiences forKey:@"audiences"];
    [aCoder encodeObject:self.catgId forKey:@"catgId"];
    [aCoder encodeObject:self.character forKey:@"character"];
    [aCoder encodeObject:self.competition forKey:@"competition"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.contentDate forKey:@"contentDate"];
    [aCoder encodeObject:self.cpcode forKey:@"cpcode"];
    [aCoder encodeObject:self.defaultDefinition forKey:@"defaultDefinition"];
    [aCoder encodeObject:self.definition forKey:@"definition"];
    [aCoder encodeObject:self.director forKey:@"director"];
    [aCoder encodeObject:self.extInfo forKey:@"extInfo"];
    [aCoder encodeObject:self.guests forKey:@"guests"];
    [aCoder encodeObject:self.hours forKey:@"hours"];
    [aCoder encodeObject:self.videoID forKey:@"id"];
    [aCoder encodeObject:self.information forKey:@"information"];
    [aCoder encodeObject:self.isNew forKey:@"isNew"];
    [aCoder encodeObject:self.language forKey:@"language"];
    [aCoder encodeObject:self.length forKey:@"length"];
    [aCoder encodeObject:self.maskDescription forKey:@"maskDescription"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.picurl forKey:@"picurl"];
    [aCoder encodeObject:self.playCounts forKey:@"playCounts"];
    [aCoder encodeObject:self.playSort forKey:@"playSort"];
    [aCoder encodeObject:self.ppvId forKey:@"ppvId"];
    [aCoder encodeObject:self.presenter forKey:@"presenter"];
    [aCoder encodeObject:self.producer forKey:@"producer"];
    [aCoder encodeObject:self.programClass forKey:@"programClass"];
    [aCoder encodeObject:self.programCount forKey:@"programCount"];
    [aCoder encodeObject:self.programNo forKey:@"programNo"];
    [aCoder encodeObject:self.publisher forKey:@"publisher"];
    [aCoder encodeObject:self.rcmLevel forKey:@"rcmLevel"];
    [aCoder encodeObject:self.relationlist forKey:@"relationlist"];
    [aCoder encodeObject:self.releaseDate forKey:@"releaseDate"];
    [aCoder encodeObject:self.specialInfo forKey:@"specialInfo"];
    [aCoder encodeObject:self.specialLssueId forKey:@"specialLssueId"];
    [aCoder encodeObject:self.style forKey:@"style"];
    [aCoder encodeObject:self.subCaption forKey:@"subCaption"];
    [aCoder encodeObject:self.subject forKey:@"subject"];
    [aCoder encodeObject:self.tag forKey:@"tag"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.typeCode forKey:@"typeCode"];
    [aCoder encodeObject:self.zone forKey:@"zone"];

}

@end
