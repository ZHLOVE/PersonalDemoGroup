//
//  ViewController.m
//  本地化
//
//  Created by student on 16/4/12.
//  Copyright © 2016年 Five. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *lacalLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //区域信息
    NSLocale *local  = [NSLocale currentLocale];
    self.lacalLabel.text = [local displayNameForKey:NSLocaleIdentifier value:local.localeIdentifier];
    
    //国家
    NSLog(@"NSLocalCountryCode:%@",[local objectForKey:NSLocaleCountryCode]);
    //文字
    [self.labels[0] setText:NSLocalizedString(@"One", @"One 给翻译看的提示")];// (key,提示信息)
    [self.labels[1] setText:NSLocalizedString(@"Two", @"Two 给翻译看的提示")];
    [self.labels[2] setText:NSLocalizedString(@"Three", @"Three 给翻译看的提示")];
    [self.labels[3] setText:NSLocalizedString(@"Tour", @"Four 给翻译看的提示")];
    //图片
     self.flagImageView.image = [UIImage imageNamed:NSLocalizedString(@"flag_en", @"One 给翻译看的")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
