//
//  Dog.h
//  关于内存
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject

@property (nonatomic,copy) NSString *name;

- (instancetype)initWithName:(NSString *)n;

@end
