//
//  PerCusCell.h
//  WingsBurning
//
//  Created by MBP on 2016/12/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PerCusCell : BaseTableViewCell

/**
 *  雇员信息
 */
@property(nonatomic,strong) EmployeeM *employee;
/**
 *  雇主信息
 */
@property(nonatomic,strong) EmployerM *employer;

@end
