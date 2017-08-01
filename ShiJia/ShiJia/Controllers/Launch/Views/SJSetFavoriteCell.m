//
//  SJSetFavoriteCell.m
//  ShiJia
//
//  Created by yy on 16/6/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJSetFavoriteCell.h"
#import "WatchListEntity.h"

NSString *kSJSetFavoriteCellIdentifier = @"SJSetFavoriteCell";

@interface SJSetFavoriteCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end

@implementation SJSetFavoriteCell

#pragma mark - Lifecycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (checked) {
        
        [_checkButton setImage:[UIImage imageNamed:@"guide_favorite_pre"] forState:UIControlStateNormal];

    }
    else{
        [_checkButton setImage:[UIImage imageNamed:@"guide_favorite_nor"]  forState:UIControlStateNormal];

    }
}

#pragma mark - Data
- (void)showData:(WatchListEntity *)data
{
    _label.text = data.programSeriesName;
    
    [_iconImgView setImageWithURL:[NSURL URLWithString:data.posterAddr] placeholderImage:[UIImage imageNamed:@"default_image"]];
    
    if (data.posterAddr.length == 0) {
        
        [_iconImgView setImageWithURL:[NSURL URLWithString:data.verticalPosterAddr] placeholderImage:[UIImage imageNamed:@"default_image"]];
    }
}

#pragma mark - Event
- (IBAction)checkButtonClicked:(id)sender
{
//    self.checked = !self.checked;
    if (self.checkButtonClickBlock) {
        self.checkButtonClickBlock(self);
    }
}

@end
