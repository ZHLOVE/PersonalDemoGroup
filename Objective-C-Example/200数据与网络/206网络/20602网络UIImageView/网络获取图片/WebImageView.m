//
//  WebImageView.m
//  网络获取图片
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "WebImageView.h"

@interface WebImageView()<NSURLConnectionDataDelegate>
{
    NSMutableData *mData;
    int allLength;
}
@end

@implementation WebImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {

        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        // 1. 同步方式(会卡住界面)
//        NSError *error;
//        NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//        if(error == nil)
//        {
//            self.image = [UIImage imageWithData:data];
//        }
        
        // 2. 异步方式(block方式)
//        [NSURLConnection sendAsynchronousRequest:request  // 网络请求
//                                           queue:[NSOperationQueue mainQueue] // 数据回来后在哪个队列里执行block
//                               completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//            if(connectionError == nil)
//            {
//                self.image = [UIImage imageWithData:data];
//            }
//        }];
        
        // 3. 代理方式
        NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [con start];
        
    }
    return self;
}

// 发出请求 （请求头 请求体)
// 返回 （返回头Response 数据）
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"接收到相应response:%@",response);
    NSHTTPURLResponse  *httpResponse = response;
    allLength = [httpResponse.allHeaderFields[@"Content-Length"] intValue];
    
    mData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mData appendData:data];
    NSLog(@"接收到:%i字节 (%i%%)",data.length,mData.length*100/allLength);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"接收完成");
    self.image = [[UIImage alloc] initWithData:mData];
    
}

@end
