//
//  ViewController.m
//  CNEN
//
//  Created by MBP on 2017/6/13.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UILabel *labelOne;
@property(nonatomic,strong) UILabel *labelTwo;
@property(nonatomic,strong) UILabel *labelThree;
@property(nonatomic,strong) UIImageView *imgView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
}


- (void)setUpUI{
    [self.view addSubview:self.labelOne];
    [self.view addSubview:self.labelTwo];
    [self.view addSubview:self.labelThree];
    [self.view addSubview:self.imgView];

}

- (UILabel *)labelOne{
    if (_labelOne == nil) {
        _labelOne = [[UILabel alloc]init];
        _labelOne.frame = CGRectMake(20, 100, 200, 30);
        _labelOne.backgroundColor = [UIColor orangeColor];
        _labelOne.text = NSLocalizedString(@"key1", nil);
    }
    return _labelOne;
}

- (UILabel *)labelTwo{
    if (_labelTwo == nil) {
        _labelTwo = [[UILabel alloc]init];
        _labelTwo.frame = CGRectMake(20, 150, 200, 30);
        _labelTwo.backgroundColor = [UIColor lightGrayColor];
        _labelTwo.text = NSLocalizedString(@"key2", nil);
    }
    return _labelTwo;
}

- (UILabel *)labelThree{
    if (_labelThree == nil) {
        _labelThree = [[UILabel alloc]init];
        _labelThree.frame = CGRectMake(20, 200, 200, 30);
        _labelThree.backgroundColor = [UIColor blueColor];
        _labelThree.text = @"标签三未做本地化";
    }
    return _labelThree;
}

- (UIImageView *)imgView{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.frame = CGRectMake(20, 300, 200, 100);
        [_imgView setImage:[UIImage imageNamed:NSLocalizedString(@"imgKey1", nil)]];
    }
    return _imgView;
}


@end
