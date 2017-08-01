//
//  VideoCategory.m
//  HiTV
//
//  created by iSwift on 3/7/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoCategory.h"

@implementation VideoCategory

- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.actionUrl = dict[@"actionUrl"];
        self.code = dict[@"code"];
        self.icon = dict[@"icon"];
        self.cetegoryId = dict[@"id"];
        self.imageUrl = dict[@"imageUrl"];
        self.innerImgUrl = dict[@"innerImgUrl"];
        self.isNew = dict[@"isNew"];
        self.name = dict[@"name"];
        self.outImgUrl = dict[@"outImgUrl"];
        self.title = dict[@"title"];
        self.vip = dict[@"vip"];
        self.parentId = dict[@"parentId"];

        self.shouldRetryGetRecommandedList = YES;
        
        /*
         *   viper
         */
        self.catgActionType = dict[@"catgActionType"];
        self.catgId = dict[@"catgId"];
        self.catgName = dict[@"catgName"];
        self.childStyle = dict[@"childStyle"];
        self.image = dict[@"image"];
        self.outerImg = dict[@"outerImg"];
        self.parentCatgId = dict[@"parentCatgId"];
        if (self.catgId) {
            NSMutableArray* resultCategories = [NSMutableArray array];
            NSArray *subCatgsArray = dict[@"subCatgs"];
            if (![subCatgsArray.class isSubclassOfClass:[NSNull class]]) {
                for (NSDictionary *dic in subCatgsArray) {
                    [resultCategories addObject:[[VideoCategory alloc] initWithDictionary:dic]];
                }
                
            }
            
            self.subCategoriesArray = resultCategories;
        }

    }
    return self;
}

@end
