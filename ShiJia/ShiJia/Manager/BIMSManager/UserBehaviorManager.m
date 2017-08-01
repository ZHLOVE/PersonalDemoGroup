//
//  UserBehaviorManager.m
//  HiTV
//
//  Created by 蒋海量 on 16/1/8.
//  Copyright (c) 2016年 Lanbo Zhang. All rights reserved.
//

#import "UserBehaviorManager.h"
#import "HiTVGlobals.h"
#import "VideoSource.h"
#import "HiTVVideo.h"
#import "BaseAFHTTPManager.h"

@interface UserBehaviorManager ()
@property (nonatomic, strong) VideoSource *recentVideoSoure;

@end
@implementation UserBehaviorManager

+ (instancetype)sharedInstance{
    static UserBehaviorManager *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}
-(void)uploadWatching:(NSDictionary *)dictionary{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid  forKey:@"oprUids"];
    [parameters setValue:@"MOBILE" forKey:@"deviceType"];
    
    NSString *pointString = [dictionary objectForKey:@"pointString"];
    [parameters setValue:pointString forKey:@"second"];
    
    NSString *playerType = [dictionary objectForKey:@"playerType"];

    HiTVVideo *hitvideo = [dictionary objectForKey:@"HiTVVideo"];
    VideoSource *videoSouce = [dictionary objectForKey:@"VideoSource"];
    
    if([playerType isEqualToString:@"onDemand"]){
        [parameters setValue:@"1" forKey:@"type"];
        [parameters setValue:hitvideo.videoID forKey:@"programSeriesId"];
        [parameters setValue:videoSouce.sourceID forKey:@"programId"];
        [parameters setValue:hitvideo.name forKey:@"programName"];
        [parameters setValue:hitvideo.videoID forKey:@"catg"];
        [parameters setValue:@"" forKey:@"channelUuid"];
        
    }
    else if([playerType isEqualToString:@"watchTV"]){
        WatchFocusVideoProgramEntity *entity = (WatchFocusVideoProgramEntity *)(videoSouce);
        if (entity.isLive) {
            [parameters setValue:@"3" forKey:@"type"];
            [parameters setValue:entity.uuid forKey:@"channelUuid"];
        }
        else {
            [parameters setValue:@"" forKey:@"channelUuid"];
            [parameters setValue:@"2" forKey:@"type"];
        }
        [parameters setValue:entity.catgId forKey:@"programSeriesId"];
        [parameters setValue:entity.programId forKey:@"programId"];
        [parameters setValue:entity.programName forKey:@"programName"];
        [parameters setValue:entity.catgId forKey:@"catg"];
    }
    BOOL Ing = [[dictionary objectForKey:@"Ing"] boolValue];

    if (!Ing) {
        [parameters setValue:@"99" forKey:@"type"];
    }
    
    [BaseAFHTTPManager postRequestOperationForHost:[HiTVGlobals sharedInstance].getUic forParam:@"/userservice/taipan/upload/watching" forParameters:parameters  completion:^(id responseObject) {
        
        
    }failure:^(NSString *error) {
    }];
}
/**
 *  查询观看纪录
 */
-(void)queryHistoryRecord:(NSDictionary *)dictionary{
    self.recentVideoSoure = nil;
    NSString *playerType = [dictionary objectForKey:@"playerType"];
    VideoSource *videoSouce = [dictionary objectForKey:@"VideoSource"];
    if([playerType isEqualToString:@"watchTV"]){
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
        [parameters setValue:@"watchtv" forKey:@"type"];
        WatchFocusVideoProgramEntity *entity = (WatchFocusVideoProgramEntity *)(videoSouce);
        
        [parameters setValue:entity.catgId forKey:@"objectid"];
        
        [BaseAFHTTPManager getRequestOperationForHost:[HiTVGlobals sharedInstance].getUic forParam:@"/integration/queryHistory" forParameters:parameters  completion:^(id responseObject) {
            NSArray *result = responseObject;
            if ([result count]>0) {
                NSString *josn = [[result objectAtIndex:0] objectForKey:@"titleData"];
                NSDictionary *titleData = [josn mj_JSONObject];
                VideoSource *videoSource = [[VideoSource alloc]init];
                
                videoSource.catgId = [titleData objectForKey:@"catgId"];
                videoSource.templateId = [titleData objectForKey:@"templateId"];
                videoSource.times = [titleData objectForKey:@"times"];
                videoSource.img = [titleData objectForKey:@"img"];
                videoSource.catgName = [titleData objectForKey:@"catgName"];
                videoSource.lastProgramId = [titleData objectForKey:@"lastProgramId"];
                videoSource.endWatchTime = [titleData objectForKey:@"endWatchTime"];
                videoSource.watchTime = [titleData objectForKey:@"watchTime"];
                NSMutableArray *programesArray = [NSMutableArray array];
                for (NSDictionary *programeDic in [titleData objectForKey:@"programes"]) {
                    //ProgramsEntity *programsEntity = [[ProgramsEntity alloc]initWithDict:programeDic];
                    [programesArray addObject:programeDic];
                }
                videoSource.programes = programesArray;
                
                self.recentVideoSoure = videoSource;
            }
            
        }failure:^(AFHTTPRequestOperation *operation,NSString *error) {
        }];
    }
}
/**
 *  添加观看纪录
 */
