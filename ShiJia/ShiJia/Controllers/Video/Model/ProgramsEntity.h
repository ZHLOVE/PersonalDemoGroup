//
//  ProgramsEntity.h
//  HiTV
//
//  Created by 蒋海量 on 15/9/10.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgramsEntity : NSObject
@property (nonatomic, strong) NSString* playType;
@property (nonatomic, strong) NSString* datepoint;
@property (nonatomic, strong) NSString* programId;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end
