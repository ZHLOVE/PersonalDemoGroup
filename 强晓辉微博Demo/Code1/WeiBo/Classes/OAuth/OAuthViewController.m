//
//  OAuthViewController.m
//  WeiBo
//
//  Created by student on 16/4/28.
//  Copyright © 2016年 BNG. All rights reserved.
//

#define kAppKey @"650393162"
#define kAppSecret @"79b7f566f70739a4b187085380fe29c1"
#define kredirect_url @"http://www.niit.com.cn"

//#define kAppKey @"773821087"
//#define kAppSecret @"13a5f32a7b69890ce1723d2fd839e4c3"
//#define kredirect_url @"http://www.igeekhome.cn"

#import "UserAccount.h"
#import "OAuthViewController.h"

#import "NetWorkTools.h"

@interface OAuthViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end


@implementation OAuthViewController

//self.view还没创建时候，第一次用到self.view的时候
//- (void)loadView{
//    [super loadView];
//    self.view = [[UIWebView alloc]init];
//}

- (void)viewDidLoad{
    [super viewDidLoad];
    //判断，如果已经登录，没必要再登录
    if ([[UserAccount sharedUserAccount] isLogined]) {
        NSLog(@"已经登录了");
        return;
    }else{
        [self showLogin];
    }
    
}

- (void)showLogin{
    self.webView = [[UIWebView alloc]init];
    self.webView.frame = [UIScreen mainScreen].bounds;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    //1 打开新浪授权页面https://api.weibo.com/oauth2/authorize?client_id=650393162&redirect_uri=http://www.niit.com.cn
    NSString *apiStr = @"https://api.weibo.com/oauth2/authorize";
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",apiStr,kAppKey,kredirect_url];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

//授权成功后自动跳转的函数
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@",request.URL.absoluteString);
    
    //如果不包含我们的网址，
    if (![request.URL.absoluteString hasPrefix:kredirect_url]) {
        return YES;
    }
    
    if ([request.URL.query hasPrefix:@"code="]) {
        NSLog(@"授权成功");
        //RequestToken换取Access_Token
        [self loadAccessToken:[request.URL.query substringFromIndex:5]];
        
    }else{
        NSLog(@"授权失败");
    }
    return NO;
}

- (void)loadAccessToken:(NSString *)requestToken{
    // 请求
    //1. 路径: oauth2/access_token
    NSString *path = @"oauth2/access_token";
    //2. 参数
    NSDictionary *dict = @{@"client_id":kAppKey,
                           @"client_secret":kAppSecret,
                           @"grant_type":@"authorization_code",
                           @"code":requestToken,
                           @"redirect_uri":kredirect_url};// 这里的key value都不要搞错了，否则认证失败，400错误
    //3. 发送请求
    [[NetWorkTools sharedNetWorkTools] POST:path parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 二进制数据 -> 字典
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        // 存到UserAccount对象中
        UserAccount *account = [UserAccount sharedUserAccount];
        [account setValuesForKeysWithDictionary:dict];
        //设置具体过期时间
        account.expires_Date = [NSDate dateWithTimeInterval:account.expires_in sinceDate:[NSDate date]];
        NSLog(@"登录过期时间:%@",account.expires_Date);
        NSLog(@"%@",account);
        // 请求获取用户信息
        [account loadUserInfo];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}




@end
