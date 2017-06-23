//
//  ViewController.m
//  Baozou
//
//  Created by niit on 16/3/3.
//  Copyright © 2016年 NIIT. All rights reserved.
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
    // Do any additional setup after loading the view, typically from a nib.
    
    //1 背景View
        //1 距离self.view边界 0
        //2 view之间距离0
        //3 view的宽度高度相等
    //2 label
        //1 固定高度
        //2 固定距离底部距离
        //3 距离左边右两边固定
    //3 白框View
        //1 距离上下左右固定距离
    //4 图片
        //1 固定宽高比例
        //2 图片不能超出白框
        //3 居中
    
    UIView *greenView = [self createView:@"1.jpg" andText:@"jane" andColor:[UIColor greenColor]];
    UIView *yellowView = [self createView:@"2.jpg" andText:@"abc" andColor:[UIColor yellowColor]];
    UIView *blueView = [self createView:@"3.jpg" andText:@"哈哈" andColor:[UIColor blueColor]];
    UIView *purpleView = [self createView:@"4.jpg" andText:@"123123123" andColor:[UIColor purpleColor]];
    
    [self.view addSubview:greenView];
    [self.view addSubview:yellowView];
    [self.view addSubview:blueView];
    [self.view addSubview:purpleView];
    
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.width).multipliedBy(0.5);
        make.height.equalTo(self.view.height).multipliedBy(0.5);
        
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.view.top);
    }];
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.width).multipliedBy(0.5);
        make.height.equalTo(self.view.height).multipliedBy(0.5);
        
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top);
    }];
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.width).multipliedBy(0.5);
        make.height.equalTo(self.view.height).multipliedBy(0.5);
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
    }];
    [purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.width).multipliedBy(0.5);
        make.height.equalTo(self.view.height).multipliedBy(0.5);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
}

- (UIView *)createView:(NSString *)imageName andText:(NSString *)text andColor:(UIColor *)color
{
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
    
    imgView.backgroundColor = [UIColor blackColor];
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
        
//        make.center.equalTo(blankView.center);
    }];
    
    
    return aView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
