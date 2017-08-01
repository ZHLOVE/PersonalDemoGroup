//
//  ChannelCell.h
//  HiTV
//
//  Created by 蒋海量 on 15/1/22.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//
//modify by jianghailiang 20150212 (.xib)

#import <UIKit/UIKit.h>

@interface ChannelCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UIImageView *channelImg;
@property (nonatomic, strong) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLab;
@property (nonatomic, strong) IBOutlet UIView *lineView;

@end
