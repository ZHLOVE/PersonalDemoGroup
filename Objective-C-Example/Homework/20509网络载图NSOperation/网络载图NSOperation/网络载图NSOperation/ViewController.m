//
//  ViewController.m
//  网络载图NSOperation
//
//  Created by student on 16/3/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "def.h"
@interface ViewController ()

@property(nonatomic,strong) NSArray *arr;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.arr = @[@"http://www.apple.com.cn/mac-pro/images/static/processor.jpg",@"http://www.apple.com.cn/mac-pro/images/static/memory.jpg",@"http://www.apple.com.cn/mac-pro/images/static/graphics.jpg",@"http://www.apple.com.cn/mac-pro/images/static/storage.jpg",@"http://www.apple.com.cn/mac-pro/images/static/thermal.jpg",@"http://www.apple.com.cn/mac-pro/images/static/fan.jpg",@"http://www.apple.com.cn/mac-pro/images/static/expansion.jpg",@"http://www.apple.com.cn/mac-pro/images/static/wifi.jpg",@"http://www.apple.com.cn/mac-pro/images/static/design.jpg",@"http://www.apple.com.cn/mac-pro/images/static/comingsoon.jpg"];
    
}

- (IBAction)imageBtnPressed:(UIButton *)sender {
    [self.activityView startAnimating];
    //队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = self.arr.count;//线程数=图片数量
    for (int i=0;i<self.arr.count;i++) {
        NSString *urlStr = self.arr[i];
        NSNumber *num = [NSNumber numberWithInt:i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:urlStr forKey:num];
        NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(imageFromUrl:) object:[dict copy]];
        [queue addOperation:op];
    }
    NSBlockOperation *opStopActivityView = [NSBlockOperation blockOperationWithBlock:^{
        [self.activityView stopAnimating];
    }];
    [queue addOperation:opStopActivityView];

    
}

- (IBAction)cancelBtnPressed:(UIButton *)sender {
    
    [self.activityView stopAnimating];
}

- (void)imageFromUrl:(NSDictionary *)dict{
    int num = [dict.allKeys[0] intValue];
    NSString *urlStr = [dict objectForKey:dict.allKeys[0]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake((num%3)*110 ,(num/3)*110+150,100,100);
        [self.view addSubview:imageView];
//        [self.activityView stopAnimating];
    }];

}
@end
