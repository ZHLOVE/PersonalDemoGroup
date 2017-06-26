//
//  ViewController.m
//  DownLoad
//
//  Created by student on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
{
    NSMutableData *mData;
    unsigned long long allLength;// 总长度
    NSFileHandle *fh;// 文件指针
    
    
    BOOL bDownLoading;// 正在下载
    NSURLConnection *con;// 连接对象
    unsigned long long curLength;// 当前长度
}

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//     [self downloadSmallFile1];
//     [self downloadSmallFile2];
}
- (IBAction)btnPressed:(id)sender {
//     [self downloadBigFile3];
    [self downloadBigFile4];

}

#pragma mark 下载小文件
/**下载小文件1*/
- (void)downloadSmallFile1{
    for (int i = 1; i<=16; i++) {
        //异步线程
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //获取数据
            NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/resources/images/minion_%02d.png",i];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];//保存的路径
            NSLog(@"保存位置:%@",filePath);
            [data writeToFile:filePath atomically:YES];
        });
    }
}

/**下载小文件2*/
- (void)downloadSmallFile2{
    for(int i=1;i<=16;i++)
    {
        
        // 获取数据
        NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/resources/images/minion_%02d.png",i];// ?
        NSLog(@"%@",urlStr);
        NSURL *url = [NSURL URLWithString:urlStr];
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            NSLog(@"%@",connectionError.localizedDescription);
            // 保存下来
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];// 保存的路径
            NSLog(@"保存位置:%@",filePath);
            [data writeToFile:filePath atomically:YES];
        }];
    }
}

#pragma mark 下载大文件1（NSData,有内存问题）
//- (void)downloadBigFile1
//{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        // 获取数据
//        NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/resources/videos.zip"];
//        NSURL *url = [NSURL URLWithString:urlStr];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        // 保存下来
//        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];// 保存的路径
//        NSLog(@"保存位置:%@",filePath);
//        [data writeToFile:filePath atomically:YES];
//
//
//    });
//}
#pragma mark - 下载大文件2 (有内存问题)

//- (void)downloadBigFile2
//{
//    NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/resources/videos.zip"];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [con start];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"%s",__func__);
//    NSHTTPURLResponse *r = response;
//    allLength = [r.allHeaderFields[@"Content-Length"] intValue];
//    mData = [NSMutableData data];
//    self.progressView.progress = 0.0f;
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    NSLog(@"%s",__func__);
//    [mData appendData:data];
//    NSLog(@"%i%%",mData.length*100/allLength);
//
//    self.progressView.progress = (float)mData.length/allLength;
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSLog(@"%s",__func__);
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString *filePath = [path stringByAppendingPathComponent:connection.currentRequest.URL.lastPathComponent];// 保存的路径
//    NSLog(@"保存位置:%@",filePath);
//    [mData writeToFile:filePath atomically:YES];
//}

#pragma mark - 下载大文件3(边下载边保存,不会有内存问题)
//- (void)downloadBigFile3
//{
//    NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/resources/videos/VT2.mp4"];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    [connection start];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//    //接收到请求
//    NSLog(@"开始接收%s",__func__);
//    NSHTTPURLResponse *r = response;
//    allLength = [r.allHeaderFields[@"Content-Length"] intValue];
//    mData = [NSMutableData data];
//    self.progressView.progress = 0.0f;
//    //创建文件
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString *filePath = [path stringByAppendingPathComponent:connection.currentRequest.URL.lastPathComponent];//保存的路径
//    [fm createFileAtPath:filePath contents:nil attributes:nil];
//    //创建文件读写的指针
//    fh = [NSFileHandle fileHandleForWritingAtPath:filePath];
//    NSLog(@"%@",filePath);
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    [fh writeData:data];
//    NSLog(@"接收数据:%i%%",fh.offsetInFile*100/allLength);
//    self.progressView.progress = (float)fh.offsetInFile/allLength;
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    NSLog(@"接收完毕 %s",__func__);
//    [fh closeFile];
//}


#pragma mark - 下载大文件4(断点续传)
- (void)downloadBigFile4
{
    if (bDownLoading)//是正在下载
    {
        //如果正在下载，停止
        [con cancel];
        //关闭文件指针
        [fh closeFile];
        bDownLoading = NO;
        NSLog(@"暂停下载");
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/resources/videos/VT2.mp4"];
        NSURL *url = [NSURL URLWithString:urlStr];
        //临时文件路径
        NSString *tmpFilePath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@.tmp",url.lastPathComponent];
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:tmpFilePath]) {
            //1文件不存在，新下载
            [fm createFileAtPath:tmpFilePath contents:nil attributes:nil];
            //创建文件读写的指针
            fh = [NSFileHandle fileHandleForWritingAtPath:tmpFilePath];
            curLength = 0;
        }else{
            //2文件存在就续传
            //打开文件
            fh = [NSFileHandle fileHandleForWritingAtPath:tmpFilePath];
            //指针移到最后
            curLength = [fh seekToEndOfFile];
        }
        //设置请求头，告诉服务器断电续传的位置
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //bytes=当前长度~(指请求从指定长度之后的数据)
        NSString *rangeStr = [NSString stringWithFormat:@"bytes=%lld-",curLength];
        [request setValue:rangeStr forHTTPHeaderField:@"Range"];
        allLength = [self getFileLengthWithURL:url];//获取文件长度
        con = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [con start];
        bDownLoading = YES;
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"连接错误:%@",[error localizedDescription]);
    bDownLoading = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"接收到相应头: %s",__func__);
    NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
    NSLog(@"当前长度:%lld,待接收长度:%lld",curLength,[r.allHeaderFields[@"Content-Length"] longLongValue]);
    //allLength = curLength + [r.allHeaderFields[@"Content-Length"] unsignedLongLongValue];
    self.progressView.progress = (float)curLength/allLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [fh writeData:data];
    NSLog(@"接收数据:%lld%%",fh.offsetInFile*100/allLength);
    self.progressView.progress = (float)fh.offsetInFile/allLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"接收完毕 %s",__func__);
    [fh closeFile];
    bDownLoading = NO;
    
    // 移动到Documents下
    NSURL *url = con.currentRequest.URL;
    NSString *tmpFilePath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@.tmp",url.lastPathComponent];
    NSString *docFilePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",url.lastPathComponent];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm moveItemAtPath:tmpFilePath toPath:docFilePath error:nil];
}


// 网络上文件的长度(不下载）
- (unsigned long long)getFileLengthWithURL:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";// GET POST
    // HEAD方式下:服务器只返回相应头,不返回响应体
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.expectedContentLength;// 长度
}


















@end
