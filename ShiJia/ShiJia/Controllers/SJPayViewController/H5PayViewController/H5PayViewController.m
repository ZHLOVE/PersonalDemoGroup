//
//  H5PayViewController.m
//  ShiJia
//
//  Created by 峰 on 2017/3/29.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "H5PayViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "SJPayFinishViewController.h"
#import "TPIMAlertView.h"
#import "WXApi.h"
#import "SJPhoneFareViewModel.h"

@interface H5PayViewController ()<UIWebViewDelegate,PhoneFareDelegate>
@property (strong, nonatomic) UIWebView *webV;
@property (strong, nonatomic) SJPhoneFareViewModel *viewModel;
@end

@implementation H5PayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webV];
    self.view.backgroundColor = [UIColor whiteColor];
    [_webV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.automaticallyAdjustsScrollViewInsets = YES;

    self.title = @"支付收银台";
    [MBProgressHUD showMessag:@"正在加载" toView:self.view];
    [self loadPayWebView];
    _viewModel = [SJPhoneFareViewModel new];
    _viewModel.phonefaredelegate = self;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavgationLeftItem];
}

-(void)loadPayWebView{

    NSURL *url = [NSURL URLWithString:self.payParams.redirectUrl];
    NSString *body = [NSString stringWithFormat: @"sessionId=%@", self.payParams.sessionId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [_webV loadRequest:request];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{

    if ([[request.URL description] hasPrefix:@"weixin://"]) {
        if (![WXApi isWXAppInstalled]) {
            [MBProgressHUD showError:@"未安装微信" toView:nil];
            return NO;
        }
    }
    if ([[request.URL description]containsString:@"success.jsp"]) {
        if ([[request.URL description]containsString:@"success.jsp?"]) {
            // SUCCESS 成功 PAYLG  登记 PAYING  支付中 FAILED 失败
            NSString *SuccessString = @"orderstatus=SUCCESS";
            NSString *failedString  = @"orderstatus=FAILED";
            if ([[request.URL description] containsString:SuccessString]) {
                [self DoPaySuccessAction];
            }
            if ([[request.URL description] containsString:failedString]) {
                [MBProgressHUD showError:@"支付失败" toView:self.view];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            return NO;
        }else{
            [self OrderStatusRequest];
            return NO;
        }
    }
    /*
     
     生产环境的判断链接：
     if(url.contains("wx.tenpay.com/cgi-bin/mmpayweb-bin")){
     //是微信h5支付连接就decode一下url
     try {
     url = URLDecoder.decode(url, "UTF-8");
     Log.e("error test",url);
     } catch (UnsupportedEncodingException e) {
     e.printStackTrace();
     }
     //截取url里是否含有回调地址
     if(url.contains("redirect_url=http://www.js.10086.cn/upay")){
     Map extraHeaders = new HashMap();
     extraHeaders.put("Referer", "http://www.js.10086.cn");
     view.loadUrl(url, extraHeaders);
     }else if(url.contains("redirect_url=http://p.12580.com”)){
     Map extraHeaders = new HashMap();
     extraHeaders.put("Referer", "http://p.12580.com");
     view.loadUrl(url, extraHeaders);
     }
     }
     
     
     测试环境的判断链接：
     if(url.contains("wx.tenpay.com/cgi-bin/mmpayweb-bin")){
     //是微信h5支付连接就decode一下url
     try {
     url = URLDecoder.decode(url, "UTF-8");
     Log.e("error test",url);
     } catch (UnsupportedEncodingException e) {
     e.printStackTrace();
     }
     //截取url里是否含有回调地址
     if(url.contains("redirect_url=http://183.213.31.9:61004/wps/service/tpfWePayCallBackTy")){
     Map extraHeaders = new HashMap();
     extraHeaders.put("Referer", "http://www.js.10086.cn");
     view.loadUrl(url, extraHeaders);
     }else if(url.contains("redirect_url=http://183.213.31.9:61004/wps/service/ussWeCallBack”)){
     Map extraHeaders = new HashMap();
     extraHeaders.put("Referer", "http://p.12580.com");
     view.loadUrl(url, extraHeaders);
     }
     }
     */
#ifdef JiangSu
    if ([[request.URL description]containsString:@"wx.tenpay.com/cgi-bin/mmpayweb-bin"]) {
    
        
        
    }
    
    
#else
    
    
#endif

    
    
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    DDLogError(@"--错误是--%@------",[error localizedDescription]);

}

-(void)initNavgationLeftItem{
    self.navigationItem.leftBarButtonItems = nil;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.backgroundColor =[UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"black_back_btn"] forState:UIControlStateNormal];

    [button addTarget:self
               action:@selector(backAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];

    self.navigationItem.leftBarButtonItem = item;
}

-(void)backAction:(id)sender{

    //[self.navigationController popViewControllerAnimated:YES];


    TPIMAlertView *alert = [[TPIMAlertView alloc]initWithTitle:@"影片购买" message:@"佳片已恭候多时，真的不约？" leftButtonTitle:@"默默离开" rightButtonTitle:@"继续购买"];
    [alert show];
    WEAKSELF
    [alert setLeftButtonClickBlock:^{
        if (_fromOrderPay) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIWebView *)webV{
    if (!_webV) {
        _webV = [[UIWebView alloc]init];
        _webV.delegate = self;
        _webV.backgroundColor = [UIColor whiteColor];

    }
    return _webV;
}

-(void)DoPaySuccessAction{
    SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
    payFinishVC.productServiceID = _dictParams.serviceId ;
    payFinishVC.productEntity = _dictParams;
    payFinishVC.recommArray = self.recommArray;
    payFinishVC.isFromOrderPay = self.fromOrderPay;
    [self.navigationController pushViewController:payFinishVC animated:YES];

}

-(void)OrderStatusRequest{
    [MBProgressHUD showMessag:@"订单处理中" toView:self.view];
    [_viewModel QueryOrderStatus:self.orderNoString merchantCode:self.merchantCodeString];
}

-(void)OrderStatus:(BOOL)success{
    [MBProgressHUD hideHUD];
    if (success) {
        [self DoPaySuccessAction];
    }else{
        [MBProgressHUD showError:@"订单已提交处理" toView:self.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

-(void)HandPhoneFareError:(NSError *)error{
    [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    if (_fromOrderPay) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
