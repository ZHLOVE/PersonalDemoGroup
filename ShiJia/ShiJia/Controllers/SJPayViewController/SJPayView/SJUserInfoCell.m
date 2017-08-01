//
//  SJUserInfoCell.m
//  ShiJia
//
//  Created by 峰 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJUserInfoCell.h"

@implementation SJUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.userHeadImage.layer.cornerRadius = 45/2;
    self.userHeadImage.layer.borderColor = UIColorHex(d8d8d8).CGColor;
    self.userHeadImage.layer.masksToBounds = YES;
    
    self.userName.text = [HiTVGlobals sharedInstance].nickName;
    self.userPhone.text = [HiTVGlobals sharedInstance].phoneNo;
    [self.userHeadImage setImageWithURL:[NSURL URLWithString:[HiTVGlobals sharedInstance].faceImg] placeholderImage:[UIImage imageNamed:LIGHTHEADICON]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
