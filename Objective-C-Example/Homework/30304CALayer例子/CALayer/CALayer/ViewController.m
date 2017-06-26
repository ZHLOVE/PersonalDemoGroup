//
//  ViewController.m
//  CALayer
//
//  Created by student on 16/3/18.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //1设置图片的CALayer
    //圆角
    self.iconImageView.layer.cornerRadius = 30;
    //边框
    self.iconImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.iconImageView.layer.borderWidth = 3;
    // 超出边框的内容剪裁掉
    self.iconImageView.layer.masksToBounds = YES;
    //阴影
    self.iconImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.iconImageView.layer.shadowRadius = 30;
    self.iconImageView.layer.shadowOpacity = 1;//阴影不透明
    self.iconImageView.layer.shadowOffset = CGSizeMake(10, 10);
    // 阴影的透明度
    //    self.iconImageView.layer.shadowOpacity = 0.5f;
    //2 新建一个CALayer对象
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 450, 100, 120);
    layer.cornerRadius = 10;
    layer.masksToBounds = YES;// 超出边框的内容剪裁掉
    layer.contents = (id)[UIImage imageNamed:@"2"].CGImage;
    [self.view.layer addSublayer:layer];
    //既要圆角，又要有阴影，用2个layer
    CALayer *backLayer = [CALayer layer];
    backLayer.position = self.iconImageView.center;//起始点
    backLayer.anchorPoint = CGPointMake(0.5, 0.5);//挂载点
    backLayer.cornerRadius = 30;
    backLayer.bounds = CGRectMake(0, 0,150,150);
    backLayer.backgroundColor = [UIColor whiteColor].CGColor;
    backLayer.shadowColor = [UIColor blackColor].CGColor;
    backLayer.shadowRadius = 30;
    backLayer.shadowOpacity = 0.6f;
    [self.view.layer insertSublayer:backLayer below:self.iconImageView.layer];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
















@end
