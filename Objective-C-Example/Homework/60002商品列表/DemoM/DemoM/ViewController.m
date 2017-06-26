//
//  ViewController.m
//  DemoM
//
//  Created by student on 16/2/26.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"
#import "LoadImage.h"

@interface ViewController ()



@property (nonatomic,strong) NSMutableArray *imageNames;
@property (nonatomic,strong) NSMutableArray *imageIcons;

@property (nonatomic,assign) float x;
@property (nonatomic,assign) float y;
@property (nonatomic,assign) int count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.x = 0;
    self.y = -124.5;
    self.count = 0;
    
    [self.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"add_highlighted"] forState:UIControlStateHighlighted];
    [self.addBtn setImage:[UIImage imageNamed:@"add_disabled"] forState:UIControlStateDisabled];
    
    [self.removeBtn setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    [self.removeBtn setImage:[UIImage imageNamed:@"remove_disabled"] forState:UIControlStateHighlighted];
    [self.removeBtn setImage:[UIImage imageNamed:@"remove_disabled"] forState:UIControlStateDisabled];
    

    self.imageNames = [[LoadImage imageNames] mutableCopy];
    self.imageIcons = [[LoadImage imageIcons] mutableCopy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addImages
{
    // 当前是第几个
    int index = self.uiViewLoadImages.subviews.count/2;
    
    
    // 每行放几个
    int rowCount = 3;
    
    // 第几行第几列的
    int col = index % rowCount;
    int row = index / rowCount;
    
    //图片起始的位置
    int imageX = 0;
    int imageY = 0;
    // 图片的大小
    int imageW = 80;
    int imageH = 80;
    
    // 计算一下商品之每列的间隔
    int shopViewWidth = self.uiViewLoadImages.frame.size.width;
    int colMargin = (shopViewWidth - rowCount * imageW ) / (rowCount - 1);
    int rowMargin = 10;
    
    // 计算图片实际的位置
    imageX = col * (imageW + colMargin);
    imageY = row * (imageH + rowMargin);
    
    // 添加图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX,imageY, imageW, imageH)];
    imgView.image = [UIImage imageNamed:self.imageIcons[index]];
    
    
    
    // 添加文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageX, imageY+imageH, imageW, 10)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageX, imageY+imageH/3, imageW, 10)];
    label.text = self.imageNames[index];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [self.uiViewLoadImages addSubview:label];
//    [imgView addSubview:label];
    [self.uiViewLoadImages addSubview:imgView];

    [self checkState];

}

- (void)removeImages
{
    [[self.uiViewLoadImages.subviews lastObject] removeFromSuperview];
    [[self.uiViewLoadImages.subviews lastObject] removeFromSuperview];
    [self checkState];
}




- (IBAction)addBtnPressed:(UIButton *)sender {
    
    [self addImages];
}

- (IBAction)removeBtnPressed:(UIButton *)sender {
    [self removeImages];
 }

- (void)checkState
{
    self.removeBtn.enabled = (self.uiViewLoadImages.subviews.count>0);
    self.addBtn.enabled = (self.uiViewLoadImages.subviews.count<6*2);
}



@end
