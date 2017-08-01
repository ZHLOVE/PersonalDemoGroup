//
//  SearchDataProvider.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "SearchDataProvider.h"
#import "SearchVideo.h"
#import "SearchEntity.h"

@implementation SearchDataProvider

+ (instancetype)sharedInstance{
    static SearchDataProvider *sharedObject = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (void)search:(NSString*)key
   keywordType:(NSString*)type
         start:(int)start
withCompletion:(void (^)(id responseObject))success
       failure:(void (^)(NSString *error))failure{
    [self requestJsonWithParameter:[NSString stringWithFormat:@"searchByTips.json?keywordType=%@&templateIds=%@&keyword=%@&psType=all&searchType=all&keywordFrom=input&STBext=%@&unionType=%@&start=%d&limit=20", type,[NSString stringWithFormat:@"%@,%@",[[HiTVGlobals sharedInstance]getEpg_groupId],WATCHTVGROUPID],key,T_STBext,@"1",start*20] forHost:SEARCH_HOST completion:^(id responseObject) {
        
        /*NSArray* results = responseObject[@"programSeries"];
        
        NSMutableArray* returnResults = [[NSMutableArray alloc] initWithCapacity:results.count];
        
        if ([results isKindOfClass:[NSDictionary class]]) {
            [returnResults addObject:[[SearchEntity alloc] initWithDict:(NSDictionary*)results]];
        }else{
            for (NSDictionary* dict in results) {
                [returnResults addObject:[[SearchEntity alloc] initWithDict:dict]];
            }
        }*/
        success(responseObject);
    } failure:failure];
}
- (void)getTipsWithCompletion:(void (^)(id responseObject))success
       failure:(void (^)(NSString *error))failure{
    NSString *tempIds = [NSString stringWithFormat:@"%@,%@",[HiTVGlobals sharedInstance].getEpg_groupId,WATCHTVGROUPID];
    [self requestJsonWithParameter:[NSString stringWithFormat:@"hotword.json?templateIds=%@&STBext=%@&unionType=1",tempIds,T_STBext] forHost:SEARCH_HOST completion:^(id responseObject) {
        
        NSArray *results = [responseObject[@"word"] componentsSeparatedByString:NSLocalizedString(@",", nil)];

        success(results);
    } failure:failure];
}

@end
