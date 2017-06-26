//
//  Person.h
//  KVODemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Stock.h"

#import "StreetCorssLed.h"

@interface Person : NSObject

// 名字
@property (nonatomic,copy) NSString *name;

// 关注的股票
@property (nonatomic,weak) Stock *myStock;


@property (nonatomic,weak) StreetCorssLed *led;

- (instancetype)initWithName:(NSString *)n;


@end
