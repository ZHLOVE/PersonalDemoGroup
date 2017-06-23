//
//  ViewController.m
//  sample_st_mobile_track_106
//
//  Created by sluin on 16/5/24.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "ViewController.h"
#import "TrackingViewController.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@property(nonatomic,strong) UIButton *punchBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.punchBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)onBtnStartTracking{
    
    TrackingViewController *trackingVC = [[TrackingViewController alloc]init];
    [self.navigationController pushViewController:trackingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIButton *)punchBtn{
    if (_punchBtn == nil) {
        _punchBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2 - 80, screenHeight/2 + 30, 160, 50)];
        _punchBtn.backgroundColor = [UIColor blueColor];
        [_punchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_punchBtn setTitle:@"人脸识别" forState:UIControlStateNormal];
        [_punchBtn addTarget:self action:@selector(onBtnStartTracking) forControlEvents:UIControlEventTouchUpInside];
    }
    return _punchBtn;
}
@end
