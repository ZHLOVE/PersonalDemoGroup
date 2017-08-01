//
//  AddressBookCell.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/23.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "AddressBookCell.h"

@implementation AddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.invitationBtn.layer.cornerRadius = 15;
    self.line.backgroundColor = [UIColor colorWithRed:209/255.0 green:210/255.0 blue:211/255.0 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)invitationBtnClick:(id)sender{
    if (self.m_delegate) {
        [self.m_delegate invitationFriend:self.userEntity];
    }
}

-(void)setUserEntity:(UserEntity *)userEntity{

    _userEntity = userEntity;
    if (userEntity.type.intValue == 1) {
        self.invitationBtn.backgroundColor = kColorBlueTheme;
        self.invitationBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.invitationBtn setTitle:@"添加" forState:UIControlStateNormal];
        [self.invitationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if (userEntity.type.intValue == 2){
        self.invitationBtn.backgroundColor = [UIColor whiteColor];

        self.invitationBtn.layer.borderWidth=1.0;
        self.invitationBtn.layer.borderColor = kColorBlueTheme.CGColor;
        [self.invitationBtn setTitle:@"邀请" forState:UIControlStateNormal];
        [self.invitationBtn setTitleColor:kColorBlueTheme forState:UIControlStateNormal];

    }
    else if (userEntity.type.intValue == 3){
        self.invitationBtn.backgroundColor = klightGrayColor;
        [self.invitationBtn setTitle:@"已添加" forState:UIControlStateNormal];
        self.invitationBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.invitationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    [self layoutIfNeeded];
}
@end
