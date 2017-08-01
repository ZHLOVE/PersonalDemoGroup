//
//  SJVideoPlayerSeriesViewCell.m
//  ShiJia
//
//  Created by yy on 16/6/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoPlayerSeriesViewCell.h"
#import "CustomView.h"

NSString * const kSJVideoPlayerSeriesViewCellIdentifier = @"SJVideoPlayerSeriesViewCell";

@interface SJVideoPlayerSeriesViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *playImgView;
@property (nonatomic, strong) CustomView *customView;

@end

@implementation SJVideoPlayerSeriesViewCell

#pragma mark - Lifecycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"444444"].CGColor;
    
    _playImgView.hidden = YES;
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
    
    if (_text.length != 0) {
        _label.text = _text;
    }
}

- (void)setStyle:(SJVideoPlayerSeriesViewCellStyle)style
{
    _style = style;
    
    if (style == SJVideoPlayerSeriesViewCellStyleNormal) {
        
        //_label.hidden = NO;
        //_playImgView.hidden = YES;
        _label.textColor = [UIColor whiteColor];
    }
    else if(style == SJVideoPlayerSeriesViewCellStylePlaying){
        
        //_label.hidden = YES;
       // _playImgView.hidden = NO;
        _label.textColor = kColorBlueTheme;
    }
    else{
        _label.textColor = [UIColor lightGrayColor];
    }
    
    if (_text.length != 0) {
        _label.text = _text;
    }
    
}
//角标设置
-(void)setModel:(id)model{
    _customView.sizeToWidth = 30;
    [_customView useViewCorners:model];
}
@end
