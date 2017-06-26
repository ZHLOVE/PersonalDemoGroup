//
//  ViewController.m
//  综合练习1
//
//  Created by niit on 16/2/26.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

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
        _shops = [NSArray arrayWithContentsOfFile:path];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 添加按钮
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
    
    
    UIView *shopView = [[UIView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH + 10)];
    shopView.backgroundColor = [UIColor redColor];
    
    // 添加图片视频
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, imageW, imageH)];
    imgView.image = [UIImage imageNamed:shop.icon];
    [shopView addSubview:imgView];
    
    // 添加文本标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,imageH, imageW, 10)];
    label.text = shop.name;
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [shopView addSubview:label];
    
    
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
