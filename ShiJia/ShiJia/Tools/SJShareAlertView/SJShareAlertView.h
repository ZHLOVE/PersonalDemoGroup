//
//  SJShareAlertView.h
//  ShiJia
//
//  Created by 峰 on 16/9/3.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
/*
 SJShareAlertView *alertView = [SJShareAlertView alertViewDefault];
 alertView.alertBlock = ^(id sender){
 UIButton *button = (UIButton *)sender;
 DDLogInfo(@"---------%@",button.titleLabel.text);
 };
 alertView.title = @"提示";
 alertView.content = @"这是一个自定义的alertView高度可以根据内容自适应。（行间距为8）";
 alertView.buttonTtileArray= @[@"取消",@"确定"];
 alertView.deterColor = [UIColor redColor];
 alertView.alertImage =
 [alertView show];
 */
#import <UIKit/UIKit.h>

typedef void(^alertButtonClick)(id sender,NSString *text);

@interface SJShareAlertView : UIView

@property (nonatomic, copy) alertButtonClick alertBlock;
@property (nonatomic, strong) NSString         *title;
@property (nonatomic, strong) NSString         *content;
@property (nonatomic, strong) NSArray          *buttonTtileArray;
@property (nonatomic, strong) UIColor          *cancelColor;
@property (nonatomic, strong) UIColor          *deterColor;
@property (nonatomic, strong) UIImage          *alertImage;
@property (nonatomic, strong) NSString         *alertImageString;
@property (nonatomic) BOOL showMessage;

+ (instancetype)alertViewDefault;
- (void)show;
@end
