//
//  VideoCategory.h
//  HiTV
//
//  created by iSwift on 3/7/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  视频分类
 */
@interface VideoCategory : NSObject

@property (nonatomic, strong) NSString* actionUrl;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* cetegoryId;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* innerImgUrl;
@property (nonatomic, strong) NSString* isNew;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* outImgUrl;
@property (nonatomic, strong) NSString* parentId;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* vip;

@property (nonatomic, strong) NSArray* recommandedVideosArray;
@property (nonatomic, strong) NSArray* subCategoriesArray;
@property (nonatomic, strong) NSMutableArray* videos;

/*
 *   viper
 */
@property (nonatomic, strong) NSString* catgActionType;
@property (nonatomic, strong) NSString* catgId;
@property (nonatomic, strong) NSString* catgName;
@property (nonatomic, strong) NSString* childStyle;
@property (nonatomic, strong) NSString* image;
@property (nonatomic, strong) NSString* outerImg;
@property (nonatomic, strong) NSString* parentCatgId;
@property (nonatomic, strong) NSString* action; //用于优惠券内部跳转
@property (nonatomic, strong) NSString* index;


- (instancetype)initWithDictionary:(NSDictionary*)dict;

@property (nonatomic) BOOL shouldRetryGetRecommandedList;

@end
