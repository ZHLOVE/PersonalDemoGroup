//
//  CardView.h
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseView.h"

@interface CardView : BaseView

@property(nonatomic,strong) ContractM *contract;
@property(nonatomic,strong) EmployeeM *employee;


@property(nonatomic,strong) UIView *portraitImageRim;
@property(nonatomic,strong) UIImageView *portraitImage;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIImageView *compIcon;
@property(nonatomic,strong) UITextView *compLabel;
@property(nonatomic,strong) UIImageView *addressIcon;
@property(nonatomic,strong) UITextView *addressLabel;
@property(nonatomic,strong) UILabel *stateLabel;
@property(nonatomic,strong) UILabel *cardLabel;

@end
