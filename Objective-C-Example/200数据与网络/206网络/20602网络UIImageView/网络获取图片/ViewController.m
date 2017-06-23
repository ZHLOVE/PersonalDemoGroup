//
//  ViewController.m
//  网络获取图片
//
//  Created by niit on 16/3/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "WebImageView.h"
#import "UIImageView+WebImage.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray *arr;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.arr = @[@"http://www.apple.com.cn/mac-pro/images/static/processor.jpg",@"http://www.apple.com.cn/mac-pro/images/static/memory.jpg",@"http://www.apple.com.cn/mac-pro/images/static/graphics.jpg",@"http://www.apple.com.cn/mac-pro/images/static/storage.jpg",@"http://www.apple.com.cn/mac-pro/images/static/thermal.jpg",@"http://www.apple.com.cn/mac-pro/images/static/fan.jpg",@"http://www.apple.com.cn/mac-pro/images/static/expansion.jpg",@"http://www.apple.com.cn/mac-pro/images/static/wifi.jpg",@"http://www.apple.com.cn/mac-pro/images/static/design.jpg",@"http://www.apple.com.cn/mac-pro/images/static/comingsoon.jpg"];

    // 练习要求:
    // 使用gcd及performSelectorInBackground方法实现多线程下载图片并显示到界面上,不能卡主界面,并且gcd采用不同的方式(串行、并发)都实现一下
}

- (IBAction)btnPressed:(id)sender
{
    // 网址字符串
    NSString *urlStr = @"http://www.apple.com.cn/mac-pro/images/static/processor.jpg";
    // 网址对象
    NSURL *url = [NSURL URLWithString:urlStr];
    // 获取数据
    NSData *data = [NSData dataWithContentsOfURL:url];
    // 图像对象
    UIImage *image = [UIImage imageWithData:data];
    // 图像视图
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.frame = CGRectMake(100, 100, 100, 100);
    // 添加到视图
    [self.view addSubview:imgView];
}

- (IBAction)btn2Pressed:(id)sender
{
    
    for (int i = 0;i<self.arr.count;i++)
    {
        // 网址字符串
        NSString *urlStr = self.arr[i];
        // 网址对象
        NSURL *url = [NSURL URLWithString:urlStr];
        // 获取数据
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 图像对象
        UIImage *image = [UIImage imageWithData:data];
        // 图像视图
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = CGRectMake((i%3)*100 ,(i/3)*100,100, 100);
        // 添加到视图
        [self.view addSubview:imgView];
    }
    // 一起出来
    
}
- (IBAction)btn3Pressed:(id)sender
{
 
    // 定义一个自定义串行队列
//    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
//    dispatch_queue_t queue = dispatch_queue_create("myQueue",DISPATCH_QUEUE_CONCURRENT);// 自定义并发任务
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);// 普通优先级全局并发队列
    
    // 1. 往queue中放入一个任务，任务中循环了10次
//    dispatch_async(queue, ^{
//        
//        for (int i = 0;i<self.arr.count;i++)
//        {
//            // 网址字符串
//            NSString *urlStr = self.arr[i];
//            // 网址对象
//            NSURL *url = [NSURL URLWithString:urlStr];
//            // 获取数据
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            // 图像对象
//            UIImage *image = [UIImage imageWithData:data];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 图像视图
//                UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
//                imgView.frame = CGRectMake((i%3)*100 ,(i/3)*100+150,100, 100);
//                // 添加到视图
//                [self.view addSubview:imgView];
//            });
//
//        }
//    });
    
    //2. 往queue中放入10个任务,串行队列是顺序执行的,并发队列并发执行
