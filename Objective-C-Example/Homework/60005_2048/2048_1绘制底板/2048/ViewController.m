//
//  ViewController.m
//  2048
//
//  Created by niit on 16/3/21.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"


// 解决问题的基本思路:
// 拆分页面
// 大问题 -> 小问题
// 一大块功能 -> 一步步功能
// 拆分成模块 拆分成步骤
// 1 分析有哪些页面，分出模块
// 2 单个模块单个页面 分出子模块、子流程

@interface ViewController ()

@property (nonatomic,strong) UIView *boxView;

@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// 用于计算不同屏幕大小时的按比例的尺寸
#define W(x) ((x)* kScreenWidth / 320.0)
#define H(y) ((y)* kScreenHeight / 568.0)


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = kRGBBakcgroundColor;
    
//    制作流程:
//    1. 绘制底板
//    * 画大底板
    [self drawBackBox];
//    * 画每个小格子 4*4
    [self drawBackCell];
    
//    2. 产生新格子
//    点击随机产生2个新的格子(后面移动做好后,改为每次移动之后产生新格子)
//    (需要考虑使用必要的容器保存相关数据)
//    
//    3. 一个方向上的手势移动
//    * 移动
//    * He并
//    
//    4. 所有方向
//    
//    5. 加入音效
//    
//    6. 输赢判断
}

// 1. 绘制底板
- (void)drawBackBox
{
    // 底板宽度 = 格子宽度 * 格子数量 + 格子间距 * 格子数量
    CGFloat boxWidth = W(kCellWidth) * N + W(kCellPadding) * N * 2 + W(kBoxPadding) * 2;
    
    self.boxView = [[UIView alloc] init];
    // 大小
    self.boxView.bounds = CGRectMake(0, 0, boxWidth, boxWidth);
    // 中心点
    self.boxView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    // 背景色
    self.boxView.backgroundColor =  kRGBBoxColor;
    // 圆角
    self.boxView.layer.cornerRadius = 5;
    [self.view addSubview:self.boxView];
    
}

// 2. 绘制底板上小格子
- (void)drawBackCell
{
    for(int i=0;i<N;i++) // 行
    {
        for (int j=0; j<N; j++) // 列
        {
            // 格子位置 = 格子宽度 * j + 格子间隔 * j *2 + 盒子外围间隔
            CGFloat cellX = W(kCellWidth) * j + W(kCellPadding) * j * 2 + W(kCellPadding) + W(kBoxPadding);
            CGFloat cellY = H(kCellWidth) * i + H(kCellPadding) * i * 2 + H(kCellPadding) + H(kBoxPadding);
            
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellX, cellY, W(kCellWidth), W(kCellWidth))];
            // 颜色
            cellView.backgroundColor = kRGBCellColor;
            // 圆角
            cellView.layer.cornerRadius = 3;
            [self.boxView addSubview:cellView];
        }
    }
}

@end
