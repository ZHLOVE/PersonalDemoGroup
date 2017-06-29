//
//  EmployerM.h
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  公司信息
 */
@interface EmployerM : NSObject

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *image_url;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *phone_number;
/**
 *  认证
 */
@property(nonatomic,copy)NSString *is_verified;
@end
