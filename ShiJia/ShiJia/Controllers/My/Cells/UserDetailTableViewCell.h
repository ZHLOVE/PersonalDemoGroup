//
//  UserDetailTableViewCell.h
//  HiTV
//
//  Created by wesley on 15/8/5.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet UIButton *bgbutton;

@end
