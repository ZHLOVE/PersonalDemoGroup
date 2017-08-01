//
//  SJVIPProtocolViewController.m
//  ShiJia
//
//  Created by 峰 on 16/10/12.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVIPProtocolViewController.h"

@interface SJVIPProtocolViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView      *H5Web;


@end

@implementation SJVIPProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ProtocolTitle;
    _H5Web = self.H5Web;
    self.view.backgroundColor =[UIColor whiteColor];

    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];

    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:ProtocalHtmlName
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_H5Web loadHTMLString:htmlCont baseURL:baseURL];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{

    DDLogInfo(@"webViewDidStartLoad");
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    //    [MBProgressHUD hideHUDForView:webView animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    DDLogInfo(@"webViewDidFinishLoad");

}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DDLogInfo(@"===didFailLoadWithError:%@", error);


}


//H5界面
-(UIWebView *)H5Web{
    if (!_H5Web) {
        _H5Web = [UIWebView new];
        [self.view addSubview:_H5Web];

        _H5Web.autoresizingMask = 0xff;
        _H5Web.delegate = self;
        _H5Web.scalesPageToFit = YES;
        _H5Web.backgroundColor = [UIColor whiteColor];
        _H5Web.mediaPlaybackRequiresUserAction = NO;
        _H5Web.opaque = NO;
        _H5Web.dataDetectorTypes = UIDataDetectorTypeAll;

        WEAKSELF
        [_H5Web mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf.view);
        }];
    }
    return _H5Web;
}

@end
