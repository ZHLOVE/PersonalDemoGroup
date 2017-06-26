//
//  Teacher.h
//  复制对象
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 声明支持NSCopying协议 复制协议
@interface Teacher : NSObject<NSCopying>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *depart;

@end
