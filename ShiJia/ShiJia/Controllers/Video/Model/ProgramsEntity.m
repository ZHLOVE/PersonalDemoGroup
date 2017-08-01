//
//  ProgramsEntity.m
//  HiTV
//
//  Created by 蒋海量 on 15/9/10.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "ProgramsEntity.h"

@implementation ProgramsEntity
- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.playType = dict[@"playType"];
        self.datepoint = dict[@"datepoint"];
        self.programId = dict[@"programId"];
        
    }
    return self;
}
@end
