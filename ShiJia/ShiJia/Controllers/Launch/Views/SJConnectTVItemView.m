//
//  SJConnectTVItemView.m
//  ShiJia
//
//  Created by yy on 16/4/26.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "SJConnectTVItemView.h"

static CGFloat kLabelHeight  = 90.0;
static CGFloat kInnerPadding = 10.0;
static CGFloat kLeftMargin   = 60.0;

@interface SJConnectTVItemView ()

@property (nonatomic, strong) UILabel     *label;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation SJConnectTVItemView

#pragma mark - Lifecycle
- (instancetype)initWithText:(NSString *)text
                        image:(UIImage *)image
{
    self = [super init];
    
    if (self) {
        
        // detail label
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:21];
        _label.textColor = [UIColor colorWithHexString:@"CCCCCC"];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = text;
        _label.numberOfLines = 10;
        [self addSubview:_label];
        
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
    
    
    _imgView.frame = CGRectMake(kInnerPadding,
                                0,
                                self.frame.size.width - 2 * kInnerPadding,
                                self.frame.size.height - kLabelHeight - kInnerPadding );
  
    _label.frame = CGRectMake(kLeftMargin,
                              _imgView.frame.size.height + _imgView.frame.origin.y + kInnerPadding,
                              self.frame.size.width - kLeftMargin * 2,
                              kLabelHeight);
    
}


@end
