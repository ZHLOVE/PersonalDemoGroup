//
//  Student.m
//  类
//
//  Created by niit on 15/12/25.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Student.h"

@implementation Student

- (void)printInfo
{
    NSLog(@"序号:%i 姓名:%@ 年龄:%i",self.stuId,self.stuName,self.stuAge);
}
@end
