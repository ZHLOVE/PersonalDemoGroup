//
//  Person.h
//  关于内存
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Dog.h"

@interface Person : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) Dog *myDog;// strong 指向自己的东西
@property (nonatomic,weak) Dog *neighbourDog;// weak 指向别人东西，用这个指针操作别人的对象,一旦那个对象没有强指针指向，则这个指针自动被置为空

- (instancetype)initWithName:(NSString *)n;

@end
