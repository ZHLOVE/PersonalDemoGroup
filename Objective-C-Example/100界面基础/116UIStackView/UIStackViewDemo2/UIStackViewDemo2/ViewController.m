//
//  ViewController.m
//  UIStackViewDemo2
//
//  Created by niit on 16/3/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface ViewController ()

@property (nonatomic,strong) UIStackView *st3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"How do you like our app?";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;// 图片填充模式
    
    UIButton *addStarBtn = [[UIButton alloc] init];
    [addStarBtn setTitle:@"Add Star!" forState:UIControlStateNormal];
    [addStarBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [addStarBtn addTarget:self action:@selector(addStar) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeStarBtn = [[UIButton alloc] init];
    [removeStarBtn setTitle:@"Remove Star." forState:UIControlStateNormal];
    [removeStarBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [removeStarBtn addTarget:self action:@selector(removeStar) forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *st1 = [[UIStackView alloc] init];
    [st1 addArrangedSubview:addStarBtn];
    [st1 addArrangedSubview:removeStarBtn];
    st1.axis = UILayoutConstraintAxisHorizontal;// 水平排列
    st1.spacing = 10;// 元素之间间隔10
    st1.distribution = UIStackViewDistributionFillEqually;// 每个元素填充大小相等
    
    UIStackView *st2 = [[UIStackView alloc] init];
    [st2 addArrangedSubview:label];
    [st2 addArrangedSubview:imageView];
    [st2 addArrangedSubview:st1];
    st2.axis = UILayoutConstraintAxisVertical;//垂直排列
    st2.spacing = 20;
    [self.view addSubview:st2];
    
    // 添加约束
    [st2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(22);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(self.view.height).multipliedBy(0.7);
    }];
    
    self.st3 = [[UIStackView alloc] init];
    self.st3.axis = UILayoutConstraintAxisHorizontal;
    self.st3.distribution = UIStackViewDistributionFillEqually;
    [self.view addSubview:self.st3];
    
    // 添加约束
    [self.st3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(st2.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    
}

- (void)addStar
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.st3 addArrangedSubview:imageView];
}

- (void)removeStar
{
    UIImageView *imageView = [self.st3.subviews lastObject];
    [self.st3 removeArrangedSubview:imageView];
    [imageView removeFromSuperview];
    
}

@end
