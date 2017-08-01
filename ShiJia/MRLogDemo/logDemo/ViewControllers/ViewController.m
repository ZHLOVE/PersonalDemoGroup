//
//  ViewController.m
//  logDemo
//
//  Created by MccRee on 2017/7/18.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "ViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <LumberjackConsole/PTEDashboard.h>
#import "MRLog.h"
#import "MRDataBase.h"
#import "BaseNetwork.h"
#import "UserEventModels.h"
#import "MJExtension.h"


@interface ViewController ()

@property(nonatomic,strong) UIButton *logBtn;
@property(nonatomic,strong) UIButton *logBtn10;
@property(nonatomic,strong) UIButton *relationBtn;
@property(nonatomic,strong) UIButton *sendTableBtn;
@property(nonatomic,strong) UIButton *deleteBtn;
@property(nonatomic,strong) UIButton *showBtn;
@property(nonatomic,strong) UIButton *uploadBtn;
@property(nonatomic,strong) MRLog *mrLog;
@property(nonatomic,strong) MRDataBase *mrDataBase;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.logBtn];
    [self.view addSubview:self.logBtn10];
//    [self.view addSubview:self.showBtn];
//    [self.view addSubview:self.deleteBtn];
    [self.view addSubview:self.uploadBtn];
//    [self.view addSubview:self.sendTableBtn];
    [self createDataBase];
}

- (void)createDataBase{
    
    self.mrLog = [MRLog sharedMRLog];
    self.mrDataBase = [MRDataBase sharedMRDataBase];
}



- (void)showBtnPressed{

}

- (void)adjust
{
    PTEDashboard.sharedDashboard.windowLevel += 100;
    NSLog(@"%@ ", @(PTEDashboard.sharedDashboard.windowLevel));
}


- (void)logBtnPressed{
    OpenVideo *op = [[OpenVideo alloc]init];
    op.ID = @"123456qwecd";
    op.ctype = @"vod";
    op.cid = @"cid";
    NSLog(@"写入一条日志");
    [self.mrLog logEventWithEventModel:op];
}

- (void)logBtn10Pressed{
    for (int i = 0;i<10 ; i++) {
        WatchListExposure *w = [[WatchListExposure alloc]init];
        [self.mrLog logEventWithEventModel:w];
    }
    NSLog(@"写入十条日志");
}

- (void)relationBtnPressed{
    
}


- (void)sendTableBtnPressed{
    
}


- (void)deleteBtnPressed{

}


- (void)upLoadBtnPressed{
    [self.mrLog reportLogRightNow];
   
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIButton *)logBtn{
    if (_logBtn == nil) {
        _logBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 100, 50)];
        _logBtn.backgroundColor = [UIColor lightGrayColor];
        [_logBtn setTitle:@"加一日志" forState:UIControlStateNormal];
        [_logBtn addTarget:self action:@selector(logBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logBtn;
}

- (UIButton *)logBtn10{
    if (_logBtn10 == nil) {
        _logBtn10 = [[UIButton alloc]initWithFrame:CGRectMake(160, 100, 120, 50)];
        _logBtn10.backgroundColor = [UIColor lightGrayColor];
        [_logBtn10 setTitle:@"加10条日志" forState:UIControlStateNormal];
        [_logBtn10 addTarget:self action:@selector(logBtn10Pressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logBtn10;
}

- (UIButton *)showBtn{
    if (_showBtn == nil) {
        _showBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, 100, 50)];
        _showBtn.backgroundColor = [UIColor lightGrayColor];
        [_showBtn setTitle:@"显示日志" forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(showBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBtn;
}

- (UIButton *)deleteBtn{
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 100, 50)];
        _deleteBtn.backgroundColor = [UIColor lightGrayColor];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIButton *)uploadBtn{
    if (_uploadBtn == nil) {
        _uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 400, 100, 50)];
        _uploadBtn.backgroundColor = [UIColor lightGrayColor];
        [_uploadBtn setTitle:@"立即发送" forState:UIControlStateNormal];
        [_uploadBtn addTarget:self action:@selector(upLoadBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

- (UIButton *)relationBtn{
    if (_relationBtn == nil) {
        _relationBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 500, 100, 50)];
        _relationBtn.backgroundColor = [UIColor lightGrayColor];
        [_relationBtn setTitle:@"关系表插入" forState:UIControlStateNormal];
        [_relationBtn addTarget:self action:@selector(relationBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _relationBtn;
}


- (UIButton *)sendTableBtn{
    if (_sendTableBtn == nil) {
        _sendTableBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 300, 50)];
        _sendTableBtn.backgroundColor = [UIColor lightGrayColor];
        [_sendTableBtn setTitle:@"一定量或即时数据" forState:UIControlStateNormal];
        [_sendTableBtn addTarget:self action:@selector(sendTableBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendTableBtn;
}
   
   
   
   
   
   
   
   
   
   
   
   
   
@end
