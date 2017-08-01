//
//  VideoCategoryManager.m
//  HiTV
//
//  created by iSwift on 3/7/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoCategoryManager.h"
#import "VideoCategory.h"

@interface VideoCategoryManager()

@end
@implementation VideoCategoryManager

+ (instancetype)sharedInstance{
    static VideoCategoryManager *sharedObject = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init{
    if (self = [super init]) {
        self.categories = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addResult:(NSDictionary*)dict{
    self.categories = nil;
    self.pageSize = [dict[@"pageSize"] intValue];
    self.pageNumber = [dict[@"pageNumber"] intValue];
    self.totalPage = [dict[@"count"] intValue];
    self.hasNextPage = (self.pageNumber < self.totalPage);
    
    if (self.pageNumber == 0) {
        self.categories = [[NSMutableArray alloc] init];
    }
    NSArray* categories = dict[@"catgItems"];
    if (categories != nil) {
        NSMutableArray* resultCategories = [NSMutableArray arrayWithArray:self.categories];
        if ([categories isKindOfClass:[NSArray class]]) {
            for (NSDictionary* videoCategory in categories) {
                NSArray *channelIdList = [[HiTVGlobals sharedInstance].offline_COLUMN componentsSeparatedByString:NSLocalizedString(@",", nil)];
                NSString *catgId = [NSString stringWithFormat:@"%@",videoCategory[@"catgId"]];
                BOOL IsOffline = [channelIdList containsObject:catgId];
                
                if (!IsOffline) {
                    VideoCategory *entity = [[VideoCategory alloc] initWithDictionary:videoCategory];
                    [resultCategories addObject:entity];
                }
               // [resultCategories addObject:[[VideoCategory alloc] initWithDictionary:videoCategory]];
            }
        }else{
            [resultCategories addObject:[[VideoCategory alloc] initWithDictionary:(NSDictionary*)categories]];
        }
        self.categories = resultCategories;
    }
}

@end
