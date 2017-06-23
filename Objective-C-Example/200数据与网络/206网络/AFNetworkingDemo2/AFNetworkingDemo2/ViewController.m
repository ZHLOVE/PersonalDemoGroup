//
//  ViewController.m
//  AFNetworkingDemo2
//
//  Created by niit on 16/4/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLable;
@property (weak, nonatomic) IBOutlet UIImageView *selImageView;
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

#pragma mark - GET方式
- (IBAction)getBtnPressed:(id)sender
{
    
    NSString *urlStr = @"http://120.25.226.186:32812/login";
    
    // 参数放到一个字典里
    NSDictionary *dict = @{@"username":self.usernameTextField.text,@"pwd":self.passwordTextField.text,@"type":@"JSON"};
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 1.请求时提交的数据格式
    mgr.requestSerializer = [AFJSONRequestSerializer serializer ];// JSON
    
    // 2. 返回的数据格式
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];// 二进制数据
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];// 指定返回的数据是JSON
    
    [mgr GET:urlStr parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",responseObject);
        
//        if(dict[@"error"])
//        {
//            NSLog(@"登陆失败:%@",dict[@"error"]);
//        }
//        else
//        {
//            NSLog(@"登陆成功:%@",dict[@"error"]);
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
    
    
}

#pragma mark - POST 方式
- (IBAction)postBtnPressed:(id)sender
{
    NSString *urlStr = @"http://120.25.226.186:32812/login";
    
    // 参数放到一个字典里
    NSDictionary *dict = @{@"username":self.usernameTextField.text,@"pwd":self.passwordTextField.text,@"type":@"JSON"};
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 1.请求时提交的数据格式
    mgr.requestSerializer = [AFJSONRequestSerializer serializer ];// JSON
    
    // 2. 返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];// 二进制数据

    [manager POST:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];


//    [mgr POST:urlStr parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dict);
//        
//        if(dict[@"error"])
//        {
//            NSLog(@"登陆失败:%@",dict[@"error"]);
//        }
//        else
//        {
//            NSLog(@"登陆成功:%@",dict[@"error"]);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
//    }];

}


// 运行时异常时候，找出问题的流程
// 要找出出现异常的代码行.
// 方式1：通过加入断点逐步分析出来
// 方式2: 在Break point Navigatior里添加异常断点
         //Add Exception BreakPoint
         //运行调试，产生异常，沿着调用堆栈找到你出错的代码行


#pragma mark - 上传文件
- (IBAction)uploadBtnPressed:(id)sender
{
    NSString *urlStr = @"http://120.25.226.186:32812/upload";
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 1.请求时提交的数据格式
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer ];// JSON
    
    // 2. 返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];// 二进制数据
    
    // 上传
    [mgr POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       // 构建请求的body
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"test321" withExtension:@"png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test321" ofType:@"png"];
//        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"test321.png" mimeType:@"image/png"];
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}

#pragma mark - 下载
- (IBAction)downloadBtnPressed:(id)sender
{
    NSString *urlStr = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request= [NSURLRequest requestWithURL:url];

    // 下载的路径
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进行当中，可以显示进度
        NSLog(@"__test,%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBar.progress = downloadProgress.fractionCompleted;// progress
            self.progressLable.text = [NSString stringWithFormat:@"%.1f %%",downloadProgress.fractionCompleted*100];
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 设定下载到的位置
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 下载完成执行的代码
        NSLog(@"下载完成");
    }];
    [downloadTask resume];
    
    
    
}
- (IBAction)uploadImageBtnPressed:(id)sender {
}

@end
