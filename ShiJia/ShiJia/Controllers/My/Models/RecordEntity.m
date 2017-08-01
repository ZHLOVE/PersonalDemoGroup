//
//  RecordEntity.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "RecordEntity.h"

@implementation RecordEntity
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.dateLine = [dict objectForKey:@"dateLine"];
        self.epgId = [dict objectForKey:@"epgId"];
        self.feedId = [dict objectForKey:@"feedId"];
        self.objtype = [dict objectForKey:@"objtype"];
        self.uid = [dict objectForKey:@"uid"];
        self.datePoint = [dict objectForKey:@"datePoint"];
        self.detailsId = [dict objectForKey:@"detailsId"];
        self.Id = [dict objectForKey:@"id"];
        self.score = [dict objectForKey:@"score"];
        self.templateId = [dict objectForKey:@"templateId"];
        self.times = [dict objectForKey:@"times"];
        self.watchTime = [dict objectForKey:@"watchTime"];

        NSDictionary *titleData = [dict objectForKey:@"titleData"];
        if([titleData isKindOfClass:[NSDictionary class]]) {
            self.boxuserid = [titleData objectForKey:@"boxuserid"];
            self.epgid = [titleData objectForKey:@"epgid"];
            self.objecactor = [titleData objectForKey:@"objecactor"];
            self.objecdirector = [titleData objectForKey:@"objecdirector"];
            self.objectaction = [titleData objectForKey:@"objectaction"];
            self.objectactionurl = [titleData objectForKey:@"objectactionurl"];
            self.objectext = [titleData objectForKey:@"objectext"];
            if (!self.objectext){
                self.objectext = [titleData objectForKey:@"img"];
            }
            self.objectid = [titleData objectForKey:@"objectid"];
            self.objectname = [titleData objectForKey:@"objectname"];
            if (!self.objectname){
                self.objectname = [titleData objectForKey:@"catgName"];
            }
            self.objectparam = [titleData objectForKey:@"objectparam"];
            self.objecttype = [titleData objectForKey:@"objecttype"];
            self.opertype = [titleData objectForKey:@"opertype"];
            self.actor = [titleData objectForKey:@"actor"];
            self.opertype = [titleData objectForKey:@"opertype"];
            self.picurl = [titleData objectForKey:@"picurl"];
            if (!self.picurl) {
                self.picurl = [titleData objectForKey:@"img"];

            }
            self.title = [titleData objectForKey:@"title"];
            if (!self.title) {
                self.title = [titleData objectForKey:@"catgName"];
            }
            self.type = [titleData objectForKey:@"type"];
            self.url = [titleData objectForKey:@"url"];
        }
    }
    
    return self;
    
}
@end
