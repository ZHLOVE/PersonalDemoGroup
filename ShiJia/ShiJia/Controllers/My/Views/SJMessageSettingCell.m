//
//  SJMessageSettingCell.m
//  ShiJia
//
//  Created by yy on 16/3/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJMessageSettingCell.h"
#import "SJSwitch.h"

static CGFloat kLeftMargin        = 20.0; // label左边距
static CGFloat kLabelHeight       = 20.0; // label高度
static CGFloat kSwitchWidth       = 55.0; // 开关宽度
static CGFloat kSwitchHeight      = 29.0; // 开关高度
static CGFloat kLineImgViewHeight = 1.0;  // 分割线高度

@interface SJMessageSettingCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) SJSwitch *rightSwitch;

@end

@implementation SJMessageSettingCell
{
    UIImageView *_lineImgView;
}

#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //label
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_label];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:12.0];
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
        
        // switch
        _rightSwitch = [[SJSwitch alloc] init];
//        _rightSwitch.on = self.SwitchOn;
        [_rightSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:_rightSwitch];
        
        
        _lineImgView = [[UIImageView alloc] init];
        _lineImgView.backgroundColor = kColorGraySeparator;
        [self.contentView addSubview:_lineImgView];
        
    }
    return self;

}
- (void)setTheSwitch:(BOOL)boolValue{
    self.rightSwitch.on = boolValue;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = CGRectMake( kLeftMargin,
                              (self.frame.size.height - kLabelHeight * 2)/2.0,
                              self.frame.size.width - 2 * kLeftMargin - kSwitchWidth,
                              kLabelHeight);
    
    _detailLabel.frame = CGRectMake(kLeftMargin, _label.frame.origin.y + _label.frame.size.height, _label.frame.size.width, kLabelHeight);
   
    _lineImgView.frame = CGRectMake( 0,
                                    self.frame.size.height - kLineImgViewHeight,
                                    self.frame.size.width,
                                    kLineImgViewHeight);
    
    _rightSwitch.frame = CGRectMake( self.frame.size.width - kSwitchWidth - kLeftMargin,
                                    (self.frame.size.height -  kSwitchHeight) / 2.0,
                                    kSwitchWidth,
                                    kSwitchHeight);
    
}

#pragma mark - Event
- (void)switchValueChanged:(SJSwitch *)sender
{
    if (self.switchValueChanged) {
        self.switchValueChanged(sender.isOn);
    }
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setText:(NSString *)text
{
    _text = text;
    _label.text = text;
}

- (void)setDetailText:(NSString *)detailText
{
    _detailText = detailText;
    _detailLabel.text = detailText;
}

@end
