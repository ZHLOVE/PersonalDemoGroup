//
//  ViewController.m
//  绘制渐变色
//
//  Created by MBP on 2017/3/16.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+HexColor.h"
#define ratio  [UIScreen mainScreen].bounds.size.height / 667
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property(nonatomic,strong) UIView *colorView;
@property(nonatomic,strong) CAGradientLayer *grayLayer;
@property(nonatomic,strong) UISlider *colorSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.colorView];
    self.grayLayer.frame = self.colorView.bounds;
    [self.colorView.layer addSublayer:self.grayLayer];
//    [self.view addSubview:self.colorSlider];
//    [self.colorSlider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];


}

- (void)valueChange:(UISlider *)slider{
    NSLog(@"%f",slider.value);
//    CGFloat middle = slider.value;
}

- (CAGradientLayer *)grayLayer{
    if (_grayLayer == nil) {
        _grayLayer = [CAGradientLayer layer];
        _grayLayer.colors = @[(id)[UIColor colorWithHexString:@"#10e26f"].CGColor,
                            (id)[UIColor colorWithHexString:@"#02ca72"].CGColor];
        _grayLayer.locations = @[@(0.0f),@(1.0f)];
        _grayLayer.startPoint = CGPointMake(0, 0);
        _grayLayer.endPoint = CGPointMake(0.96, 1);
    }
    return _grayLayer;
}

- (UIView *)colorView{
    if (_colorView == nil) {
        _colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 375, 603)];
    }
    return _colorView;
}

- (UISlider *)colorSlider{
    if (_colorSlider == nil) {
        _colorSlider = [[UISlider alloc]initWithFrame:CGRectMake(80 * ratio, self.colorView.frame.origin.y + screenHeight * 0.66 + 20, screenWidth - 100 * ratio, 30)];
        _colorSlider.value = 0.5f;
    }
    return _colorSlider;
}


@end
