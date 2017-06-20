//
//  QRCardViewController.m
//  WeiBo
//
//  Created by student on 16/4/27.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "QRCardViewController.h"
#import "QRCode.h"
@interface QRCardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@end

@implementation QRCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1要生成二维码的字符串
    NSString *source = @"ILOVU";
    //2创建一个CIImage
    CIImage *imageQRCode = [QRCode createQRCodeImage:source];
    //3生成UIImage图片
    UIImage *img = [QRCode resizeQRCodeImage:imageQRCode withSize:self.codeImage.frame.size.width];
    //4 二维码当中贴张图片
    self.codeImage.image = img;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
