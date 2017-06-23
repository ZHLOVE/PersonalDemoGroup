//
//  ViewController.m
//  上传
//
//  Created by niit on 16/3/30.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#define kBoundary @"niit123456" // 分隔字符串(不用中文和特殊字符)
#define kNewLine @"\r\n"        // 换行

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self uploadFile];
}

// 上传数据需要构建请求体内容如下:

//------WebKitFormBoundary4m9jOGTBCcbMCB4E
//Content-Disposition: form-data; name="file"; filename="gdg.jpg"
//Content-Type: image/jpeg
//
//文件二进制数据
//------WebKitFormBoundary4m9jOGTBCcbMCB4E
//Content-Disposition: form-data; name="username"
//
//abc
//------WebKitFormBoundary4m9jOGTBCcbMCB4E--

// 内容说明:
// 第一部分: 文件参数
//--分隔字符串
//Content-Disposition: form-data; name="file"; filename="文件名" // 文件名
//Content-Type: text/plain   // 文件类型 // Content-Type参考: http://tool.oschina.net/commons/
//
// 第二部分: 上传的文件数据
// 数据
// 第三部分: 其他参数
//--分隔字符串
//Content-Disposition: form-data; name="username"
//
//abc
// 第四部分: 结尾
//--分割字符串

- (void)uploadFile
{
    
    // 请求的网址
    NSURL *url = [NSURL URLWithString:@"http://192.168.13.28:8080/MJServer/upload"];
    // 请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置为POST
    request.HTTPMethod = @"POST";
    // 设置请求头
    NSString *headerStr = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request setValue:headerStr forHTTPHeaderField:@"Content-Type"];
    
//----------------------------------------------------------------------------------------------------
    // 构建请求体内容mData
    
    NSMutableData *mData = [NSMutableData data];
    NSMutableString *mStr = [NSMutableString string];
    //1. 文件参数
    [mStr appendString:kNewLine];
    [mStr appendString:@"--"];
    [mStr appendString:kBoundary];
    [mStr appendString:kNewLine];
    [mStr appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"2.txt\""];
    [mStr appendString:kNewLine];
    [mStr appendString:@"Content-Type: text/plain"];// 文件类型对应的Content-Type image/jpeg image/png
    [mStr appendString:kNewLine];
    [mStr appendString:kNewLine];
    NSLog(@"%@",mStr);
    [mData appendData:[mStr dataUsingEncoding:NSUTF8StringEncoding]];
    //2. 文件的数据
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    [mData appendData:data];
    //3. 其他参数
    mStr = [NSMutableString string];
    [mStr appendString:kNewLine];
    [mStr appendString:@"--"];
    [mStr appendString:kBoundary];
    [mStr appendString:kNewLine];
    [mStr appendString:@"Content-Disposition: form-data; name=\"username\""];
    [mStr appendString:kNewLine];
    [mStr appendString:kNewLine];
    [mStr appendString:@"abc"];
    [mStr appendString:kNewLine];
    //4. 结尾
    [mStr appendString:@"--"];
    [mStr appendString:kBoundary];
    [mStr appendString:@"--"];
    [mStr appendString:kNewLine];
    NSLog(@"%@",mStr);
    [mData appendData:[mStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 设置请求体
    request.HTTPBody = mData;
//--------------------------------------------------------------------------------------------------------------
    
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(connectionError == nil)
        {
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if(error!= nil)
            {
                NSLog(@"%@",dict);
            }
            else
            {
                NSLog(@"%@",[error localizedDescription]);
            }
        }
        else
        {
            // 连接服务器失败
            NSLog(@"%@",[connectionError localizedDescription]);
        }
    }];
    
    
    
    
}

@end
