//
//  HotSpotAlertView.m
//  ShiJia
//
//  Created by 峰 on 2017/2/25.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "HotSpotAlertView.h"
#import "UIImageView+WebCache.h"
@interface HotSpotAlertView()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;


@end


@implementation HotSpotAlertView

+ (instancetype)alertViewDefault
{
    return [[[NSBundle mainBundle]loadNibNamed:@"HotSpotAlertView" owner:nil options:nil]firstObject];
}


- (void)awakeFromNib{

    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardFrame:)
     name:UIKeyboardWillChangeFrameNotification
     object:nil];

    self.mainView.layer.cornerRadius = 5.0;
    self.mainView.layer.masksToBounds = YES;
    self.titleLabel.text = @"提示";
//    self.contentLabel.layer.cornerRadius = 5.f;
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


    self.mainView.frame = CGRectMake(self.mainView.frame.origin.x,
                                      self.mainView.frame.origin.y-50,
                                      self.mainView.frame.size.width,
                                      self.mainView.frame.size.height);

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
        self.subTitleLabel.hidden = YES;
    }


        if (self.alertImageString) {
            [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:self.alertImageString] placeholderImage:[UIImage imageNamed:@"nophotos"]];
        }
        if (self.alertImage) {
            self.thumbImageView.image = self.alertImage;
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
            [self.bottomView addSubview:button];
            if (i>0) {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(i*buttonWidth, 0, 0.5, 44)];
                lineView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
                [self.bottomView addSubview:lineView];

                [self bringSubviewToFront:lineView];
            }

        }
    }

}
- (void)clickButtonButton:(UIButton *)sender{
    if (_shareViewBlock) {
        self.shareViewBlock(sender,self.contentLabel.text);
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


@end
