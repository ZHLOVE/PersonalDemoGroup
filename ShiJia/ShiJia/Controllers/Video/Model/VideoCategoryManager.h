//
//  VideoCategoryManager.h
//  HiTV
//
//  created by iSwift on 3/7/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  视频类别管理
 */
@interface VideoCategoryManager : NSObject

+ (instancetype)sharedInstance;

- (void) addResult:(NSDictionary*)dict;

@property (nonatomic, strong) NSArray* categories;

@property (nonatomic) int pageSize;
@property (nonatomic) int totalPage;
@property (nonatomic) int pageNumber;
@property (nonatomic) BOOL hasNextPage;

@end
