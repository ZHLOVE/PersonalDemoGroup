//
//  ViewController.m
//  刮刮乐
//
//  Created by MBP on 16/6/28.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (nonatomic,strong) UILabel *guaGuaLeLabel;
@property (nonatomic,strong) UIImageView *upImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
}


- (void)setUpUI{
    self.guaGuaLeLabel.text = @"离思五首\n元稹\n曾经沧海难为水,\n除却巫山不是云!\n取次花丛懒回顾,\n半缘修道半缘君!\n";
    self.guaGuaLeLabel.frame = CGRectMake(0, 100, 375, 375);
    [self.view addSubview:self.guaGuaLeLabel];

    self.upImageView.frame = CGRectMake(0, 100, 375, 375);
    self.upImageView.image = [UIImage imageNamed:@"IMG.JPG"];
    [self.view addSubview:self.upImageView];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //触摸任意位置
    UITouch *touch = touches.anyObject;
    //触摸位置上的坐标
    CGPoint cententPoint = [touch locationInView:self.upImageView];
    //设置清除点的大小
    CGRect rect = CGRectMake(cententPoint.x, cententPoint.y, 50, 50);
    //默认是创建一个透明的视图
    UIGraphicsBeginImageContextWithOptions(self.upImageView.bounds.size, NO, 0);
    //获取上下文(画板)
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //把imageView的layer映射到上下文中！！！
    [self.upImageView.layer renderInContext:ref];
    //清除划过的区域
    CGContextClearRect(ref, rect);
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束图片的画板（意味着图片在上下文中消失）
    UIGraphicsEndImageContext();
    self.upImageView.image = image;

}

- (UILabel *)guaGuaLeLabel{
    if (_guaGuaLeLabel == nil) {
        _guaGuaLeLabel = [[UILabel alloc]init];
        _guaGuaLeLabel.numberOfLines = 0;
        _guaGuaLeLabel.backgroundColor = [UIColor whiteColor];
        _guaGuaLeLabel.font = [UIFont systemFontOfSize:20];
        _guaGuaLeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _guaGuaLeLabel;
}

- (UIImageView *)upImageView{
    if (_upImageView == nil) {
        _upImageView = [[UIImageView alloc]init];
    }
    return _upImageView;
}


@end
