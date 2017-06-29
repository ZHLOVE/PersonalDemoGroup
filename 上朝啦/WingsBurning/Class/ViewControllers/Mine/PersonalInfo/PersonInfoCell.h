//
//  PersonInfoCell.h
//  WingsBurning
//
//  Created by MBP on 2016/12/20.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PersonInfoCell : BaseTableViewCell

@property(nonatomic,strong) EmployeeM *employee;
@property(nonatomic,strong) UIImageView *porInfoImgView;

@end
