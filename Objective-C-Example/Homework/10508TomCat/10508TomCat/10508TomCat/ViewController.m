//
//  ViewController.m
//  10508TomCat
//
//  Created by 马千里 on 16/2/20.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageViewTomCat.image = [UIImage imageNamed:@"cat_default.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadImagesImageName:(NSString *)name andImageCounts:(int)counts andPlayTime:(int)t
{
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (int i=1; i<=counts; i++)
    {
        NSString *picName = [name stringByAppendingString:[NSString stringWithFormat:@"%04i.png",i]];
//        NSLog(@"%@",picName);
        UIImage *image = [UIImage imageNamed:picName];
        [mArr addObject:image];
    }
    
    // 设定图片视图播放图片数组
    self.imageViewTomCat.animationRepeatCount = 1;// 播放次数
    self.imageViewTomCat.animationImages = mArr;
    self.imageViewTomCat.animationDuration = t;
    [self.imageViewTomCat startAnimating];

}

- (IBAction)headBtnPressed:(UIButton *)sender {
    [self loadImagesImageName:@"cat_knockout" andImageCounts:80 andPlayTime:5];
}

- (IBAction)happy_simpleBtnPressed:(UIButton *)sender {
    [self loadImagesImageName:@"cat_happy_simple" andImageCounts:24 andPlayTime:2];
}

- (IBAction)happyBtnPressed:(UIButton *)sender {
    [self loadImagesImageName:@"cat_happy" andImageCounts:28 andPlayTime:3];
}

- (IBAction)left_footBtnPressed:(UIButton *)sender {
    [self loadImagesImageName:@"cat_foot_left" andImageCounts:29 andPlayTime:3];
}

- (IBAction)right_footBtnPressed:(UIButton *)sender {
    [self loadImagesImageName:@"cat_foot_right" andImageCounts:29 andPlayTime:3];
}

- (IBAction)eatBirdBtnPressed:(UIButton *)sender {
    [self loadImagesImageName:@"cat_eat" andImageCounts:39 andPlayTime:4];
}

- (IBAction)drinkBtnPressed:(UIButton *)sender {
    [self loadImagesImageName:@"cat_drink" andImageCounts:80 andPlayTime:5];
}


@end
