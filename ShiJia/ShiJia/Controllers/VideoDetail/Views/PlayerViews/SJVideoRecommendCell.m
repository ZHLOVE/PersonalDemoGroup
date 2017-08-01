//
//  SJVideoRecommendCell.m
//  ShiJia
//
//  Created by yy on 16/6/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoRecommendCell.h"
#import "WatchListEntity.h"

//#import "SJVideoRecommendModel.h"
//#import "SJVideoRecommendItemModel.h"
//#import "SJVideoRecommendContentInfoModel.h"

NSString * const kSJVideoRecommendCellIdentifier = @"SJVideoRecommendCell";

@interface SJVideoRecommendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SJVideoRecommendCell

#pragma mark - Lifecycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Public
- (void)showData:(WatchListEntity *)data
{
    [_videoImgView setImageWithURL:[NSURL URLWithString:data.verticalPosterAddr] placeholder:[UIImage imageNamed:@"default_image"]];
    
    if (data.verticalPosterAddr.length == 0) {
        [_videoImgView setImageWithURL:[NSURL URLWithString:data.posterAddr] placeholder:[UIImage imageNamed:@"default_image"]];
    }
    
    if (data.programSeriesName.length > 0) {
        
        _nameLabel.text = data.programSeriesName;
    }
    else{
        _nameLabel.text = data.reason;
    }
    
}

@end
