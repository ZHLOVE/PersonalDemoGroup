//
//  ViewController.m
//  LetsPlay
//
//  Created by MBP on 2017/2/8.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "ViewController.h"
#import <Lottie/Lottie.h>

#define ratio  [UIScreen mainScreen].bounds.size.height / 667
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property(nonatomic,strong) LAAnimationView *lottieView;
@property(nonatomic,strong) UIButton *upBtn;
@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,strong) NSArray *animationArr;

@end

static int indexAnimation;

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    indexAnimation = 0;
    self.animationArr = [NSArray arrayWithObjects:@"9squares-AlBoardman",@"HamburgerArrow",@"IconTransitions",@"LottieLogo1",@"LottieLogo1_masked",@"LottieLogo2",@"MotionCorpse-Jrcanest",@"PinJump",@"TwitterHeart",@"vcTransition1",@"vcTransition2",@"Watermelon",@"data",nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.lottieView.frame = CGRectMake(0, 60, screenWidth, screenHeight/2);
}

- (void)setUpUI{
    [self.view addSubview:self.lottieView];
    [self.view addSubview:self.upBtn];
    [self.view addSubview:self.nextBtn];
}

- (void)playUpAnimation{
    [self.lottieView removeFromSuperview];
    indexAnimation--;
    if (indexAnimation < 0) {
       indexAnimation = [[NSString stringWithFormat:@"%lu",(unsigned long)self.animationArr.count] intValue] - 1;
    }
    NSString *strAnimation = [self.animationArr objectAtIndex:indexAnimation];
    self.lottieView = [LAAnimationView animationNamed:strAnimation];
    self.lottieView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.lottieView];
    [self.lottieView play];
}

- (void)playNextAnimation{
    [self.lottieView removeFromSuperview];
    indexAnimation++;
    if (indexAnimation == self.animationArr.count) {
        indexAnimation = 0;
    }
    NSString *strAnimation = [self.animationArr objectAtIndex:indexAnimation];
    self.lottieView = [LAAnimationView animationNamed:strAnimation];
    self.lottieView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.lottieView];
    [self.lottieView play];
}



- (UIButton *)upBtn{
    if (_upBtn == nil) {
        _upBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, screenHeight-100, 100, 40)];
        [_upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_upBtn setTitle:@"上一个" forState:UIControlStateNormal];
        _upBtn.backgroundColor = [UIColor blackColor];
        [_upBtn addTarget:self action:@selector(playUpAnimation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upBtn;
}

- (UIButton *)nextBtn{
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-120, screenHeight-100, 100, 40)];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setTitle:@"下一个" forState:UIControlStateNormal];
        _nextBtn.backgroundColor = [UIColor blackColor];
        [_nextBtn addTarget:self action:@selector(playNextAnimation) forControlEvents:UIControlEventTouchUpInside];

    }
    return _nextBtn;
}

@end
