//
//  TPVideoDetailCell.m
//  ShiJia
//
//  Created by yy on 16/6/24.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "TPVideoDetailCell.h"
#import "CustomView.h"
#import "WatchFocusVideoProgramEntity.h"
#import "VideoSource.h"

NSString * const kTPVideoDetailCellIdentifier = @"TPVideoDetailCell";

@interface TPVideoDetailCell ()

@property (nonatomic, weak) IBOutlet UIImageView *backImgView;
@property (nonatomic, weak) IBOutlet UIImageView *playImgView;

@property (nonatomic, strong) CustomView *customView;

@end

@implementation TPVideoDetailCell

#pragma mark - Lifecycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    _backImgView.layer.cornerRadius = 2.0;
    _backImgView.layer.masksToBounds = YES;
    [self resetCustomView];
}
-(void)resetCustomView{
    [_customView removeAllSubviews];
    _customView = nil;
    _customView = [[CustomView alloc]initWithFrame:self.frame];
    [self addSubview:_customView];
}
#pragma mark - Setter
- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
}

- (void)setStyle:(TPVideoDetailCellStyle)style
{
    _style = style;
    if (style == TPVideoDetailCellStyleNormal) {
        self.label.hidden = NO;
        self.playImgView.hidden = YES;
        self.label.text = _text;
        self.label.textColor = [UIColor darkGrayColor];
        self.label.backgroundColor = [UIColor clearColor];
    }
    else if (style == TPVideoDetailCellStyleHasPlayed) {
        self.label.hidden = NO;
        self.playImgView.hidden = YES;
        self.label.text = _text;
        self.label.textColor = kColorBlueTheme;
        self.label.backgroundColor = [UIColor clearColor];
    }
    else if (style == TPVideoDetailCellStyleCannotPlay) {
        self.label.hidden = NO;
        self.playImgView.hidden = YES;
        self.label.text = _text;
        self.label.textColor = [UIColor darkGrayColor];
        self.label.backgroundColor = RGB(226, 226, 226, 1);
    }
    else if (style == TPVideoDetailCellStylePlaying){
        self.label.hidden = NO;
        self.label.text = _text;
        self.playImgView.hidden = YES;
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = kColorBlueTheme;
    }
}
//角标设置
-(void)setModel:(id)model{
    _customView.sizeToWidth = 30;
    [_customView useViewCorners:model];
}

@end
