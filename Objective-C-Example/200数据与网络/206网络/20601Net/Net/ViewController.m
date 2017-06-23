//
//  ViewController.m
//  Net
//
//  Created by niit on 16/3/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
{
    NSMutableData *mData;
    
    int dataLength;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 本机地址:
    // localhost
    // 127.0.0.1
    
    // 局域网地址
    // 192.168.13.2
    
    // 互联网上的
    //http://120.25.226.186:32812/
    
    // NSURL
    NSURL *url = [NSURL URLWithString:@"http://192.168.13.28:8080/MJServer/login?username=123&pwd=123&method=get&type=JSON"];

    NSLog(@"协议:%@",url.scheme);
    NSLog(@"主机:%@",url.host);
    NSLog(@"路径:%@",url.relativePath);
    NSLog(@"路径:%@",url.path);
    NSLog(@"端口:%@",url.port);//  http默认是80端口 0~65535 (1024以下的是系统)
    NSLog(@"请求:%@",url.query);
    
}


- (IBAction)btn1Pressed:(id)sender
{
    // 1. 网址
    NSURL *url = [NSURL URLWithString:@"http://192.168.13.9:32812//MJServer/login?username=123&pwd=123&method=get&type=JSON"];
    
    // 2. 请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 3;// 设定超时时间如果3秒内服务器不回应，那就认为得不到数据了，不等下去了。
    
    // 3. 发请求 (同步请求,等待服务器返回数据回来后继续向下运行)
    NSURLResponse *response;
    NSError *error;
    
    NSDate *d1 = [NSDate date];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDate *d2 = [NSDate date];
    NSTimeInterval t = [d2 timeIntervalSinceDate:d1];
    NSLog(@"花费了%.3f秒",t);
    
    NSHTTPURLResponse *httpResponse = response;
    NSLog(@"状态码 %i",httpResponse.statusCode);
    NSLog(@"相应头 %@",httpResponse.allHeaderFields);
    
    // 数据 -> 文字
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 显示结果
    NSLog(@"%@",str);
    
}
- (IBAction)btn2Pressed:(id)sender
{
    // 异步队列block方式
    
    // 1. 网址
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812//MJServer/login?username=123&pwd=123&method=get&type=JSON"];
    
    // 2. 请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发请求 (异步请求,不会卡主线程,在后台请求数据，数据回来后，执行block里的处理方法)
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // 数据 -> 文字
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // 显示结果
        NSLog(@"%@",str);
    }];


}

- (IBAction)btn3Pressed:(id)sender
{
    // 异步 代理方式
    
    // 1. 网址
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/images/minion_02.png"];
    
    // 2. 请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发请求 (异步请求,不会卡主线程,在后台请求数据，数据回来后，执行block里的处理方法)
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // 发出请求 (不会卡主界面)
    
    mData = [NSMutableData data];
    [connection start];
    
}

- (IBAction)btn4Pressed:(id)sender
{
    
    // 异步队列block方式
    
    // 1. 网址 POST
    NSURL *url = [NSURL URLWithString:@"http://192.168.13.28:8080/MJServer/login"];
    
    //?username=123&pwd=123&method=get&type=JSON
    
    // 2. 请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";// 默认GET请求，指定为POST
    
    //字符串转换成数据放在请求体中
    NSData *postData = [@"username=123&pwd=123&method=get&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];//NSString -> NSData
    request.HTTPBody = postData;
    
    // 3. 发请求 (异步请求,不会卡主线程,在后台请求数据，数据回来后，执行block里的处理方法)
    NSDate *d1 = [NSDate date];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // 数据 -> 文字
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // 显示结果
        NSLog(@"%@",str);
    }];
    
    NSDate *d2 = [NSDate date];
    NSTimeInterval t = [d2 timeIntervalSinceDate:d1];
    NSLog(@"花费了%.3f秒",t);
}

#pragma mark - NSURLConnectionData Delegate Method

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *h = response;
    NSLog(@"1. 接收到服务器响应 %i %@",h.statusCode,h.allHeaderFields);
    NSLog(@"数据总共大小是:%@",h.allHeaderFields[@"Content-Length"]);
    dataLength = [h.allHeaderFields[@"Content-Length"] intValue];
}

// 注意这个方法会多次运行，因为数据会被拆分成块发送，块的大小不是固定的
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mData appendData:data];
    NSLog(@"2. 接收到服务器的数据%i (进度:%i %%)",data.length,(int)(mData.length * 100.0 / dataLength));
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"3. 接收完成，显示到界面");
    UIImage *img = [UIImage imageWithData:mData];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imgView];
    imgView.frame = CGRectMake(100, 200, img.size.width, img.size.height);
    
}

@end
