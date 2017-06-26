//
//  ViewController.m
//  30103TouchTest
//
//  Created by 马千里 on 16/3/17.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建图片数组
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (int i=7; i<=15; i++)
    {
        NSString *picName = [NSString stringWithFormat:@"frame-%i",i];
        UIImage *image = [UIImage imageNamed:picName];
        [mArr addObject:image];
    }
    // 设定图片视图播放图片数组
//    self.imageView.animationRepeatCount = 1;// 播放次数
    self.imageView.animationImages = mArr;
    self.imageView.animationDuration = 1;
    [self.imageView startAnimating];
    
}

//点击后兔子朝目标方向移动
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *t = touches.anyObject;
    CGPoint tPoint = [t locationInView:self.view];
    CGPoint center =  self.imageView.center;
    CGFloat x = (tPoint.x - center.x)/10;
    CGFloat y = (tPoint.y - center.y)/10;
    self.imageView.center = CGPointMake(self.imageView.center.x + x, self.imageView.center.y + y);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
