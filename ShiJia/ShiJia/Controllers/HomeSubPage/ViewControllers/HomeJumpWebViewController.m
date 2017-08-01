//
//  HomeJumpWebViewController.m
//  ShiJia
//
//  Created by 峰 on 2017/2/18.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "HomeJumpWebViewController.h"
#import <WebKit/WebKit.h>

@interface HomeJumpWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) WKWebView *webV;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation HomeJumpWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webV];
    self.navigationController.navigationBarHidden = NO;
    [_webV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),2)];
    [self.view addSubview:_progressView];

    [_webV addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    [_webV addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    [_webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr.length > 0?_urlStr : @""]]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (WKWebView *)webV{
    if (!_webV) {
        _webV = [[WKWebView alloc]init];
        _webV.backgroundColor = [UIColor clearColor];
//        _webV.UIDelegate = self;
//        _webV.navigationDelegate = self;
    }
    return _webV;
}



//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    //获取网页title
//
//    NSString *htmlTitle = @"document.title";
//    NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:htmlTitle];
//    self.title = titleHtmlInfo;
//}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    DDLogInfo(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webV) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webV.estimatedProgress animated:YES];
        if(_webV.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webV) {
            self.title = self.webV.title;

        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];

        }
    }
    else {

        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_webV removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webV removeObserver:self forKeyPath:@"title"];
    // if you have set either WKWebView delegate also set these to nil here
    [_webV setNavigationDelegate:nil];
    [_webV setUIDelegate:nil];
}

@end
