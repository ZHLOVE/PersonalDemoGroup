//
//  MyFriendsCell.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/24.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"
#import "RecentVideo.h"

@protocol MyFriendsCellDelegate <NSObject>
- (void)aimFriend:(UserEntity *)userEntity;
- (void)watchFriendVideo:(UserEntity *)userEntity;
- (void)friendDetail:(UserEntity *)userEntity;


@end
@interface MyFriendsCell : UITableViewCell
@property (nonatomic,strong) id <MyFriendsCellDelegate> m_delegate;
@property (nonatomic,strong) UserEntity *userEntity;

@property(nonatomic,weak) IBOutlet UIImageView *headImg;
@property(nonatomic,weak) IBOutlet UIImageView *wlogo;
@property(nonatomic,weak) IBOutlet UILabel *nameLab;

@property(nonatomic,weak) IBOutlet UILabel *videoLab;
@property(nonatomic,weak) IBOutlet UIButton *aimBtn;
@property(nonatomic,weak) IBOutlet UIButton *videocallBtn;

@end
