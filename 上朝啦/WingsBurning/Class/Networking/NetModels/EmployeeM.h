//
//  EmployeeM.h
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  注册成功后的雇员模型
 */
@interface EmployeeM : NSObject

/** id */
@property (copy, nonatomic) NSString *ID;
/** 头像地址 */
@property (copy, nonatomic) NSString *avatar_url;
/** 创建时间 */
@property (copy, nonatomic) NSString *created_at;
/** 姓名 */
@property (copy, nonatomic) NSString *name;
/** 电话号码 */
@property (copy, nonatomic) NSString *phone_number;

/** 拼音 */
@property (nonatomic,strong) NSString *pinyin;

@end
