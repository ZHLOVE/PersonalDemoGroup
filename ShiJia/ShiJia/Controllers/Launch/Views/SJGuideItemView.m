//
//  SJGuideItemView.m
//  ShiJia
//
//  Created by yy on 16/4/25.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "SJGuideItemView.h"

static CGFloat kLabelHeight  = 20.0;
static CGFloat kTopMargin    = 20.0;
static CGFloat kInnerPadding = 10.0;


@interface SJGuideItemView ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation SJGuideItemView

#pragma mark - Lifecycle
- (instancetype)initWithTitle:(NSString *)title
                   detailText:(NSString *)detailtext
                        image:(UIImage *)image
{
    self = [super init];
  
    if (self) {
        
        // title label
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = kBoldFontSizeLarge1;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        
        // detail label
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = kFontSizeMedium;
        _detailLabel.textColor = [UIColor colorWithHexString:@"CCCCCC"];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.text = detailtext;
        [self addSubview:_detailLabel];
        
        // image view
        _imgView = [[UIImageView alloc] init];
        _imgView.image = image;
        _imgView.contentMode = UIViewContentModeCenter;
        
        [self addSubview:_imgView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0,
                                   kTopMargin,
                                   self.frame.size.width,
                                   kLabelHeight);
    
    _detailLabel.frame = CGRectMake(0,
                                    _titleLabel.frame.size.height + _titleLabel.frame.origin.y + kInnerPadding,
                                    self.frame.size.width,
                                    kLabelHeight);
    
    _imgView.frame = CGRectMake(kInnerPadding,
                                _detailLabel.frame.size.height + _detailLabel.frame.origin.y + kInnerPadding,
                                self.frame.size.width - kInnerPadding * 2,
                                self.frame.size.height - _detailLabel.frame.size.height - _detailLabel.frame.origin.y - kInnerPadding);

}

@end
