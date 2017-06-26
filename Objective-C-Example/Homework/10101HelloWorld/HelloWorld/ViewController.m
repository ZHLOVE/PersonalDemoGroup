//
//  ViewController.m
//  HelloWorld
//
//  Created by niit on 16/1/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+HexColor.h"
#import "M80AttributedLabel.h"
@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *mArray;

@property(nonatomic,strong) M80AttributedLabel *resultLabel;


@end

@implementation ViewController

- (void)setName:(NSString *)name{
    self.name = name;
}

- (NSMutableArray *)mArray{
    if (_mArray == nil) {
        _mArray = [NSMutableArray array];
    }
    return _mArray;
}

- (NSString *)name{
    return @"张三";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *img = [[UIImageView alloc]initWithFrame:self.view.frame];
    img.contentMode = UIViewContentModeScaleAspectFill;
    [img setImage:[UIImage imageNamed:@"BG.jpg"]];
    [self.view addSubview:img];

    //渐变色
    UIVisualEffectView *view=[[UIVisualEffectView alloc]initWithFrame:CGRectMake(0, 400, 375, 160)];
    view.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    view.alpha = 1.0f;
    view.backgroundColor = [UIColor clearColor];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                             (__bridge id)[UIColor lightGrayColor].CGColor,
                             (__bridge id)[UIColor colorWithHexString:@"#000000"].CGColor];
    gradientLayer.locations = @[@(0.0),@(1.0)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    view.layer.mask = gradientLayer;
    [self.view addSubview:view];
    self.resultLabel.frame = CGRectMake(18, 430, 375, 100);
    [self.view addSubview:self.resultLabel];

}

- (M80AttributedLabel *)resultLabel{
    if (_resultLabel == nil) {
        _resultLabel = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
        _resultLabel.font      = [UIFont systemFontOfSize:14];
        _resultLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _resultLabel.lineSpacing = 10.0f;
        _resultLabel.backgroundColor = [UIColor clearColor];
        NSString *text = @"人脸定位检测 人脸姿态检测 人脸光照检测";
        NSArray *components = [text componentsSeparatedByString:@" "];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:@"未通过"];
        [attributedText m80_setTextColor:[UIColor colorWithHexString:@"#fe916f"]];
        [attributedText m80_setFont:[UIFont systemFontOfSize:14]];
        for (int i=0;i<components.count;i++) {
            [_resultLabel appendText:components[i]];
                [_resultLabel appendText:@"通过"];
                [_resultLabel appendText:@"\n"];
        }
    }
    return _resultLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)btnPressed:(UIButton *)sender
{
    [_mArray addObject:@"aaa"];
    NSLog(@"%ld",_mArray.count);

}



@end
