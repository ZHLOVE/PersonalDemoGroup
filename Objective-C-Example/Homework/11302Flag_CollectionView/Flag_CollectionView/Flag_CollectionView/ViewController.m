//
//  ViewController.m
//  Flag_CollectionView
//
//  Created by student on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "CollectionViewController.h"
#import "FlagData.h"

@interface ViewController ()<CollectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//沿着连线跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    

    CollectionViewController *destVC = segue.destinationViewController;
    //目标的代理人设为当前控制器
    destVC.delegate = self;
}


// 2. 实现协议中的方法
- (void)changeFlag:(FlagData *)flag
{
//    NSLog(@"%s",__func__);
    self.imageView.image = [UIImage imageNamed:flag.imageName];
    self.label.text = flag.name;
}

@end
