//
//  Person.h
//  字典
//
//  Created by niit on 16/1/5.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic,strong) NSNumber *tel;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *address;

- (instancetype)initWithTel:(NSNumber *)t andName:(NSString *)n andAddress:(NSString *)a;

@end
