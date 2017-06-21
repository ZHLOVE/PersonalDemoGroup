//
//  WebVC.m
//  WingsBurning
//
//  Created by MBP on 16/9/3.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "WebVC.h"

@interface WebVC()

@property(nonatomic,copy) NSString *titleString;

@end

@implementation WebVC

- (instancetype)initWithTitleString:(NSString *)title;
{
    self = [super init];
    if (self) {
        self.navigationItem.title = title;
        self.titleString = title;
    }
    return self;
}

- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.titleString isEqualToString:@"服务协议"]) {
        [self showServiceAgreement];
    }else if ([self.titleString isEqualToString:@"隐私协议"]){
        [self showPrivacyPolicy];
    }
}

- (void)showServiceAgreement{
    CGRect tempFrame = self.view.frame;
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height - 64)];
    NSURL* url = [NSURL URLWithString:@"http://www.shangchao.la/service.html"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)showPrivacyPolicy{
    CGRect tempFrame = self.view.frame;
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height - 64)];
    NSURL* url = [NSURL URLWithString:@"http://www.shangchao.la/private.html"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}


@end
