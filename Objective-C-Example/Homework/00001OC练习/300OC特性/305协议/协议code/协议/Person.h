//
//  Person.h
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SportProtocol.h"
#import "StudyProtocol.h"

// Person 支持这个协议

// 一个OC的类，只能继承自一个类，但是可以实现多个协议。
@interface Person : NSObject<SportProtocol,StudyProtocol>// 支持SportProtocol


@end
