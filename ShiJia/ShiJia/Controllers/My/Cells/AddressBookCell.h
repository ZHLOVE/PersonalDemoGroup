//
//  AddressBookCell.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/23.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@protocol AddressBookCellDelegate <NSObject>
- (void)invitationFriend:(UserEntity *)entity;

@end
@interface AddressBookCell : UITableViewCell
@property (nonatomic,strong) id <AddressBookCellDelegate> m_delegate;

@property(nonatomic,weak) IBOutlet UIImageView *headImg;
@property(nonatomic,weak) IBOutlet UILabel *nameLab;
@property(nonatomic,weak) IBOutlet UILabel *lab;

@property(nonatomic,weak) IBOutlet UILabel *telLab;
@property(nonatomic,weak) IBOutlet UIButton *invitationBtn;
@property(nonatomic,strong) UserEntity *userEntity;
@property(weak, nonatomic) IBOutlet UIImageView *line;

@end
