//
//  AppLogin.h
//  logDemo
//
//  Created by MccRee on 2017/7/21.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

@interface AppLogin : EventModel

/**
 登陆结果《移动端状态类型定义》
 */
@property(nonatomic,assign)  int result;

/**
 备注信息
 */
@property(nonatomic,strong) NSString *remark;
@end
