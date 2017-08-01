//
//  MyFriendsCell.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/24.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "MyFriendsCell.h"

@implementation MyFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.videoLab.textColor = kColorBlueTheme;
    self.headImg.layer.cornerRadius = self.headImg.frame.size.height/2;
    self.headImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(IBAction)friendDetail:(id)sender{
    if (self.m_delegate) {
        [self.m_delegate friendDetail:self.userEntity];
    }
}
-(IBAction)aimBtnClick:(id)sender{
    if (self.m_delegate) {
        [self.m_delegate aimFriend:self.userEntity];
    }
}
-(IBAction)watchClick:(id)sender{
    if (self.m_delegate) {
        [self.m_delegate watchFriendVideo:self.userEntity];
    }
}

@end
