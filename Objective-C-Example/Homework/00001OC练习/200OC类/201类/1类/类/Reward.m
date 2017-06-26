//
//  Reward.m
//  类
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Reward.h"

@implementation Reward

- (int)sum
{
    return self.english+self.math+self.chinese;
}

- (int)average
{
    return [self sum]/3;
}

- (void)printInfo
{
    // 如:10001 小明 英语:100  数学:90 语文:80 总分:270 平均分:90
//    NSLog(@"%i %@ 英语:%i 数学:%i 语文:%i 总分:%i 平均分:%i",self.stuId,self.stuName,self.english,self.math,self.chinese,[self sum],[self average]);
    
    NSLog(@"%i %@ 英语:%i 数学:%i 语文:%i 总分:%i 平均分:%i",self.stuId,self.stuName,self.english,self.math,self.chinese,self.sum,self.average);
}
@end
