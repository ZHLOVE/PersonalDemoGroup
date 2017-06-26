//
//  Person.h
//  谓词Demo
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int age;
@property (nonatomic,assign) int reward;

- (instancetype)initWithName:(NSString *)n andAge:(int)a andReward:(int)r;


@end
