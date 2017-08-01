//
//  TPIMMinAlertView.m
//  HiTV
//
//  Created by yy on 15/9/10.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPIMMinAlertView.h"
#import "Masonry.h"

static CGFloat const kButtonWidth = 80.0;
static CGFloat const kButtonHeight = 30.0;
static CGFloat const kTPIMMinAlertViewHeight = 45.0;

@interface TPIMMinAlertView ()

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;

@end

@implementation TPIMMinAlertView

#pragma mark - init
- (instancetype)initWithMessage:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle
{
    self = [super init];
    if (self) {
        //init subview
        [self setupSubviews];
        
        if ([message rangeOfString:@"</font>"].location != NSNotFound) {
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[message dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            [self.messageLabel setAttributedText:attrStr];
        }
        else{
            self.messageLabel.text = message;
        }
//        self.messageLabel.text = message;
        [self.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
        [self.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    }
    return self;
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //main view
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor blackColor];
    //    self.mainView.alpha = 0.7;
    [self addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
    }];
    
    
    //right button
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.rightButton setBackgroundColor:[UIColor colorWithRed:55/255.0 green:145/255.0 blue:212/255.0 alpha:1.0]];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
        make.right.equalTo(self.mainView).with.offset(-5);
        make.centerY.equalTo(self.mainView).with.offset(0);
    }];
    
    //left button
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.leftButton setBackgroundColor:[UIColor colorWithRed:55/255.0 green:145/255.0 blue:212/255.0 alpha:1.0]];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
        make.right.equalTo(self.rightButton.mas_left).with.offset(-10);
        make.centerY.equalTo(self.mainView).with.offset(0);
    }];
    
    
    
    //message
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.font = [UIFont systemFontOfSize:14.0];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    [self.mainView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView).with.offset(10);
        make.right.equalTo(self.leftButton.mas_left).with.offset(-10);
        make.top.equalTo(self.mainView).with.offset(0);
        make.bottom.equalTo(self.mainView).with.offset(0);
        
    }];
}

#pragma mark - show & hide
- (void)show
{
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview).with.offset(0);
        make.right.equalTo(self.superview).with.offset(0);
        make.top.equalTo(self.superview).with.offset(0);
        make.height.mas_equalTo(kTPIMMinAlertViewHeight);
        
    }];
    
}

- (void)hide
{
    [self removeFromSuperview];
}

#pragma mark - button clicked
- (void)leftButtonClicked:(id)sender
{
    if (self.leftButtonClickBlock) {
        self.leftButtonClickBlock();
    }
    [self hide];
}

- (void)rightButtonClicked:(id)sender
{
    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock();
    }
    [self hide];
}




@end
