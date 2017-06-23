//
//  Teacher.h
//  单例模式
//
//  Created by niit on 16/3/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"

@interface Teacher : NSObject

SingletonH(Teacher)
// =>
//+ (instancetype)shareTeacher;

@end
