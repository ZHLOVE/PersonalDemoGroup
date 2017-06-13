//
//  ViewController.m
//  LXYGradientProgressView
//
//  Created by 宣佚 on 15/8/19.
//  Copyright (c) 2015年 Liuxuanyi. All rights reserved.
//

#import "ViewController.h"
#import "LXYGradientProgressView.h"

@interface ViewController ()
{
    LXYGradientProgressView *progressView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = CGRectMake(0, 65.0f, CGRectGetWidth([[self view] bounds]), 1.0f);
    progressView = [[LXYGradientProgressView alloc] initWithFrame:frame];
    
    [self.view addSubview:progressView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)simulateProgress
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CGFloat increment = (arc4random() % 5) / 10.0f + 0.1;
        CGFloat progress  = [progressView progress] + increment;
        [progressView setProgress:progress];
        if (progress < 1.0) {
            
            [self simulateProgress];
        }
    });
}

-(IBAction)start:(id)sender
{
    [progressView startAnimating];
    [self simulateProgress];
}

-(IBAction)stop:(id)sender
{
    [progressView stopAnimating];
}

@end
