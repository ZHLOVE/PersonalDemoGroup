//
//  TeslaVC.m
//  Tesla
//
//  Created by MBP on 16/7/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "TeslaVC.h"
#import "Network.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface TeslaVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIButton *oldDriverBtn;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *carNumberLabel;
@property (nonatomic,strong) UILabel *confidenceLabel;


@end

@implementation TeslaVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //请求前设置账号密码设备uuid，单例设置过一次即可
    NSString * identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    [Network setApiAccount:@"账号" ApiPasswd:@"密码" uuid:identifierForVendor];
    [Network setApiAccount:@"11f4cec8-b051-11e6-bb56-00163e061e76" ApiPasswd:@"ZGU4NmI3YWViNGIwMWY5NWJiM2ZhNjRiNDllMjA3NDI=" uuid:identifierForVendor];
    [self.view addSubview:self.oldDriverBtn];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.carNumberLabel];
    [self.view addSubview:self.confidenceLabel];
}


//选择完图片后会回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"info = %@",info);
    //隐藏控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    //给imageView 赋值图片
    self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];

    [Network licensePlateImage:self.imageView.image ext:@"png" successBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        NSString *carNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"number"]];
        NSLog(@"车牌号:%@",carNumber);
        NSString *confidence1 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"confidence1"]];
        if (confidence1.length > 3) {
            confidence1 = [confidence1 substringWithRange:NSMakeRange(0, 4)];
        }
        NSString *confidence2 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"confidence2"]];
        if (confidence2.length > 3) {
            confidence2 = [confidence2 substringWithRange:NSMakeRange(0, 4)];
        }
        NSString *confidence3 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"confidence3"]];
        if (confidence3.length > 3) {
            confidence3 = [confidence3 substringWithRange:NSMakeRange(0, 4)];
        }
        NSString *confidence4 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"confidence4"]];
        if (confidence4.length > 3) {
            confidence4 = [confidence4 substringWithRange:NSMakeRange(0, 4)];
        }
        NSString *confidence5 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"confidence5"]];
        if (confidence5.length > 3) {
           confidence5 = [confidence5 substringWithRange:NSMakeRange(0, 4)];
        }
        NSString *confidence6 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"confidence6"]];
        if (confidence6.length > 3) {
            confidence6 = [confidence6 substringWithRange:NSMakeRange(0, 4)];
        }
        NSString *confidence7 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"confidence7"]];
        if (confidence7.length > 3) {
           confidence7 = [confidence7 substringWithRange:NSMakeRange(0, 4)];
        }
        self.carNumberLabel.text = carNumber;
        self.confidenceLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",confidence1,confidence2,confidence3,confidence4,confidence5,confidence6,confidence7];
    } failBlock:^(NSError *error) {

    }];
}
//导航条上面的 Cancel 的点击方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //隐藏控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)driveBtnPressed{
    //sourceType 是用来确认用户界面样式，选择相册
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //设置代理
    imagePicker.delegate = self;
    //允许编辑弹框
    imagePicker.allowsEditing = YES;
    //是用手机相册来获取图片的
    imagePicker.sourceType = sourceType;
    //模态推出pickViewController
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma MARK - 懒加载
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 300)];
    }
    return _imageView;
}

- (UIButton *)oldDriverBtn{
    if (_oldDriverBtn == nil) {
        _oldDriverBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 120, 30)];
        _oldDriverBtn.backgroundColor = [UIColor lightGrayColor];
        [_oldDriverBtn addTarget:self action:@selector(driveBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_oldDriverBtn setTitle:@"选择车牌" forState:UIControlStateNormal];
    }
    return _oldDriverBtn;
}

- (UILabel *)carNumberLabel{
    if (_carNumberLabel == nil) {
        _carNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 150, 120, 30)];
    }
    return _carNumberLabel;
}

- (UILabel *)confidenceLabel{
    if (_confidenceLabel == nil) {
        _confidenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200,screenWidth, 30)];
    }
    return _confidenceLabel;
}


@end
