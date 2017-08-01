//
//  LogInfoVC.m
//  ShiJia
//
//  Created by MccRee on 2017/7/13.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "LogInfoVC.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <LumberjackConsole/PTEDashboard.h>
#import "HiTVGlobals.h"

@interface LogInfoVC ()

@property(nonatomic,assign) BOOL logShow;
@property(nonatomic,strong) UILabel *baseInfoLab;
@property(nonatomic,strong) UITextView *baseInfoText;
@property(nonatomic,strong) UITextView *logInfoTextView;
@property(nonatomic,strong) UIButton *logBtn;
@property(nonatomic,strong) UIButton *logUploadBtn;





@end

@implementation LogInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [PTEDashboard.sharedDashboard show];
    _logShow = YES;
    
}



- (void)setUpUI {
    __weak typeof (self) weakSelf = self;

   
    [self.view addSubview:self.logBtn];
    [self.logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(W/2 - 10);
        make.height.mas_equalTo(80);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.left.mas_equalTo(weakSelf.view);
    }];
    
    [self.view addSubview:self.logUploadBtn];
    [self.logUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(W/2 - 10);
        make.height.mas_equalTo(80);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.right.mas_equalTo(weakSelf.view);
    }];
    [self.view addSubview:self.baseInfoText];
    [self.baseInfoText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.top);
        make.height.mas_equalTo(300);
    }];
    [self.view addSubview:self.logInfoTextView];
    [self.logInfoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.baseInfoText.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.logUploadBtn.mas_top);

    }];
    
}




/**
 日志开关
 */
- (void)setlogBtnPressed{
    if (_logShow) {
        [PTEDashboard.sharedDashboard hide];
        [self.logBtn setTitle:@"日志已关" forState:UIControlStateNormal];
        _logShow = NO;
    }else{
        [PTEDashboard.sharedDashboard show];
        [self.logBtn setTitle:@"日志已开" forState:UIControlStateNormal];
        _logShow = YES;
    }
}

- (void)upLoadBtnPressed{
    DDLogInfo(@"上传日志");
}



- (UILabel *)baseInfoLab{
    if (_baseInfoLab == nil) {
        _baseInfoLab = [[UILabel alloc]init];
        _baseInfoLab.text = @"基本配置信息";
        _baseInfoLab.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _baseInfoLab;
}

- (UITextView *)baseInfoText{
    if (_baseInfoText == nil) {
        _baseInfoText = [[UITextView alloc]init];
        _baseInfoText.backgroundColor = [UIColor lightGrayColor];
        _baseInfoText.layer.borderWidth = 1;
        _baseInfoText.layer.borderColor = [UIColor blackColor].CGColor;
        _baseInfoText.editable = NO;
        NSString *deviceId = [HiTVGlobals sharedInstance].deviceId;
        _baseInfoText.text = [NSString stringWithFormat:@"基本信息\nChannelID:%@\nBIMSboot:%@\n渠道号:%@\n第三方appID\nBuglyId:%@\nkSinaAppID:%@\nkWeChatAppID:%@\nUMengAppKey:%@\nDeviceId:%@\n系统版本:%f",CHANNELID,BOOTHOST,APPStroreID,BuglyId,kSinaAppID,kWeChatAppID,UMengAppKey,deviceId,kIOS_VERSION];

    }
    return _baseInfoText;
}


- (UITextView *)logInfoTextView{
    if (_logInfoTextView == nil) {
        _logInfoTextView = [[UITextView alloc]init];
        _logInfoTextView.backgroundColor = [UIColor lightGrayColor];
        _logInfoTextView.layer.borderWidth = 1;
        _logInfoTextView.layer.borderColor = [UIColor blackColor].CGColor;
        _logInfoTextView.editable = NO;
    }
    return _logInfoTextView;
}


- (UIButton *)logBtn{
    if (_logBtn == nil) {
        _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logBtn setBackgroundColor:[UIColor colorWithRed:0.17 green:0.97 blue:0.60 alpha:1.00]];
        [_logBtn setTitle:@"日志已开" forState:UIControlStateNormal];
        [_logBtn addTarget:self action:@selector(setlogBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logBtn;
}

- (UIButton *)logUploadBtn{
    if (_logUploadBtn == nil) {
        _logUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logUploadBtn setBackgroundColor:[UIColor colorWithRed:0.17 green:0.97 blue:0.60 alpha:1.00]];
        [_logUploadBtn setTitle:@"上传日志" forState:UIControlStateNormal];
        [_logUploadBtn addTarget:self action:@selector(upLoadBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logUploadBtn;
}




























@end
