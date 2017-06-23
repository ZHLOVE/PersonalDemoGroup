//
//  ViewController.m
//  绘制文字和图片
//
//  Created by niit on 16/4/6.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "DrawView.h"


@interface ViewController ()<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@property (nonatomic,strong) UIImagePickerController *imagePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed:(id)sender
{
    if(self.imagePicker == nil)
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 相机是否可用,则是打开相机
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        // 使用相册
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 弹出显示
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma  mark - 图像选择控制器的代理方法
// 选中图片后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    self.drawView.selImage = info[@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
