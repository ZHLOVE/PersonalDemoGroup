//
//  SJPayfilmTipView.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/3.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPayfilmTipView.h"
static CGFloat width = 100;

@interface SJPayfilmTipView ()
@property (nonatomic, strong) UIImageView *bg;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *buyBtn;

@property(nonatomic,assign) BOOL isMin;
@end

@implementation SJPayfilmTipView
#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        _bg = [[UIImageView alloc]init];
        _bg.image = [UIImage imageNamed:@"shoufeitsbg_full"];
        _bg.userInteractionEnabled = YES;
       // _bg.backgroundColor = RGB(0, 0, 0, .5);
        [self addSubview:_bg];
        
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:13.0];
        _label.textColor = [UIColor whiteColor];
        _label.text = @"付费内容，您可以试看前六分钟";
        //_label.textAlignment = NSTextAlignmentCenter;
        [_bg addSubview:_label];
        
        _buyBtn = [UIButton new];
        _buyBtn.backgroundColor = [UIColor clearColor];
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:RGB(241, 100, 74, 1) forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_buyBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bg addSubview:_buyBtn];
    }
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.showType == ShowTypeMin) {
        _bg.frame = CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height);
        _buyBtn.frame = CGRectMake(10, 0, 80, self.frame.size.height);
        _label.hidden = YES;
        _bg.image = [UIImage imageNamed:@"shoufeitsbg_min"];
        //_label.text = @"付费影片，您可以试看前六分钟";
        _label.textAlignment = NSTextAlignmentLeft;
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:RGB(241, 100, 74, 1) forState:UIControlStateNormal];
    }
    else if (self.showType == ShowTypeMax){
        _bg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _label.frame = CGRectMake(10, 0, 200, self.frame.size.height);
        _buyBtn.frame = CGRectMake(_label.frame.size.width+10, 0, 80, self.frame.size.height);
        _label.hidden = NO;
        _bg.image = [UIImage imageNamed:@"shoufeitsbg_full"];
        //_label.text = @"付费影片，您可以试看前六分钟";
        _label.textAlignment = NSTextAlignmentLeft;
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:RGB(241, 100, 74, 1) forState:UIControlStateNormal];
    }
    else{
         _bg.backgroundColor = RGB(0, 0, 0, .5);
        _bg.image = nil;
        _bg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _label.frame = CGRectMake(0, 90, self.frame.size.width, 30);
        _label.center = _bg.center;
        _label.hidden = NO;
        //_label.text = @"付费影片，观看完整版请购买";
        _label.textAlignment = NSTextAlignmentCenter;
        _buyBtn.frame = CGRectMake((self.frame.size.width-130)/2, _label.frame.origin.y+40, 130, 40);
        [_buyBtn setBackgroundImage:[UIImage imageNamed:@"video_detail_continue_btn"] forState:UIControlStateNormal];
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
}
-(void)setShowType:(ShowType)showType{
    _showType = showType;
    [self layoutSubviews];
}
#pragma mark - Event
- (void)buyBtnClicked
{
    if (self.buyButtonClickBlock) {
        self.buyButtonClickBlock();
    }
}
-(void)setTipMessage:(NSString *)message andBuyBtnTitle:(NSString *)title{
    _label.text = message;
    //[_buyBtn setTitle:title forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
