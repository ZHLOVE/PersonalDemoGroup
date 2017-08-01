//
//  RecentTableViewCell.h
//  HiTV
//
//  Created by cs090_jzb on 15/8/10.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentVideo.h"
extern NSString *const cRecentListCellID;
@protocol RecentTableViewCellDelegate <NSObject>
- (void)deleteRecentVideo:(RecentVideo *)entity;

@end
@interface RecentTableViewCell : UITableViewCell
@property (nonatomic,strong) id <RecentTableViewCellDelegate> m_delegate;

@property (weak, nonatomic) IBOutlet UIImageView *fitVideoImg;
@property (weak, nonatomic) IBOutlet UILabel     *offlineTag;
@property (weak, nonatomic) IBOutlet UILabel     *titleLab;
@property (weak, nonatomic) IBOutlet UILabel     *videoName;
@property (weak, nonatomic) IBOutlet UILabel     *watchTime;
@property (weak, nonatomic) IBOutlet UILabel     *fWatchTime;

@property (weak, nonatomic) IBOutlet UIButton    *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton    *selectedBgBtn;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTitleLabel;

@property (strong, nonatomic) RecentVideo *recentVideo;

@end
