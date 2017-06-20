//
//  ResultViewController.m
//  TestAge
//
//  Created by niit on 16/4/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ResultViewController.h"

#import "NetManager.h"

#import "AgeInfoView.h"

// 省略mas_开头
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

@interface ResultViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *analizingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *tryBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = [UIImage imageWithData:self.imageData];
    
    [self.activityView startAnimating];// 菊花开始转
    
    // 发请求q
    [NetManager testAgeByImageData:self.imageData
                      successBlock:^(NSDictionary *ageInfos){
        // 处理信息
        
        // 停止转
        [self.activityView stopAnimating];
        [self.activityView setHidden:YES];
        [self.analizingLabel setHidden:YES];
                          
          // 显示结果视图
        NSArray *faces = ageInfos[@"Faces"];
        NSDictionary *face = faces[0];
        NSDictionary *attributes = face[@"attributes"];
        NSDictionary *rectDict = face[@"faceRectangle"];
       [self createInfoViewWithRect:CGRectMake([rectDict[@"left"] intValue],[rectDict[@"top"] intValue],[rectDict[@"width"] intValue], [rectDict[@"height"] intValue]) andAge:[attributes[@"age"] intValue] andGender:[attributes[@"gender"] isEqualToString:@"Male"]];

                          
    }
                         failBlock:^(NSError *error)
     {
         [self.activityView stopAnimating];// 停止转
         self.analizingLabel.text  = @"分析失败";
     }];
    
    
    [self.tryBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

}

//faceRectangle =             {
//    height = 62;
//    left = 50;
//    top = 35;
//    width = 62;
//};

/**
 *  显示结果
 *
 *  @param rect 区域
 *  @param age  年龄
 *  @param male 性别
 */
- (void)createInfoViewWithRect:(CGRect)rect
                        andAge:(int)age
                     andGender:(BOOL)male
{
    
    // 绘制一个框
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    // 边框
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 2;
    
    // 框的位置大小 （等待计算）
    CGFloat width,height;
    CGFloat centerX,centerY;// 中心点
    
    // 已知数据如下:
    // 1. 框绘制区域:rect (在image中的区域位置)
    // 2. 图片的大小:self.imageView.image.size
    UIImage *image = self.imageView.image;
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    // 图片视图的位置及大小: self.imgView.frame
    CGFloat imageViewCenterX = self.imageView.center.x;
    CGFloat imageViewCenterY = self.imageView.center.y;
    CGFloat imageViewWidth = self.imageView.frame.size.width;
    CGFloat imageViewHeight = self.imageView.frame.size.height;
    
    // 计算
    // 1. 缩放比率
    CGFloat scale = imageViewWidth / imageWidth;//scale = 实际大小 / 图片大小
    NSLog(@"缩放比率:%f",scale);
    
    // 2. 框的大小
    width = rect.size.width * scale;// 框的大小 = 原始大小 * 缩放率scale
    height = rect.size.height *scale;
    NSLog(@"框的大小:(%f,%f)",width,height);
    // 框的位置
    
    // 3. 框的中心点位置
    // 计算原始偏移 (框的中心点距离图片中心点的偏移)
    CGFloat centerXDelta = rect.origin.x + rect.size.width/2 - imageWidth/2;
    CGFloat centerYDelta = rect.origin.y + rect.size.height/2 - imageHeight/2;
    // 偏移乘以缩放率
    centerXDelta *= scale;
    centerYDelta *= scale;
    // 实际框中心的位置
    centerX = imageViewCenterX + centerXDelta;
    centerY = imageViewCenterY + centerYDelta;
    
    // 设置
    view.frame = CGRectMake(0, 0, width, height);
    view.center =CGPointMake(centerX, centerY);
    [self.view addSubview:view];
    
    // 显示在框上方
    AgeInfoView *infoView= [[AgeInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:infoView];
    infoView.age = age;
    infoView.male = male;
    
    infoView.center = CGPointMake(centerX,centerY-infoView.frame.size.height/2-height/2);
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupUI];
}

- (void)setupUI
{
    // 1. titleLabel
    [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(200);
        make.height.equalTo(50);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.view.centerX);
        
    }];
    
    // 2. 图标
    [self.logoImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(50);
        make.right.equalTo(self.titleLabel.mas_left).offset(-30);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
}

- (IBAction)backBtnPressed:(id)sender
{
    NSLog(@"%s",__func__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
