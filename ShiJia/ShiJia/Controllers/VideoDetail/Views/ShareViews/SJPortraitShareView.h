//
//  SJPortraitShareView.h
//  ShiJia
//
//  Created by 峰 on 16/7/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJShareDelegate.h"
#import "SJ30SVedioRequestModel.h"

typedef void(^ShareButtonBlock)(UIButton *sender);

@interface SJPortraitShareView : UIView
@property (nonatomic, copy) ShareButtonBlock shareButtonBlock;

- (instancetype)initWithTpye:(NSInteger)type;

- (void)showInView:(UIView *)superView;

- (void)hiddleFromSuperView;

@end




@interface ShareAlertView : UIView
@property (nonatomic, strong) UIControl *alertControlView;
@property (nonatomic, strong) UIView    *alertSuperView;
@property (nonatomic, strong) NSString  *titleString;
@property (nonatomic, strong) UITextField *titleText;
@property (nonatomic, strong) NSString  *seconds;
@property (nonatomic, strong) UIButton  *button1;
@property (nonatomic, strong) UIButton  *button2;
@property (nonatomic) NSInteger shareType;

@property (nonatomic, weak) id<SJShareDelegate>sharedelegate;

@property (nonatomic, strong) SJ30SVedioRequestModel *theModel;
@property (nonatomic, strong) SMSRequestParams *smsModel;// 由于后台升级问题 暂时用老接口

- (void)showAlertViewIn:(UIView *)superView;
-(void)hiddenAlertView;

@end
