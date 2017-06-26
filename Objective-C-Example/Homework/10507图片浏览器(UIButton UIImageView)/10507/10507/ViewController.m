//
//  ViewController.m
//  10507
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
    
    // 创建图片数组
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (int i=1; i<=5; i++)
    {
        //图片名字1，2，3，4，5
        NSString *picName = [NSString stringWithFormat:@"%i.png",i];
        UIImage *image = [UIImage imageNamed:picName];
        [mArr addObject:image];
    }
    self.imageArr = [mArr mutableCopy] ;
    [self.picImageView setImage:[UIImage imageNamed:@"1.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftBtnPressed:(UIButton *)sender {
    int pageValue = [self.pageNum.text intValue];
    if (pageValue>1) {
        pageValue--;
    }
    [self.picImageView setImage:self.imageArr[pageValue-1]];
    NSString *pageNum = [NSString stringWithFormat:@"%i",pageValue];
    self.pageNum.text = pageNum;
}

- (IBAction)rightBtnPressed:(UIButton *)sender {
    int pageValue = [self.pageNum.text intValue];
    int pageValueMax = [self.pageNumMax.text intValue];
    if (pageValue < pageValueMax ) {
        pageValue++;
    }
    [self.picImageView setImage:self.imageArr[pageValue-1]];
    NSString *pageNum = [NSString stringWithFormat:@"%i",pageValue];
    self.pageNum.text = pageNum;
}

@end
