//
//  TVDataProvider.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "TVDataProvider.h"
#import "TVStation.h"
#import "TVStationDetail.h"

static NSString* const TVDataProviderHost = @"http://phoneepg.is.ysten.com:8080/";
@implementation TVDataProvider

+ (instancetype)sharedInstance{
    static TVDataProvider *sharedObject = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (void)getTVListWithCompletion:(void (^)(id responseObject))success
                        failure:(void (^)(NSString *error))failure{
    static NSArray* KChannelList = nil;
    if (KChannelList == nil) {
        KChannelList = @[
                         @"cctv-1",
                         @"cctv-2",
                         @"cctv-3",
                         @"cctv-5",
                         @"cctv-6",
                         @"cctv-8",
                         @"cctv-13",
                         @"jiangxistv",
                         @"anhuistv",
                         @"dongfangstv",
                         @"fhzixun",
                         @"hunanstv",
                         @"jiangsustv",
                         @"zhejiangstv",
                         @"youmankaton"
                         ];
    }
    
    [self requestJsonWithParameter:[NSString stringWithFormat:@"epg/phone/getChannels.shtml?templateId=%@&sortorder=desc",[HiTVGlobals sharedInstance].getLiveepg_groupId]
                           forHost:LIVE_HOST
                        completion:^(id responseObject) {
                            NSMutableArray* tvStations = [[NSMutableArray alloc] initWithCapacity:[(NSArray*)responseObject count]];
                            [NSUserDefaultsManager saveObject:responseObject forKey:CHANNELLIST];

                            for (NSDictionary* dict in responseObject) {
                                //if ([KChannelList containsObject:dict[@"uuid"]]) {
                                   // [tvStations addObject:[[TVStation alloc] initWithDictionary:dict]];
                               // }
                                TVStation *tvStation = [[TVStation alloc] initWithDictionary:dict];
                                
                                NSArray *channelIdList = [[HiTVGlobals sharedInstance].offline_CHANNEL componentsSeparatedByString:NSLocalizedString(@",", nil)];
                                BOOL IsOffline = [channelIdList containsObject:tvStation.uuid];
                                
                                if (!IsOffline) {
                                    [tvStations addObject:tvStation];
                                    
                                }
                            }
                            success(tvStations);
                        } failure:failure];
}

- (void)getProgramListForUUID:(NSString*)tvUUID
                   completion:(void (^)(id responseObject))success
                      failure:(void (^)(NSString *error))failure{
    [self requestJsonWithParameter:[NSString stringWithFormat:@"epg/phone/getAllDayPrograms.shtml?templateId=%@&uuid=%@&sortorder=desc",[HiTVGlobals sharedInstance].getLiveepg_groupId,tvUUID]
                           forHost:LIVE_HOST
                        completion:^(id responseObject) {
                            NSMutableArray* tvPrograms = [[NSMutableArray alloc] init];
                            for (NSDictionary* dict in responseObject) {
                                TVStationDetail* detail = [[TVStationDetail alloc] initWithDictionary:dict];
                                [tvPrograms addObject:detail];
                            }
                            [tvPrograms sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"playDateDouble" ascending:YES]]];
                            success(tvPrograms);
                        } failure:failure];
    
}
//modify by jianghailiang 20150130
- (void)getProgramListForUUIDFromBox:(NSString*)tvUUID
                   completion:(void (^)(id responseObject))success
                      failure:(void (^)(NSString *error))failure{
    
    NSString *hostUrl = [HiTVGlobals sharedInstance].getProjection_live_domain;
    
    [self requestJsonWithParameter:[NSString stringWithFormat:@"epg/phone/getAllDayPrograms.shtml?templateId=0282&uuid=%@&sortorder=desc", tvUUID]
                           forHost:hostUrl
                        completion:^(id responseObject) {
                            NSMutableArray* tvPrograms = [[NSMutableArray alloc] init];
                            for (NSDictionary* dict in responseObject) {
                                TVStationDetail* detail = [[TVStationDetail alloc] initWithDictionary:dict];
                                [tvPrograms addObject:detail];
                            }
                            [tvPrograms sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"playDateDouble" ascending:YES]]];
                            success(tvPrograms);
                        } failure:failure];
    
}
//modify end

- (void)getServerTimeWithCompletion:(void (^)(id responseObject))success
                            failure:(void (^)(NSString *error))failure{
    [self requestJsonWithParameter:@"ysten-replay/getServerTime.jsp" forHost:LIVE_HOST completion:^(id responseObject) {
        NSTimeInterval serverTime = [responseObject[@"serverTime"] doubleValue];
        self.serverTimeOffset = [[NSDate date] timeIntervalSince1970] - serverTime;
    } failure:failure];
}

- (AFHTTPRequestOperation*)getCurrentProgram:(NSString*)uuid
                                  completion:(void (^)(id responseObject))success
                                     failure:(void (^)(NSString *error))failure{
    return [self requestJsonWithParameter:[NSString stringWithFormat:@"ysten-replay/getProgram.jsp?uuid=%@&action=cur", uuid]
                                  forHost:LIVE_HOST completion:^(id responseObject) {
                                      success(responseObject);
                                  } failure:failure];
    
}

- (AFHTTPRequestOperation*)getNextProgram:(NSString*)uuid
                                programID:(NSString*)programID
                               completion:(void (^)(id responseObject))success
                                  failure:(void (^)(NSString *error))failure{
    return [self requestJsonWithParameter:[NSString stringWithFormat:@"ysten-replay/getProgram.jsp?uuid=%@&curprogramId=%@&action=next", uuid, programID]
                                  forHost:LIVE_HOST completion:^(id responseObject) {
                                      success(responseObject);
                                  } failure:failure];
}

@end
