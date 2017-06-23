//
//  ViewController.m
//  图片浏览器
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,assign) int cur;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 从打包中得到文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"imageData" ofType:@"plist"];
    NSLog(@"%@",path);
    
    self.dataList = [NSArray arrayWithContentsOfFile:path];
    
    [self showImageAndInfo];
    
    self.leftBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftBtnPressed:(id)sender
{
    self.cur--;
    if(self.cur<=0)
    {
        self.leftBtn.enabled = NO;
    }
    self.rightBtn.enabled = YES;
    
    [self showImageAndInfo];
}

- (IBAction)rightBtnPressed:(id)sender
{
    self.cur++;
    if(self.cur>=self.dataList.count-1)
    {
        self.rightBtn.enabled = NO;
    }
    self.leftBtn.enabled = YES;
    [self showImageAndInfo];
}

- (void)showImageAndInfo
{
    NSDictionary *info = self.dataList[self.cur];
    
    self.imageView.image = [UIImage imageNamed:info[@"icon"]];
    self.infoLabel.text = info[@"desc"];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%i/%i",self.cur+1,self.dataList.count];
}



@end
