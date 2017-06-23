//
//  ViewController2.m
//  ImageHop
//
//  Created by niit on 16/2/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建图片数组
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (int i=1; i<=20; i++)
    {
        NSString *picName = [NSString stringWithFormat:@"frame-%i.png",i];
        UIImage *image = [UIImage imageNamed:picName];
        [mArr addObject:image];
    }
    
    // 设定图片视图播放图片数组
//    self.imageView.animationRepeatCount = 1;// 播放次数
    self.imageView.animationImages = mArr;
    self.imageView.animationDuration = 2;
//    [self.imageView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 开关动画
- (IBAction)btnPressed:(id)sender
{
    if(self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
        [self.btn setTitle:@"跳" forState:UIControlStateNormal];
    }
    else
    {
        [self.imageView startAnimating];
        [self.btn setTitle:@"停" forState:UIControlStateNormal];
    }
}

// 调整动画速度
- (IBAction)sliderChanged:(UISlider *)sender
{
    self.imageView.animationDuration = 2 - sender.value;
    if([self.imageView isAnimating])
    {
        [self.imageView startAnimating];
    }
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
