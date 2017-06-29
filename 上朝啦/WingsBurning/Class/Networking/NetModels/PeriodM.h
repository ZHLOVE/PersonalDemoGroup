//
//  PeriodM.h
//  WingsBurning
//
//  Created by MBP on 16/9/12.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChangeRule.h"
@interface PeriodM : NSObject

@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *begin_at;
@property(nonatomic,copy) NSString *end_at;
@property(nonatomic,copy) NSString *duration;
@property(nonatomic,strong) ChangeRule *rule;

@end
