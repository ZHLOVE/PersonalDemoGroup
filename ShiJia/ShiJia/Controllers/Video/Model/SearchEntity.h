//
//  TipsEntity.h
//  ShiJia
//
//  Created by 蒋海量 on 16/7/15.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchEntity : NSObject
@property (nonatomic, strong) NSString* bitrate;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* grade;
@property (nonatomic, strong) NSString* hlContent;
@property (nonatomic, strong) NSString* hlPosition;
@property (nonatomic, strong) NSString* Id;
@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* playCounts;
@property (nonatomic, strong) NSString* ppvId;
@property (nonatomic, strong) NSString* programType;
@property (nonatomic, strong) NSString* searchType;
@property (nonatomic, strong) NSArray* cornerArray;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
