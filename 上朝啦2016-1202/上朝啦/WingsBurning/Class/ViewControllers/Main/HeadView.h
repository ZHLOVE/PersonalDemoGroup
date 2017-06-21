//
//  HeadView.h
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseView.h"
@interface HeadView : BaseView

/**
 *  雇员信息
 */
@property(nonatomic,strong) EmployeeM *employee;
/**
 *  雇主信息
 */
@property(nonatomic,strong) EmployerM *employer;

@end