-(void)addHistoryRecord:(NSDictionary *)dictionary{
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];

    NSString *pointString = [dictionary objectForKey:@"pointString"];
    [parameters setValue:pointString forKey:@"second"];
    
    NSString *playerType = [dictionary objectForKey:@"playerType"];
    
    HiTVVideo *hitvideo = [dictionary objectForKey:@"HiTVVideo"];
    VideoSource *videoSouce = [dictionary objectForKey:@"VideoSource"];
    NSTimeInterval startWatchTime = [[dictionary objectForKey:@"startWatchTime"]longLongValue];
    startWatchTime = startWatchTime+[HiTVGlobals sharedInstance].timeIntervalDifferece;
    
    NSTimeInterval endWatchTime = [[NSDate date] timeIntervalSince1970];
    endWatchTime = endWatchTime+[HiTVGlobals sharedInstance].timeIntervalDifferece;

    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    
    if (![playerType isEqualToString:@"onDemand"]) {
        WatchFocusVideoProgramEntity *entity = (WatchFocusVideoProgramEntity *)(videoSouce);
        [parameters setValue:@"watchtv" forKey:@"type"];
        if (!entity.catgId) {
            return;
        }
        [parameters setValue:entity.catgId forKey:@"objectid"];
        [parameters setValue:@"0" forKey:@"detailsid"];
        
        NSMutableDictionary *titledata =  [NSMutableDictionary dictionary];
        [titledata setValue:[[HiTVGlobals sharedInstance]getLive_templateId] forKey:@"templateId"];
        long long times = [self.recentVideoSoure.times longLongValue];
        [titledata setValue:[NSString stringWithFormat:@"%lld",times+1] forKey:@"times"];
        [titledata setValue:entity.assortId forKey:@"assortId"];
        [titledata setValue:entity.name forKey:@"catgName"];
        if (entity.isLive) {
            [titledata setValue:entity.uuid forKey:@"catgId"];
        }
        else {
            [titledata setValue:entity.catgId forKey:@"catgId"];
        }

        [titledata setValue:[NSString stringWithFormat:@"%ld",(long)startWatchTime] forKey:@"startWatchTime"];
        [titledata setValue:[NSString stringWithFormat:@"%ld",(long)endWatchTime] forKey:@"watchTime"];
        [titledata setValue:entity.programId forKey:@"lastProgramId"];
        [titledata setValue:entity.smallimg forKey:@"img"];
        [titledata setValue:[NSString stringWithFormat:@"%ld",(long)endWatchTime] forKey:@"endWatchTime"];
        
        NSMutableDictionary *programDic = [NSMutableDictionary dictionary];
        [programDic setValue:entity.programId forKey:@"programId"];
        [programDic setValue:pointString forKey:@"datepoint"];
        [programDic setValue:entity.urlType forKey:@"playType"];
        
        //        ProgramsEntity *programEntity = [[ProgramsEntity alloc]init];
        //        programEntity.programId = entity.programId;
        //        programEntity.datepoint = pointString;
        //        programEntity.playType = entity.urlType;
        
        NSArray *programesArray = [self addProgram:programDic];
        
        [titledata setValue:programesArray forKey:@"programes"];
        
        NSString *jsonString = [titledata mj_JSONString];
        
        [parameters setValue:jsonString forKey:@"titledata"];
    }
    else{
        [parameters setValue:@"vod" forKey:@"type"];
        [parameters setValue:hitvideo.videoID forKey:@"objectid"];
        [parameters setValue:videoSouce.detailsid forKey:@"detailsid"];
        [parameters setValue:@"" forKey:@"watchtime"];
        [parameters setValue:@"" forKey:@"templateid"];
        
        NSMutableDictionary *titledata =  [NSMutableDictionary dictionary];
        [titledata setValue:@"sd" forKey:@"type"];
        [titledata setValue:hitvideo.picurl forKey:@"picurl"];
        [titledata setValue:hitvideo.name forKey:@"title"];
        [titledata setValue:hitvideo.actor forKey:@"actor"];
        [titledata setValue:hitvideo.director forKey:@"director"];
        [titledata setValue:hitvideo.action forKey:@"action"];
        [titledata setValue:hitvideo.actionUrl forKey:@"actionUrl"];
        
        NSString *jsonString = [titledata mj_JSONString];
        
        [parameters setValue:jsonString forKey:@"titledata"];
    }
    
    
    [BaseAFHTTPManager getRequestOperationForHost:WXSEEN  forParam:@"/integration/addHistory" forParameters:parameters  completion:^(id responseObject) {
        DDLogInfo(@"sus");
    }failure:^(AFHTTPRequestOperation *operation,NSString *error) {
        DDLogInfo(@"fail");
    }];
}
-(NSMutableArray *)addProgram:(NSDictionary *)program{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.recentVideoSoure.programes];
    BOOL have = NO;
    for (NSDictionary *programeDic in array) {
        if ([[programeDic objectForKey:@"programId"] isEqualToString:[program objectForKey:@"programId"]]) {
            [programeDic setValue:[program objectForKey:@"datepoint"] forKey:@"datepoint"];
            [programeDic setValue:[program objectForKey:@"playType"] forKey:@"playType"];
            have = YES;
        }
    }
    if (!have) {
        [array addObject:program];
    }
    return array;
}
@end
