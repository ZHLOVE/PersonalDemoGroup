//
//  ViewController.m
//  下载进度
//
//  Created by niit on 16/4/6.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "ProgressView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet ProgressView *progressView;

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
- (IBAction)sliderChanged:(UISlider *)sender
{
    self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%",sender.value * 100];
    
    self.progressView.progress = sender.value;
}

@end
