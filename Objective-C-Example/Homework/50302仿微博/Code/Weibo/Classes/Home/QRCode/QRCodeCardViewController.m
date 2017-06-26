//
//  QRCodeCardViewController.m
//  Weibo
//
//  Created by qiang on 4/27/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "QRCodeCardViewController.h"

#import "QRCode.h"
#import "UIImage+RoundedRectImage.h"

@interface QRCodeCardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end

@implementation QRCodeCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 原文地址:http://www.cnblogs.com/huangjianwu/p/4574993.html
    // 1. 要生成二维码的字符串
    NSString *source = @"I love you";
    
    // 2. 创建一个CIImage图像
    CIImage *imgQRCode = [QRCode createQRCodeImage:source];
    
    // 3. 生成UIImage图片
    UIImage *img = [QRCode resizeQRCodeImage:imgQRCode withSize:self.codeImageView.frame.size.width];
    // 调整二维码颜色
    img = [QRCode specialColorImage:img withRed:33.0 green:114.0 blue:237.0];
    // 当中贴张图片
    UIImage *photoImg = [UIImage createRoundedRectImage:[UIImage imageNamed:@"jikeying"] withSize:CGSizeMake(70.0, 93.0) withRadius:10];
    img = [QRCode addIconToQRCodeImage:img withIcon:photoImg withIconSize:photoImg.size];
    
    
    self.codeImageView.image = img;
    
    
}
- (IBAction)closeBtnPressed:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
