//
//  PayInfoViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "PayInfoViewController.h"

@interface PayInfoViewController ()
@property(nonatomic,weak) IBOutlet UIImageView *headImg;
@property(nonatomic,weak) IBOutlet UILabel *nameLab;
@property(nonatomic,weak) IBOutlet UILabel *phoneLab;
@property(nonatomic,weak) IBOutlet UILabel *totalLab;
@property(nonatomic,weak) IBOutlet UIButton *payBtn;
@end

@implementation PayInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"购买信息";
    [self initNavigationView];
    
    [self initUI];
    [self loadData];
}
-(void)initUI{
    self.headImg.layer.cornerRadius = 45/2;
    self.headImg.layer.borderColor = UIColorHex(d8d8d8).CGColor;
    self.headImg.layer.masksToBounds = YES;
    self.payBtn.backgroundColor = kColorBlueTheme;
    self.totalLab.textColor = RGB(255, 159, 1, 1);
}
-(void)loadData{
    self.nameLab.text = [HiTVGlobals sharedInstance].nickName;
    self.phoneLab.text = [HiTVGlobals sharedInstance].phoneNo;
    [self.headImg setImageWithURL:[NSURL URLWithString:[HiTVGlobals sharedInstance].faceImg] placeholderImage:[UIImage imageNamed:@"登录"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
