//
//  Reward.h
//  类
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 属性:
// 学号 姓名 英语 数学 语文 成绩
// 方法:
// 得到总分
// 得到平均分
// 打印学生成绩信息
// 如:10001 小明 英语:100  数学:90 语文:80 总分:270 平均分:90

@interface Reward : NSObject

@property (nonatomic,assign) int stuId;
@property (nonatomic,copy) NSString *stuName;
@property (nonatomic,assign) int english;
@property (nonatomic,assign) int math;
@property (nonatomic,assign) int chinese;

@property (nonatomic,assign) int sum;
@property (nonatomic,assign) int average;
//- (int)sum;
//- (int)average;

- (void)printInfo;


@end
