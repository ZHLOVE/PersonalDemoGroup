//
//  HotspotViewCell.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/22.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotDetailView.h"
#import "HotsVideoModel.h"

@protocol HotspotViewCellDelegate <NSObject>
- (void)shareCurrentVideo:(HotsVideoModel *)hotsVideoModel;

@end

@interface HotspotViewCell : UITableViewCell
@property (nonatomic,assign) id <HotspotViewCellDelegate> m_delegate;

@property (strong, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (nonatomic, strong) UIImageView *topBgView;
@property (nonatomic, strong) UIImageView *bottomBgView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (assign, nonatomic) BOOL showDetail;
@property (strong, nonatomic) HotsVideoModel *hotsVideoModel;

@end
