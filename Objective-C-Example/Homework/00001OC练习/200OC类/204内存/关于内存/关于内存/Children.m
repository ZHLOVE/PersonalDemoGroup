//
//  Chileren.m
//  关于内存
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Children.h"

@implementation Children

- (void)printMyFamilyInfo
{
//    NSLog(@"%@",self.myFather);// 经测试,MacOS下命令行程序,这里会有Bug,weak指针没有自动设置为空.iOS下正常。
//    NSLog(@"%@",_myFather);
    
    if(_myFather != nil)
    {
        NSLog(@"我的名字叫%@,我父亲的名字是:%@",self.name,_myFather.name);
    }
    else
    {
        NSLog(@"我的名字叫%@,我父亲去世了.",self.name);
    }
}
@end
