//
//  ViewController.m
//  综合练习1
//
//  Created by niit on 16/2/26.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "Shop.h"
#import "ShopView.h"

// 下面继续改进
// 1. 可以使用懒加载的地方改成懒加载
// 2. 商品图片视图、商品文字标签放在一个View中，作为一个整体，添加到shopsView
// 3. 创建一个商品的类，存放商品的信息。从plist读取的信息，转换成商品类对象数组放在self.shops中

// 4. 商品的视图

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *shopsView;

@property (nonatomic,weak) UIButton *addBtn;
@property (nonatomic,weak) UIButton *removeBtn;

@property (nonatomic,strong) NSArray *shops;// 商品类对象的数组

@end

@implementation ViewController

- (NSArray *)shops
{
    if(_shops == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shops" ofType:@"plist"];
        NSArray *tmpArr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *d in tmpArr)
        {
            Shop *s = [Shop shopWithDictionary:d];
            [mArr addObject:s];
        }
        _shops = mArr;
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"shops" ofType:@"plist"];
//    self.shops = [NSArray arrayWithContentsOfFile:path];
    
    self.addBtn = [self addButtonWithImage:@"add" frame:CGRectMake(30, 30, 50, 50) action:@selector(add)];
    self.removeBtn = [self addButtonWithImage:@"remove" frame:CGRectMake(230, 30, 50, 50) action:@selector(remove)];
    
    [self checkState];
}

- (UIButton *)addButtonWithImage:(NSString *)imageName frame:(CGRect)frame action:(SEL)action
{
    UIButton *btn  = [[UIButton alloc] initWithFrame:frame];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_highlited"]]  forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_disabled"]] forState:UIControlStateDisabled];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}

- (void)add
{
    // 当前是第几个商品,可以根据当前shopsView中的子视图计算。也可以自己定义一个属性或实例变量来保存。
    int index = self.shopsView.subviews.count;
    
    // 每行放几个商品
    int rowCount = 3;
    
    // 根据每行放几个，计算当前商品在第几行第几列
    int col = index % rowCount;
    int row = index / rowCount;
    
    // 图片的大小
    int imageW = 80;
    int imageH = 80;
    
    // 根据shopsView总宽度和每行商品数量计算一下商品之每列的间隔大小
    int shopViewWidth = self.shopsView.frame.size.width;
    int colMargin = (shopViewWidth - rowCount * imageW ) / (rowCount - 1);
    int rowMargin = 15;
    
    // 计算图片实际的位置
    int imageX = col * (imageW + colMargin);
    int imageY = row * (imageH + rowMargin);
    
    // 得到当前商品的信息字典
    Shop *shop = self.shops[index];
    
    // 创建
    ShopView *shopView = [[ShopView alloc] init];
    shopView.frame = CGRectMake(imageX, imageY, imageW, imageH + 10);
    shopView.shop = shop;
    
    [self.shopsView addSubview:shopView];
    
    // 检查按钮状态
    [self checkState];
}

- (void)remove
{
    [[self.shopsView.subviews lastObject] removeFromSuperview];
    [[self.shopsView.subviews lastObject] removeFromSuperview];
    
    [self checkState];
}

- (void)checkState
{
    // 商品个数>0 则删除按钮可按
    self.removeBtn.enabled = (self.shopsView.subviews.count>0);
    // 商品个数<总数 则添加按钮可按
    self.addBtn.enabled = (self.shopsView.subviews.count<self.shops.count);
}


@end
