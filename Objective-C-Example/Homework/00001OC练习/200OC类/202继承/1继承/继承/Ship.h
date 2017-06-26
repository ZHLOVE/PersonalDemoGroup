//
//  Ship.h
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ship : NSObject

// 1 属性
@property (nonatomic,copy) NSString *name;//船名字
@property (nonatomic,assign) int speed;//航速

// 方法
- (void)printInfo;//打印船信息

@end
