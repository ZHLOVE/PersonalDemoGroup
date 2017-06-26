//
//  ViewController.m
//  BaoManAutoLayout
//
//  Created by student on 16/3/3.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
       1背景View
         1距离self.view边界 0
         2 view之间距离0
         3 View高宽相等
     2Label
        1固定高度
        2固定距离底部距离
        3
     3白框View
        1距离上下左右固定距离
     4图片
        1固定宽高比例
     
     */
    UIView *greenView = [[UIView alloc]init];
    greenView.backgroundColor = [UIColor greenColor];
    
    UILabel *label = [[UILabel alloc]init];
    [greenView addSubview:label];
    
    UIView *blankView = [[UIView alloc]init];
    [greenView addSubview:blankView];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    [blankView addSubview:imgView];
    
    [self.view addSubview:greenView];

   
}

- (UIView *)createView:(NSString *)imageName andText:(NSString *)text andColor:(UIColor *)color{
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = color;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [aView addSubview:label];
    
    UIView *blankView = [[UIView alloc] init];
    blankView.backgroundColor = [UIColor whiteColor];
    [aView addSubview:blankView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imgView.contentMode= UIViewContentModeScaleAspectFit;// 修改图片的拉伸模式，不会变形
    [blankView addSubview:imgView];
    
    [self.view addSubview:aView];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.bottom.equalTo(aView.bottom).offset(-10);
        make.left.equalTo(aView.left).offset(10);
        make.right.equalTo(aView.right).offset(-10);
    }];
    
    [blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aView.top).offset(15);
        make.bottom.equalTo(label.top).offset(-15);
        make.left.equalTo(aView.left).offset(15);
        make.right.equalTo(aView.right).offset(-15);
    }];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(blankView.top).offset(5);
         make.bottom.equalTo(blankView.bottom).offset(-5);
         make.left.equalTo(blankView.left).offset(5);
         make.right.equalTo(blankView.right).offset(-5);
//         make.center.equalTo(blankView.center);
     }];
    
    return aView;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


















