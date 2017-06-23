//
//  Person.h
//  KVO_KVC_Play
//
//  Created by MBP on 2017/6/23.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface Person : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) Address *address;

@property(nonatomic,assign)  int num;

@end
