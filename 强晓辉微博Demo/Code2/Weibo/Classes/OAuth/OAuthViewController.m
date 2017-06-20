//
//  OAuthViewController.m
//  Weibo
//
//  Created by qiang on 4/28/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "OAuthViewController.h"

#import "NetworkTools.h"

#import "UserAccount.h"
#import <SVProgressHUD.h>

//App Key：773821087
//App Secret：13a5f32a7b69890ce1723d2fd839e4c3
//授权回调页: http://www.igeekhome.cn
//取消授权回调页：http://www.igeekhome.cn

#define kAppKey  @"773821087"
#define kAppSecret @"13a5f32a7b69890ce1723d2fd839e4c3"
#define kRedirectURI @"http://www.igeekhome.cn"

@interface OAuthViewController()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation OAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 判断，如果已经登陆过，没必要在登录
    if([[UserAccount sharedUserAccount] isLogined])
    {
        NSLog(@"已经登录了");
        return;
    }
    else
    {
        [self showLoginView];
    }
    
}

- (void)showLoginView
{
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = [UIScreen mainScreen].bounds;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    // 1. 打开新浪授权网页
//    https://api.weibo.com/oauth2/authorize?client_id=3701443959&redirect_uri=http://www.niit.com.cn
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",kAppKey,kRedirectURI];
    NSLog(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

// 授权后
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);

    if(![request.URL.absoluteString hasPrefix:kRedirectURI])
    {
        return YES;
    }
    
    NSLog(@"%@",request.URL.query);
    if([request.URL.query hasPrefix:@"code="])
    {
        NSLog(@"授权成功");
        [SVProgressHUD showWithStatus:@"授权成功,正在登录"];
        NSLog(@"使用授权的RequestToken,换取Access_Token");
        [self requestAccessToken:[request.URL.query substringFromIndex:5]];
    }
    else
    {
        NSLog(@"授权失败");
    }
    
    return NO;
}

// 获取用户信息
- (void)requestAccessToken:(NSString *)reqestToken
{
    // 请求
    //1. 路径: oauth2/access_token
    NSString *path = @"oauth2/access_token";
    //2. 参数
    NSDictionary *dict = @{@"client_id":kAppKey,
                           @"client_secret":kAppSecret,
                           @"grant_type":@"authorization_code",
                           @"code":reqestToken,
                           @"redirect_uri":kRedirectURI};// 这里的key value都不要搞错了，否则认证失败，400错误
    //3. 发送请求
    [[NetworkTools sharedNetwrokTools] POST:path parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 二进制数据 -> 字典
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        // 存到UserAccount对象中
        UserAccount *account = [UserAccount sharedUserAccount];
        [account setValuesForKeysWithDictionary:dict];
        // 设置具体过期时间 = 当前时间 + 过多少秒过期
        account.expires_Date = [NSDate dateWithTimeInterval:account.expires_in sinceDate:[NSDate date]];
        NSLog(@"%@",account.expires_Date); // 自己账户登录自己创建的app 5年后过期 其他用户的weibo登录你的app 3天
        NSLog(@"%@",account);
        // 请求获取用户信息
        [account requstUserInfoSuccesBlock:^(UserAccount *account) {
            NSLog(@"%@ 登录成功!",account.screen_name);
            // 隐藏ProgressHUD
            [SVProgressHUD dismiss];
            // 关闭登录视图控制器
            [self dismissViewControllerAnimated:YES completion:nil];
            // 发通知让AppDelegate切换至欢迎页
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiactionRootSwitchViewController object:nil userInfo:@{@"VC":@"Welcome"}];
            
        } failBlock:^(NSError *error) {
            NSLog(@"请求数据失败:%@",[error localizedDescription]);
        }];
        
        
        // 在请求到用户数据之后，关闭这个登录界面
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}


@end
