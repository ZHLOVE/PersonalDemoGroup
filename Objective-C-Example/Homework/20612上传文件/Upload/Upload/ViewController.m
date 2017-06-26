//
//  ViewController.m
//  Upload
//
//  Created by student on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#define kBoundary @"mmqqll" // 分隔字符串
#define kNewLine @"\r\n"        // 换行

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self uploadFile];
}

- (void)uploadFile
{
    //请求的网址
    NSURL *url = [NSURL URLWithString:@"http://192.168.13.28:8080/MJServer/upload"];
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置POST
    request.HTTPMethod = @"POST";
    //设置请求头
    NSString *headerStr = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request setValue:headerStr forHTTPHeaderField:@"Content-Type"];
/*---------------------------构建请求体内容mData--------------------------------------*/
    NSMutableData *mData = [NSMutableData data];
    NSMutableString *mStr = [NSMutableString string];
    //1 文件参数
    [mStr appendString:kNewLine];
    [mStr appendString:@"--"];
    [mStr appendString:kBoundary];
    [mStr appendString:kNewLine];
    [mStr appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"apple分辨率.png\""];
    [mStr appendString:@"Content-Type: image/png"];// 文件类型对应的Content-Type image/jpeg image/png
    [mStr appendString:kNewLine];
    [mStr appendString:kNewLine];
    NSLog(@"%@",mStr);
    [mData appendData:[mStr dataUsingEncoding:NSUTF8StringEncoding]];
    //2 文件数据
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"apple分辨率" ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    [mData appendData:data];
    //3 其他参数
    mStr = [NSMutableString string];
    [mStr appendString:kNewLine];
    [mStr appendString:@"--"];
    [mStr appendString:kBoundary];
    [mStr appendString:kNewLine];
    [mStr appendString:@"Content-Disposition: form-data; name=\"username\""];
    [mStr appendString:kNewLine];
    [mStr appendString:kNewLine];
    [mStr appendString:@"mmqqll"];
    //4. 结尾
    [mStr appendString:@"--"];
    [mStr appendString:kBoundary];
    [mStr appendString:@"--"];
    [mStr appendString:kNewLine];
    NSLog(@"%@",mStr);
    [mData appendData:[mStr dataUsingEncoding:NSUTF8StringEncoding]];
    //设置请求体
    /*---------------------------------发送请求-----------------------------------------*/
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (error!=nil) {
                NSLog(@"%@",dict);
            }else{
                NSLog(@"%@",[error localizedDescription]);
            }
        }else{
            // 连接服务器失败
            NSLog(@"%@",[connectionError localizedDescription]);
        }
    }];
}







































@end
