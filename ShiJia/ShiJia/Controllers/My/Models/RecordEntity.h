//
//  RecordEntity.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordEntity : NSObject
@property (nonatomic, strong) NSString *dateLine;
@property (nonatomic, strong) NSString *epgId;
@property (nonatomic, strong) NSString *feedId;
@property (nonatomic, strong) NSString *objtype;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *datePoint;
@property (nonatomic, strong) NSString *detailsId;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *templateId;
@property (nonatomic, strong) NSString *times;
@property (nonatomic, strong) NSString *watchTime;


@property (nonatomic, strong) NSString *boxuserid;
@property (nonatomic, strong) NSString *epgid;
@property (nonatomic, strong) NSString *objecactor;
@property (nonatomic, strong) NSString *objecdirector;
@property (nonatomic, strong) NSString *objectaction;
@property (nonatomic, strong) NSString *objectactionurl;
@property (nonatomic, strong) NSString *objectext;
@property (nonatomic, strong) NSString *objectid;
@property (nonatomic, strong) NSString *objectname;
@property (nonatomic, strong) NSString *objectparam;
@property (nonatomic, strong) NSString *objecttype;
@property (nonatomic, strong) NSString *opertype;
@property (nonatomic, strong) NSString *actor;
@property (nonatomic, strong) NSString *picurl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;


- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
