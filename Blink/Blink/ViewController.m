//
//  ViewController.m
//  Blink
//
//  Created by MBP on 2016/12/28.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ViewController.h"
#import "CameraVC.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong) UIButton *button;
@property (weak, nonatomic) IBOutlet UITextField *zhenShu;
@property (weak, nonatomic) IBOutlet UITextField *zhaYanZhenShu;
@property (weak, nonatomic) IBOutlet UITextField *pinJunZhiPianCha;
@property (weak, nonatomic) IBOutlet UITextField *fuYangJiaoDu;
@property (weak, nonatomic) IBOutlet UITextField *zuoYouJiaoDu;
@property (weak, nonatomic) IBOutlet UITextField *xuanZhuanJiaoDu;
@property (weak, nonatomic) IBOutlet UITextField *renLianGaoDuDaYu;
@property (weak, nonatomic) IBOutlet UITextField *renLianGaoDuXiaoYu;
@property (weak, nonatomic) IBOutlet UITextField *yanJingKaiHeDuFangCha;
@property (weak, nonatomic) IBOutlet UITextField *xXiaXian;
@property (weak, nonatomic) IBOutlet UITextField *xShangXian;
@property (weak, nonatomic) IBOutlet UITextField *yXiaXian;
@property (weak, nonatomic) IBOutlet UITextField *yShangXian;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
    [self.view addSubview:self.button];
    self.zhenShu.center = CGPointMake(self.view.center.x, 100);
    self.zhaYanZhenShu.center = CGPointMake(self.view.center.x, 140);
    self.pinJunZhiPianCha.center = CGPointMake(self.view.center.x, 180);
    self.yanJingKaiHeDuFangCha.center = CGPointMake(self.view.center.x, 220);
}

- (void)gotoCamera{
    NSDictionary *canShuDict = @{@"帧数":self.zhenShu.text,@"眨眼帧数":self.zhaYanZhenShu.text,@"均值偏差":self.pinJunZhiPianCha.text,@"俯仰角度":self.fuYangJiaoDu.text,@"左右角度":self.zuoYouJiaoDu.text,@"旋转角度":self.xuanZhuanJiaoDu.text,@"高度大于":self.renLianGaoDuDaYu.text,@"高度小于":self.renLianGaoDuXiaoYu.text,@"开合方差":self.yanJingKaiHeDuFangCha.text,@"X下限":self.xXiaXian.text,@"X上限":self.xShangXian.text,@"Y下限":self.yXiaXian.text,@"Y上限":self.yShangXian.text};
    CameraVC *cam = [[CameraVC alloc]initWithCanShu:canShuDict];
    [self.navigationController pushViewController:cam animated:YES];
    
}

- (UIButton *)button{
    if (_button == nil) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
        _button.center = CGPointMake(self.view.center.x, self.view.center.y);
        [_button setTitle:@"开始刷脸" forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor lightGrayColor];
        [_button addTarget:self action:@selector(gotoCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
}



@end
