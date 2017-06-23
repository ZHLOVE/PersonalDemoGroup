//
//  ViewController.m
//  本地化
//
//  Created by niit on 16/4/12.
//  Copyright © 2016年 M. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *localeLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 区域信息
    NSLocale *locale = [NSLocale currentLocale];
    self.localeLabel.text = [locale displayNameForKey:NSLocaleIdentifier value:locale.localeIdentifier];
    
    // 国家Code
    NSLog(@"NSLocalCountryCode:%@",[locale objectForKey:NSLocaleCountryCode]);
    
    // 文字 
    [self.labels[0] setText:NSLocalizedString(@"One", @"One 给翻译看的提示")];// (key,提示信息)
    [self.labels[1] setText:NSLocalizedString(@"Two", @"Two 给翻译看的提示")];
    [self.labels[2] setText:NSLocalizedString(@"Three", @"Three 给翻译看的提示")];
    [self.labels[3] setText:NSLocalizedString(@"Tour", @"Four 给翻译看的提示")];
    
    // 图片
    self.flagImageView.image = [UIImage imageNamed:NSLocalizedString(@"flag_en", @"给翻译看的提示")];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
