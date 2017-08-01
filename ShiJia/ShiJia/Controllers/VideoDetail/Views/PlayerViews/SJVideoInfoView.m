//
//  SJVideoInfoView.m
//  ShiJia
//
//  Created by yy on 16/6/24.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoInfoView.h"

static CGFloat kLineImgWidth = 10.0;
static CGFloat kLineImgHeight = 16.0;
static CGFloat kLineImgOriginx = 10.0;
static CGFloat kLabelHeight = 20.0;
static CGFloat kFoldedLabelHeight = 20.0;
static CGFloat kLeftSpacing = 10.0;
static CGFloat kButtonWidth = 70.0;
static CGFloat kButtonHeight = 30.0;

@interface SJVideoInfoView ()
{
    UIImageView *_lineImgView;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *foldButton;
@property (nonatomic, assign) BOOL folded;
@property (nonatomic, assign) CGFloat actualLabelHeight;

@end

@implementation SJVideoInfoView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        
        _lineImgView = [[UIImageView alloc] init];
        //_lineImgView.backgroundColor = kColorBlueTheme;
        _lineImgView.image = [UIImage imageNamed:@"Triangle"];
        [self addSubview:_lineImgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"简介";
        [self addSubview:_titleLabel];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont systemFontOfSize:13.0];
        _infoLabel.textColor = [UIColor darkGrayColor];
//        _infoLabel.text = text;
        _infoLabel.numberOfLines = NSIntegerMax;
        [self addSubview:_infoLabel];
        
        _foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_foldButton setImage:[UIImage imageNamed:@"video_detail_down_arrow_btn"] forState:UIControlStateNormal];
//        [_foldButton setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
        [_foldButton setTitle:@" 展开" forState:UIControlStateNormal];
        [_foldButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_foldButton setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        [_foldButton addTarget:self action:@selector(foldButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_foldButton];
        
        self.folded = YES;
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.actualLabelHeight == 0 && self.frame.size.height > 0) {
        CGRect rect = [_infoLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - kLeftSpacing * 2, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_infoLabel.font,NSFontAttributeName, nil] context:nil];
        self.actualLabelHeight = rect.size.height;
        if (self.actualLabelHeight < kFoldedLabelHeight) {
            self.actualLabelHeight = kFoldedLabelHeight;
        }
        
    }
    
    _lineImgView.frame = CGRectMake(kLineImgOriginx, kLeftSpacing + (kLabelHeight - kLineImgHeight) / 2.0, kLineImgWidth, kLineImgHeight);
    
    _titleLabel.frame = CGRectMake(_lineImgView.frame.origin.x + kLineImgWidth + kLeftSpacing, kLeftSpacing, self.frame.size.width - kLeftSpacing * 2, kLabelHeight);
    
    if (self.folded) {
        _infoLabel.frame = CGRectMake(kLeftSpacing, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + kLeftSpacing, self.frame.size.width - kLeftSpacing * 2, kFoldedLabelHeight);
    }
    else{
        _infoLabel.frame = CGRectMake(kLeftSpacing, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + kLeftSpacing, self.frame.size.width - kLeftSpacing * 2, self.actualLabelHeight);
    }
    
    _foldButton.frame = CGRectMake(self.frame.size.width - kButtonWidth+4, _infoLabel.origin.y + _infoLabel.frame.size.height, kButtonWidth, kButtonHeight);
}

#pragma mark - Event
- (void)foldButtonClicked:(id)sender
{
    self.folded = !self.folded;
    
    if (self.folded) {
        [_foldButton setImage:[UIImage imageNamed:@"video_detail_down_arrow_btn"] forState:UIControlStateNormal];
        [_foldButton setTitle:@" 展开" forState:UIControlStateNormal];
        self.height = kLeftSpacing * 2 + kLabelHeight + kFoldedLabelHeight + kButtonHeight;
    }
    else{
        [_foldButton setImage:[UIImage imageNamed:@"video_detail_up_arrow_btn"] forState:UIControlStateNormal];
        [_foldButton setTitle:@" 收缩" forState:UIControlStateNormal];
        self.height = kLeftSpacing * 2 + kLabelHeight + self.actualLabelHeight + kButtonHeight;
    }
    [self setNeedsLayout];
}

#pragma mark - Setter & Getter
- (void)setInfo:(NSString *)info
{
    _info = info;
    _infoLabel.text = info;
    if (info.length == 0) {
        _infoLabel.text = @"无";
    }
    
//    if (self.actualLabelHeight == 0) {
        CGRect rect = [_infoLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - kLeftSpacing * 2, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_infoLabel.font,NSFontAttributeName, nil] context:nil];
        self.actualLabelHeight = rect.size.height;
        
//    }
    if (self.actualLabelHeight < kFoldedLabelHeight) {
        self.actualLabelHeight = kFoldedLabelHeight;
    }
    
    if (self.folded) {
        
        self.height = kLeftSpacing * 2 + kLabelHeight + kFoldedLabelHeight + kButtonHeight;
    }
    else{
        self.height = kLeftSpacing * 2 + kLabelHeight + self.actualLabelHeight + kButtonHeight;
    }
    [self setNeedsLayout];
    
}

- (CGFloat)height
{
    if (self.folded) {
        
        return kLeftSpacing * 2 + kLabelHeight + kFoldedLabelHeight + kButtonHeight;
    }
    else{
        return kLeftSpacing * 2 + kLabelHeight + self.actualLabelHeight + kButtonHeight;
    }
}

-(void) dealloc
{
    //[_foldButton removeAllTargets];
}
@end
