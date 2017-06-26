//
//  Chileren.h
//  关于内存
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Father.h"

@interface Children : NSObject

@property (nonatomic,copy) NSString *name;

// 父亲对象不属于小孩 所以应该用弱引用
// 采用若引用,一旦父亲本身不在了,这个指针会自动设置为空
@property (nonatomic,weak) Father *myFather;

- (void)printMyFamilyInfo;

@end
