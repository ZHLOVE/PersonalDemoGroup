//
//  ViewController.m
//  GoodsList
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "GoodsModel.h"
#import "GoodsView.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray *goodsList;

@end

@implementation ViewController

// 懒加载
- (NSArray *)goodsList
{
    if(_goodsList == nil)
    {
        _goodsList = [GoodsModel goodsArr];
    }
    return _goodsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView.backgroundColor = [UIColor grayColor];
    
    // 序号
    int index = 0;
    for(GoodsModel *m in self.goodsList)
    {
        GoodsView *goodView = [GoodsView loadGoodsView];
        
        // 根据序号计算一下第几行第几列
        int row = index/2;
        int col = index%2;
        
        // 根据行、列、宽、高计算视图位置偏移
        CGFloat width = 160;
        CGFloat height = 200;
        CGFloat x = width * col;
        CGFloat y = height * row;
        
        // 设定frame
        goodView.frame = CGRectMake(x, y, width, height);
        // 设定模型数据
        goodView.goodsModel = m;
        
        // 添加到scrollView
        [self.scrollView addSubview:goodView];

        // 为按钮添加事件
        goodView.buyBtn.tag = 100+index;
        [goodView.buyBtn addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
        
        index++;
    }
    
    self.scrollView.contentSize = CGSizeMake(0, 200*index/2);
}

- (void)buy:(UIButton *)btn
{
    int goodInex = btn.tag - 100;
    GoodsModel *goods = self.goodsList[goodInex];
    NSLog(@"商品图片:%@",goods.picture);
}


@end
