//
//  SJShareAlertView.m
//  ShiJia
//
//  Created by 峰 on 16/9/3.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJShareAlertView.h"
#import "UIImageView+WebCache.h"

@interface SJShareAlertView ()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonBackView;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertImageViewHeight;
@end

@implementation SJShareAlertView

+ (instancetype)alertViewDefault
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SJShareAlertView" owner:nil options:nil]firstObject];
}


- (void)awakeFromNib{

    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardFrame:)
     name:UIKeyboardWillChangeFrameNotification
     object:nil];

    self.alertView.layer.cornerRadius = 5.0;
    self.alertView.layer.masksToBounds = YES;
    self.titleLabel.text = @"提示";
    self.contentLabel.layer.cornerRadius = 5.f;
    self.deterColor = kColorBlueTheme;
}
-(void)TapAlertView:(id)sender{

    [self resignFirstResponder];
    [self removeFromSuperview];

}

- (void)keyboardFrame:(NSNotification*)notification
{

    //    CGRect rect = [[notification.userInfo
    //                    valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];


    self.alertView.frame = CGRectMake(self.alertView.frame.origin.x,
                                      self.alertView.frame.origin.y-50,
                                      self.alertView.frame.size.width,
                                      self.alertView.frame.size.height);

    [UIView animateWithDuration:0.8
                     animations:^{
                         //                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                     }];
}


- (void)show{

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];


    CATransition *animation = [CATransition  animation];
    animation.duration = 0.2f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype =kCATransitionFromTop;
    [self.layer addAnimation:animation forKey:@"animation1"];




    self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.center = window.center;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];



    self.titleLabel.text = self.title;
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.tintColor = [UIColor colorWithRGBHex:0x333333];


    if (self.showMessage) {
        self.contentLabel.hidden = YES;
    }


    if (!self.alertImageString&&self.alertImage==nil) {
        self.alertImageViewHeight.constant = 0;

    }else{
        if (self.alertImageString) {
            [self.alertImageView sd_setImageWithURL:[NSURL URLWithString:self.alertImageString] placeholderImage:[UIImage imageNamed:@"nophotos"]];
        }
        if (self.alertImage) {
            self.alertImageView.image = self.alertImage;
        }

    }
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.textColor = [UIColor colorWithRGBHex:0x666666];
    if (self.content.length > 0)
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.content];;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:8];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.content.length)];
        self.contentLabel.attributedText = attributedString;
    }


    CGFloat alertWidth = 270.;

    if (self.buttonTtileArray.count != 0)
    {
        CGFloat buttonWidth = alertWidth/self.buttonTtileArray.count;
        CGFloat buttonHeight = 44.0;
        for (int i = 0; i < self.buttonTtileArray.count;i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:15];

            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            if (i == 0)
            {
                if (self.cancelColor)
                {
                    [button setTitleColor:self.cancelColor forState:UIControlStateNormal];
                }
            }
            else
            {
                if (self.deterColor)
                {

                    [button setTitleColor:self.deterColor forState:UIControlStateNormal];
                }else{
                    [button setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
                }
            }
            [button setTitle:self.buttonTtileArray[i] forState:UIControlStateNormal];
            button.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, buttonHeight);
            [button setTag:i];
            [button addTarget:self action:@selector(clickButtonButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonBackView addSubview:button];
            if (i>0) {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(i*buttonWidth, 0, 0.5, 44)];
                lineView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
                [self.buttonBackView addSubview:lineView];

                [self bringSubviewToFront:lineView];
            }

        }
    }

}
- (void)clickButtonButton:(UIButton *)sender{
    if (_alertBlock) {
        self.alertBlock(sender,self.contentLabel.text);
    }

    CATransition *animation = [CATransition  animation];
    animation.duration = 0.2f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self.layer addAnimation:animation forKey:@"animtion2"];
    [UIView animateWithDuration:0.2 animations:^{

    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//- (void)animationDidStart:(CAAnimation *)anim
//{}
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{}
@end
