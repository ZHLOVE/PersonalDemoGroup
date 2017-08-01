//
//  FriendsWatchCollectionViewCell.h
//  ShiJia
//
//  Created by 蒋海量 on 16/7/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchListEntity.h"
#import "WatchListCollectionViewCell.h"

@interface FriendsWatchCollectionViewCell : WatchListCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *channelLogo;
@property (weak, nonatomic) IBOutlet UILabel *channelName;
@property (weak, nonatomic) IBOutlet UILabel *programeName;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *reasonLab;
@property (weak, nonatomic) IBOutlet UILabel *liveLab;

@end
