//
//  President.h
//  Lesson10_Nav
//
//  Created by Qiang on 13-7-28.
//  Copyright (c) 2013年 XiaohuiQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPresidentNumberKey @"President"
#define kPresidentNameKey   @"Name"
#define kPresidentFromKey   @"FromYear"
#define kPresidentToKey     @"ToYear"
#define kPresidentPartyKey  @"Party"

@interface BIDPresident : NSObject<NSCoding>

@property (nonatomic,assign) int number;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *fromYear;
@property (nonatomic,copy) NSString *toYear;
@property (nonatomic,copy) NSString *party;

@end