//    for (int i = 0;i<self.arr.count;i++)
//    {
//        // 网址字符串
//        NSString *urlStr = self.arr[i];
//        // 网址对象
//        NSURL *url = [NSURL URLWithString:urlStr];
//        
//        dispatch_async(queue, ^{
//                // 获取数据
//                NSData *data = [NSData dataWithContentsOfURL:url];
//                // 图像对象
//                UIImage *image = [UIImage imageWithData:data];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // 图像视图
//                    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
//                    imgView.frame = CGRectMake((i%3)*100 ,(i/3)*100+150,100, 100);
//                    // 添加到视图
//                    [self.view addSubview:imgView];
//                });
//        });
//    }
    
    
    // 3. 定义了10个自定义串行queue，这些队列是并发的,队里里面的任务是串行 (<- 理论上不应该这么去做)
//    for (int i = 0;i<self.arr.count;i++)
//    {
//        dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
//        
//        // 网址字符串
//        NSString *urlStr = self.arr[i];
//        // 网址对象
//        NSURL *url = [NSURL URLWithString:urlStr];
//
//        dispatch_async(queue, ^{
//                // 获取数据
//                NSData *data = [NSData dataWithContentsOfURL:url];
//                // 图像对象
//                UIImage *image = [UIImage imageWithData:data];
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // 图像视图
//                    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
//                    imgView.frame = CGRectMake((i%3)*100 ,(i/3)*100+150,100, 100);
//                    // 添加到视图
//                    [self.view addSubview:imgView];
//                });
//        });
//    }
    
    // 4
    [self.activityView startAnimating];
    
    // 创建了一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("myQueue",DISPATCH_QUEUE_CONCURRENT);
    // 创建了一个GCD组
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0;i<self.arr.count;i++)
    {
        NSString *urlStr = self.arr[i];
        // 网址对象
        NSURL *url = [NSURL URLWithString:urlStr];
        
        // 往组里添加任务
        dispatch_group_async(group, queue, ^{
            // 获取数据
            NSData *data = [NSData dataWithContentsOfURL:url];
            // 图像对象
            UIImage *image = [UIImage imageWithData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                // 图像视图
                UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
                imgView.frame = CGRectMake((i%3)*100 ,(i/3)*100+150,100, 100);
                // 添加到视图
                [self.view addSubview:imgView];
            });
        });
    }
//    dispatch_group_notify(group, queue, ^{// 如果要等所有任务执行完之后执行什么使用此方法
//        // 等到所有group中的任务执行完毕
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.activityView stopAnimating];
//        });
//    });
    // 修改 =>
    dispatch_group_notify(group,dispatch_get_main_queue(), ^{
            [self.activityView stopAnimating];
    });
    
    
}

- (IBAction)btn4Pressed:(id)sender
{
    [self performSelectorInBackground:@selector(doInBack) withObject:nil];
}

- (void)doInBack
{
    for (int i = 0;i<self.arr.count;i++)
    {
        // 网址字符串
        NSString *urlStr = self.arr[i];
        // 网址对象
        NSURL *url = [NSURL URLWithString:urlStr];
        // 获取数据
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 图像对象
        UIImage *image = [UIImage imageWithData:data];

        [self performSelectorOnMainThread:@selector(addImageViewWithArr:) withObject:@[image,@(i)] waitUntilDone:NO];
    }
}

- (void)addImageViewWithArr:(NSArray *)arr
{
    UIImage *image = arr[0];
    int i = [arr[1] intValue];
    // 图像视图
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.frame = CGRectMake((i%3)*100 ,(i/3)*100,100, 100);
    // 添加到视图
    [self.view addSubview:imgView];
}


- (IBAction)btn5Pressed:(id)sender
{
    for (int i = 0;i<self.arr.count;i++)
    {
        // 网址字符串
        NSString *urlStr = self.arr[i];
        // 网址对象
        NSURL *url = [NSURL URLWithString:urlStr];
        // 创建图像视图
        WebImageView *imgView = [[WebImageView alloc] initWithURL:url];// 自定义的类
//        UIImageView *imgView = [[UIImageView alloc] initWithURL:url];// 分类方式
        
        imgView.frame = CGRectMake((i%3)*100 ,(i/3)*100,100, 100);
        // 添加到视图
        [self.view addSubview:imgView];
    }
}




@end
