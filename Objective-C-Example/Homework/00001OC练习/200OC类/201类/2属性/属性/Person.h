//
//  Person.h
//  属性
//
//  Created by niit on 15/12/24.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
//    int age;
}

//- (void)setAge:(int)a;
//- (int)age;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int age;

// assign  => 基本类型
// copy    => NSString
// strong weak => 其他类的对象

//{
//    //    int age;
//}

- (void)printInfo;

@end
