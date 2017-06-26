//
//  ViewController.m
//  验证码练习
//
//  Created by student on 16/3/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"
#import "LoadImages.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *showImgBtnView;
@property (weak, nonatomic) IBOutlet UILabel *chineseNameLabel;
@property (strong,nonatomic) NSArray *imgBtnArray;

@property (strong,nonatomic) NSMutableArray *imgViewArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self showChineseLabel];
    LoadImages *images = [[LoadImages alloc]init];
    [images loadImagesToArray];
    //存8个随机图片
    self.imgBtnArray = [[images makeBtnImages] copy];
    [self showImages];
}

- (void)showImages{
   
    LoadImages *images = [[LoadImages alloc]init];
    [images loadImagesToArray];
    //存8个随机图片
    self.imgBtnArray = [[images makeBtnImages] copy];
    //遍历按钮图片数组
    for (UIButton *imgBtn in self.imgBtnArray) {
    //当前第几个按钮图片
    NSUInteger index = self.showImgBtnView.subviews.count;
    //每行放几个
    int rowCount = 4;
    //根据每行放几个，计算当前按钮图片放第几行第几列
    int col = index % rowCount; //第几列
    NSUInteger row = index / rowCount; //第几行
    //图片宽
    int imgBtnW = self.showImgBtnView.bounds.size.width/rowCount -10;
    //图片高
    int imgBtnH = self.showImgBtnView.bounds.size.height/2 -10;
    //位置X,Y
    int imgBtnX = col * (imgBtnW +10);
    NSUInteger imgBtnY = row * (imgBtnH +10);
    // 创建
    [imgBtn addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    imgBtn.frame = CGRectMake(imgBtnX, imgBtnY, imgBtnW, imgBtnH);
    [self.showImgBtnView addSubview:imgBtn];
    }
}


- (void)showChineseLabel{
    NSArray *chineseNameArray = @[@"动物",@"衣服",@"水果",@"台灯",@"鞋子"];
    int index = arc4random()%5;
    NSString *str = [NSString stringWithFormat:@"请点击下图中所有的\t%@",chineseNameArray[index]];
    self.chineseNameLabel.text = str;
//    NSLog(@"%@",chineseNameArray[index]);测试随机
    
}


- (IBAction)refreshBtnPressed:(UIButton *)sender {
    //移除所有子视图
    [self.showImgBtnView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self showChineseLabel];
    [self showImages];
}

- (IBAction)imgBtnPressed:(UIButton *)sender{
    //以按钮坐标记录tag值
    int t = sender.frame.origin.x + sender.frame.origin.y + 10;
    if (sender.subviews.count < 2) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gou"]];
        imageView.frame = CGRectMake(60, 60, 20, 17);
        imageView.tag = t;
        [sender addSubview:imageView];
    }else{
        for (UIImageView *subImg in sender.subviews) {
            if (subImg.tag==t) {
                [subImg removeFromSuperview];
            }
        }
    }
}

- (IBAction)loginBtnPressed:(UIButton *)sender {
    NSString *resultStr = self.chineseNameLabel.text;

    for (UIButton *v in self.showImgBtnView.subviews) {
        NSLog(@"%@",v);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
