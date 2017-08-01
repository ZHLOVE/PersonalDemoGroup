//
//  VideoDataProvider.m
//  HiTV
//
//  created by iSwift on 3/7/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoDataProvider.h"
#import "AFNetworking.h"
#import "AFXMLDictionaryRequestSerializer.h"
#import "AFXMLDictionaryResponseSerializer.h"
#import "VideoCategoryManager.h"
#import "VideoSummary.h"
#import "HiTVVideo.h"
#import "VideoRelation.h"
#import "VideoCategory.h"
#import "BaseAFHTTPManager.h"

static NSString* const KVideoHost = @"http://epg.is.ysten.com:8080/";

@implementation VideoDataProvider

+ (instancetype)sharedInstance{
    static VideoDataProvider *sharedObject = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (void)getCategories:(int)catgId
           pageNumber:(int)page
           completion:(void (^)(id responseObject))success
              failure:(void (^)(NSString *error))failure{
    [self requestJsonWithParameter:[NSString stringWithFormat:@"epg/web/3.0/getcatgitemlist.json?templateId=%@&catgItemId=%d&pageNumber=%d&pageSize=100", [HiTVGlobals sharedInstance].getEpg_groupId,catgId, page]
                           forHost:[HiTVGlobals sharedInstance].getEpg_30
                        completion:^(id responseObject) {
                            [[VideoCategoryManager sharedInstance] addResult:responseObject];
                            success(responseObject);
                        } failure:failure];
}
/*
 推荐请求
 */
- (void)getTopRecommendlistWithCompletion:(void (^)(id responseObject))success
                                  failure:(void (^)(NSString *error))failure{
    [self requestXMLWithParameter:[HiTVGlobals sharedInstance].getRecommend
                          forHost:@""
                       completion:^(id responseObject) {
                           NSArray* menus = responseObject[@"Menus"][@"menu"];
                           success([self p_parseVideos:menus]);
                       } failure:failure];
    
}

- (AFHTTPRequestOperation*)getRecommendlistWithCategoryID:(NSString *)categoryID
                                               completion:(void (^)(id responseObject))success
                                                  failure:(void (^)(NSString *error))failure{
    return [self requestJsonWithParameter:[NSString stringWithFormat:@"epg/web/program!getMovieList.json?catgItemId=%@&templateId=%@&pageNumber=0&pageSize=3",categoryID, [HiTVGlobals sharedInstance].getEpg_groupId]
                                  forHost:[HiTVGlobals sharedInstance].getEpg_30
                               completion:^(id responseObject) {
                                   NSArray* menus = responseObject[@"programSeries"];
                                   success([self p_parseVideos:menus]);
                               } failure:failure];
}

- (void)getSubCategoriesWithCatgItemId:(NSString *)catgItemId
                            completion:(void (^)(id responseObject))success
                               failure:(void (^)(NSString *error))failure{
    [self requestJsonWithParameter:[NSString stringWithFormat:@"epg/web/3.0/getcatgiteminfo.json?templateId=%@&catgItemId=%@&pageNumber=1&pageSize=100",[HiTVGlobals sharedInstance].getEpg_groupId,catgItemId]
                           forHost:[HiTVGlobals sharedInstance].getEpg_30
                        completion:^(id responseObject) {
                            NSArray* categories = responseObject[@"catgItems"];
                            NSMutableArray* resultCategories = [[NSMutableArray alloc] init];
                            for (NSDictionary* categoryDict in categories) {
                                [resultCategories addObject:[[VideoCategory alloc] initWithDictionary:categoryDict]];
                                
                            }
                            success(resultCategories);
                        } failure:failure];
}

- (void)getVideosWithActionURL:(NSString*)actionURL
                    completion:(void (^)(id responseObject, int currentPageNumber, BOOL hasMore))success
                       failure:(void (^)(NSString *error))failure{

    [self requestJsonWithParameter:actionURL
                          forHost:@""
                       completion:^(id responseObject) {
                           NSArray* categories = responseObject[@"programSeries"];
                          // NSDictionary* pageInfo = responseObject[@"pageInfo"];
                           
                           BOOL hasMore = YES;
                           int currentPageNumber = [[(NSDictionary *)responseObject objectForKey:@"pageNumber"] intValue];
                           success([self p_parseVideos:categories], currentPageNumber, hasMore);
                       } failure:failure];
    
}

- (AFHTTPRequestOperation*)getVideo:(NSString*)programSeriesId
                         completion:(void (^)(id responseObject))success
                            failure:(void (^)(NSString *error))failure{
   // NSString* newActionURL = [actionURL stringByReplacingOccurrencesOfString:@"templateId=4" withString:@"templateId=61"];
    return [self requestJsonWithParameter:[NSString stringWithFormat:@"epg/web/3.0/movieDetail.json?programSeriesId=%@&templateId=%@&numbers=%@&catgItemId=%@&programId=%@&mediaId=%@",programSeriesId,[HiTVGlobals sharedInstance].getEpg_groupId,@"",@"",@"",@""]
                                 forHost:[HiTVGlobals sharedInstance].getEpg_30
                              completion:^(id responseObject) {
                                  HiTVVideo* video = [[HiTVVideo alloc] initWithDict:responseObject];
                                  success(video);
                              } failure:failure];
    
}

- (void)getRelation:(NSString*)actionURL
         completion:(void (^)(id responseObject))success
            failure:(void (^)(NSString *error))failure{
    [self requestXMLWithParameter:actionURL
                          forHost:@""
                       completion:^(id responseObject) {
                           NSArray* results = responseObject[@"Menus"][@"menu"];
                           
                           NSMutableArray* returnResults = [[NSMutableArray alloc] initWithCapacity:results.count];
                           
                           if ([results isKindOfClass:[NSDictionary class]]) {
                               [returnResults addObject:[[VideoRelation alloc] initWithDict:(NSDictionary*)results]];
                           }else{
                               for (NSDictionary* dict in results) {
                                   [returnResults addObject:[[VideoRelation alloc] initWithDict:dict]];
                               }
                           }
                           success(returnResults);
                       } failure:failure];
}


- (NSArray*)p_parseVideos:(id)responseObject{
    NSMutableArray* returnMenus = [[NSMutableArray alloc] init];
    if ([responseObject isKindOfClass:[NSArray class]]) {
        for (NSDictionary* aMenu in responseObject) {
            [returnMenus addObject:[[VideoSummary alloc] initWithDict:aMenu]];
        }
    }else{
        [returnMenus addObject:[[VideoSummary alloc] initWithDict:(NSDictionary*)responseObject]];
    }
    return returnMenus;
}

@end
