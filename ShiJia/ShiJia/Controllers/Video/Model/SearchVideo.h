//
//  SearchVideo.h
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseVideo.h"

/**
 *  搜索模型
 */
@interface SearchVideo : BaseVideo

@property (nonatomic, strong) NSString* seriesId;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* classType;
@property (nonatomic, strong) NSString* createDate;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* definition;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
