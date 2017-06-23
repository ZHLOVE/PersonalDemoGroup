//
//  Student.h
//  单例模式
//
//  Created by niit on 16/3/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject<NSCopying>

@property (nonatomic,copy) NSString *name;

+ (Student *)shareStudent;

@end
