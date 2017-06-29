//
//  Employees.h
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  注册信息模型
 */

@interface Employees : NSObject

@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *phone_number;
@property(nonatomic,copy) NSString *captcha;
@end
