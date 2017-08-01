//
//  SJSettingTableViewCell.m
//  ShiJia
//
//  Created by yy on 16/3/14.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJSettingCell.h"
#import "SJSwitch.h"

static CGFloat kLabelHeight       = 20.0;
static CGFloat kLeftMargin        = 20.0;
static CGFloat kSwitchWidth       = 55.0;
static CGFloat kSwitchHeight      = 29.0;
static CGFloat kLineImgViewHeight = 1.0;

@interface SJSettingCell ()
{
    UIImageView *_lineImgView;
    
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) SJSwitch *rightSwitch;

@end

@implementation SJSettingCell

#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //title label
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_titleLabel];
        
        //detail label
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:14.0];
        _detailLabel.adjustsFontSizeToFitWidth = YES;
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
        
        //line image view
        _lineImgView = [[UIImageView alloc] init];
        _lineImgView.backgroundColor = kColorGraySeparator;
        [self.contentView addSubview:_lineImgView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    CGFloat labelWidth = self.frame.size.width - kLeftMargin * 2 - kSwitchWidth;
    
    if (_detail.length == 0) {
        
        _titleLabel.frame = CGRectMake( kLeftMargin,
                                       (self.frame.size.height - kLabelHeight) / 2.0,
                                       labelWidth,
                                       kLabelHeight);
    }
    else{
        CGFloat originy = (self.frame.size.height - kLabelHeight * 2) / 2.0;
        _titleLabel.frame = CGRectMake( kLeftMargin,
                                        originy,
                                        labelWidth,
                                        kLabelHeight);
        
        _detailLabel.frame = CGRectMake( kLeftMargin,
                                         originy + kLabelHeight,
                                         labelWidth,
                                         kLabelHeight);
    }
    
    _lineImgView.frame = CGRectMake( 0,
                                     self.frame.size.height - kLineImgViewHeight,
                                     self.frame.size.width,
                                     kLineImgViewHeight);
    
    _rightSwitch.frame = CGRectMake( self.frame.size.width - kSwitchWidth - kLeftMargin+4,
                                     (self.frame.size.height -  kSwitchHeight) / 2.0,
                                     kSwitchWidth,
                                     kSwitchHeight);
}

#pragma mark - Event
- (void)switchValueChanged:(SJSwitch *)sender
{
    
    if (self.switchValueChanged) {
        self.switchValueChanged(sender.on);
    }
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowSwitch:(BOOL)showSwitch
{
    _showSwitch = showSwitch;
    if (showSwitch) {
        
        if (!_rightSwitch) {
            
            _rightSwitch = [[SJSwitch alloc] init];
            _rightSwitch.on = self.SwitchOn;
            [_rightSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:ASControlNodeEventTouchUpInside];
            [self addSubnode:_rightSwitch];
        }
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setDetail:(NSString *)detail
{
    _detail = detail;
    _detailLabel.text = detail;
}

@end
