//
//  Man.h
//  KVODemo
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SalaryCard.h"

@interface Man : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) SalaryCard *card;

- (instancetype)initWithName:(NSString *)n;

@end
