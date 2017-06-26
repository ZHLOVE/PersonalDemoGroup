//
//  School.h
//  NotificationDemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface School : NSObject

@property (nonatomic,copy) NSString *name;

- (instancetype)initWithName:(NSString *)n;
+ (instancetype)schoolWithName:(NSString *)n;

@end
