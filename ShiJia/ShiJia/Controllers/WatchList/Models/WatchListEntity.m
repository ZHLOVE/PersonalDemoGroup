//
//  WatchListEntity.m
//  HiTV
//
//  Created by lanbo zhang on 8/3/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "WatchListEntity.h"

@implementation WatchListEntity

//+(BOOL)propertyIsIgnored:(NSString*)propertyName{
//    if ([@"recommandState" isEqualToString:propertyName]
//        || [@"collectionState" isEqualToString:propertyName]
//        || [@"playing" isEqualToString:propertyName]) {
//        return YES;
//    }
//    return [super propertyIsIgnored:propertyName];
//}
//

//
//@end
//
//@implementation WatchListFriend

- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.hour = dict[@"hour"];
        self.friendIds = dict[@"friendIds"];
        self.posterAddr = dict[@"posterAddr"];
        self.reason = dict[@"reason"];
        self.resultId = dict[@"resultId"];
        self.resultType = dict[@"resultType"];
        self.userId = dict[@"userId"];
        self.verticalPosterAddr = dict[@"verticalPosterAddr"];
        self.programSeriesId = [dict objectForKey:@"programSeriesId"];
        self.islive = [dict objectForKey:@"islive"];
        self.programSeriesName = [dict objectForKey:@"programSeriesName"];
        self.programSeriesDesc = [dict objectForKey:@"programSeriesDesc"];
        self.promptType = [dict objectForKey:@"promptType"];

        NSDictionary *contentDic = dict[@"content"];
        if (contentDic != nil) {
            if ([contentDic.class isSubclassOfClass:[NSArray class]]&&contentDic.count>0) {
                BOOL isLoad = NO;

                for (NSDictionary *dic in (NSArray *)contentDic) {
                   // [self loadContentData:dic];
                    NSDictionary* contentInfoDic = dic[@"contentInfo"];
                    if (!self.programSeriesId) {
                        self.programSeriesId = contentInfoDic[@"programSeriesId"];
                        self.categoryId = contentInfoDic[@"categoryId"];
                    }
                    if ([self live:contentInfoDic]&&[dic[@"contentType"] isEqualToString:@"live"]) {
                        self.programSeriesId = contentInfoDic[@"programSeriesId"];
                        self.categoryId = contentInfoDic[@"categoryId"];
                        [self loadContentData:dic];
                        isLoad = YES;
                       // break;
                    }
                }
                if (!isLoad) {
                    for (NSDictionary *dic in (NSArray *)contentDic) {
                        // [self loadContentData:dic];
                        NSDictionary* contentInfoDic = dic[@"contentInfo"];
                        if (!self.programSeriesId) {
                            self.programSeriesId = contentInfoDic[@"programSeriesId"];
                            self.categoryId = contentInfoDic[@"categoryId"];
                        }
                        if (![dic[@"contentType"] isEqualToString:@"live"]) {
                            self.programSeriesId = contentInfoDic[@"programSeriesId"];
                            self.categoryId = contentInfoDic[@"categoryId"];
                            [self loadContentData:dic];
                            isLoad = YES;
                           // break;
                        }
                    }
                }
                if (!isLoad) {
                    [self loadContentData:[dict[@"content"] firstObject]];
                }

            }
            else{
                [self loadContentData:dict[@"content"]];
            }
        }
        
    }
    return self;
}
-(BOOL)live:(NSDictionary *)dict{
    NSString *stamp = [Utils nowTimeString];
    long long date = [stamp longLongValue]*1000;
    if (date >=[dict[@"startTime"] longLongValue] && date <= [dict[@"endTime"] longLongValue]) {
        return YES;
    }
    return NO;
}
-(void)loadContentData:(NSDictionary*)dict{
    self.contentId = dict[@"contentId"];
    self.contentType = dict[@"contentType"];
    NSDictionary* contentInfoDic = dict[@"contentInfo"];
    self.categoryId = contentInfoDic[@"categoryId"];
    self.channelLogo = contentInfoDic[@"channelLogo"];
    self.channelName = contentInfoDic[@"channelName"];
    self.startTime = [contentInfoDic[@"startTime"] doubleValue]/1000;
    self.endTime = [contentInfoDic[@"endTime"] doubleValue]/1000;
    self.programSeriesDesc = contentInfoDic[@"programSeriesDesc"];
    self.programSeriesId = contentInfoDic[@"programSeriesId"];
    self.programSeriesName = contentInfoDic[@"programSeriesName"];
    self.programSeriesType = contentInfoDic[@"programSeriesType"];
    self.setNumber = contentInfoDic[@"setNumber"];
    self.setNumberWord = contentInfoDic[@"setNumberWord"];
    self.channelUuid = contentInfoDic[@"channelUuid"];
    self.url = contentInfoDic[@"url"];
    self.package = contentInfoDic[@"package"];
    //self.class = contentInfoDic[@"class"];
    self.version = contentInfoDic[@"version"];
    self.downUrl = contentInfoDic[@"downUrl"];
    self.forceUpdate = contentInfoDic[@"forceUpdate"];
    self.param = contentInfoDic[@"param"];
}
- (NSString*) duration{
    if (self.startTime == 0 || self.endTime == 0) {
        return @"";
    }
    
    static NSDateFormatter* formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
    });
    return [NSString stringWithFormat:@"%@-%@",
            [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.startTime]],
            [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.endTime]]];
}
//-(void)setProgramSeriesId:(NSString *)programSeriesId{
//    if ([programSeriesId isKindOfClass:[NSNumber class]]) {
//        _programSeriesId = [NSString stringWithFormat:@"%d",[programSeriesId intValue]];
//    }
//    _programSeriesId = programSeriesId;
//}
-(NSString *)programSeriesId{
    if ([_programSeriesId isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%d",[_programSeriesId intValue]];
    }
    return _programSeriesId;
}
@end
