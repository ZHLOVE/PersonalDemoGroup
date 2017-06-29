//
//  FeedbackVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self showFeedBackWebView];
}

- (void)showFeedBackWebView{
    UIWebView* webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    NSURL* url = [NSURL URLWithString:@" "];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)setUpUI{
    self.navigationItem.title = @"反馈意见";
}

@end
