//
//  ViewController.m
//  SelectFlag
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "SelectFlagViewController.h"

// 1. 声明支持这个协议
@interface ViewController ()<SelectFlagViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryFlagImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectFlagBtnPressed:(id)sender
{
    [self performSegueWithIdentifier:@"SelectFlag" sender:nil];
}

// 2. 实现协议中的方法
- (void)changeFlag:(FlagModel *)flag
{
    self.countryNameLabel.text = flag.name;
    self.countryFlagImageView.image = [UIImage imageNamed:flag.imageName];
}

// 3. 告诉下一个页面你是他的代理

// 1) 如果是沿着连线跳转的 prepareForSegue中设置
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectFlagViewController *destVC =  segue.destinationViewController;
    destVC.delegate = self;
}

// 2) 如果是代码弹出或者push的，直接在弹出的时候对对象设置属性
//SelectFlagViewController *sVC = [[SelectFlagViewController alloc] init];
//[self presentViewController:sVC animated:YES completion:nil];
//sVC.delegate = self;

@end
