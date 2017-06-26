//
//  ViewController.m
//  20202
//
//  Created by student on 16/3/16.
//  Copyright © 2016年 马千里. All rights reserved.
//
//1. 放置一个TextView
//2. ViewController监听程序的以下通知
//* 将取消活动
//* 已经进入后台
//* 将进入前台
//* 已经激活
//记录这些事件及时间,显示在TextView中
//如下:(最新的信息显示在最上方)


#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *mArray;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation ViewController

- (NSMutableArray *)mArray{
    if (_mArray == nil) {
        _mArray = [NSMutableArray array];
        return _mArray;
    }
    return _mArray;
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *textViewData = [NSUserDefaults standardUserDefaults];
    self.mArray = [[textViewData objectForKey:@"text"] mutableCopy];
//    NSLog(@"%@",self.textView.text);
    if (self.textView.text.length < 1) {
        self.textView.text = [self.mArray componentsJoinedByString:@"\n"];  //拼接数组,并显示
    }
//    ViewController2 *vc2 = [[ViewController2 alloc]init];
//    self.textViewColor = [UIColor colorWithRed:[vc2.redValueLabel.text intValue] green:[vc2.greenValueLabel.text intValue] blue:[vc2.blueValueLabel.text intValue] alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAction1) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAction2) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAction3) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAction4) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSUserDefaults *color = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [color objectForKey:@"color"];
    
    CGFloat red = [dict[@"r"] intValue]/255.0;
    CGFloat green = [dict[@"g"] intValue]/255.0;
    CGFloat blue = [dict[@"b"] intValue]/255.0;
    self.textView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.00];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appAction1{
    NSDate *now = [NSDate date];
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"HH:mm:ss"];
    NSString *dateStr = [time stringFromDate:now] ;
    NSMutableString *mStr = [[dateStr stringByAppendingString:@" *将取消活动"]mutableCopy];
    [self.mArray insertObject:mStr atIndex:0];
    self.textView.text = [self.mArray componentsJoinedByString:@"\n"];  //拼接数组,并显示
//    NSLog(@"%@",mStr);
}

- (void)appAction2{
    NSDate *now = [NSDate date];
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"HH:mm:ss"];
    NSString *dateStr = [time stringFromDate:now] ;
    NSMutableString *mStr = [[dateStr stringByAppendingString:@" *将进入后台"]mutableCopy];
    [self.mArray insertObject:mStr atIndex:0];
    self.textView.text = [self.mArray componentsJoinedByString:@"\n"];  //拼接数组,并显示
    // 保存
    NSUserDefaults *textViewData = [NSUserDefaults standardUserDefaults];
    [textViewData setObject:self.mArray forKey:@"text"];
    [textViewData synchronize];
}

- (void)appAction3{
    NSDate *now = [NSDate date];
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"HH:mm:ss"];
    NSString *dateStr = [time stringFromDate:now] ;
    NSMutableString *mStr = [[dateStr stringByAppendingString:@" * 将进入前台"]mutableCopy];
    [self.mArray insertObject:mStr atIndex:0];
    self.textView.text = [self.mArray componentsJoinedByString:@"\n"];  //拼接数组,并显示
    //    NSLog(@"%@",mStr);
}

- (void)appAction4{
    NSDate *now = [NSDate date];
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"HH:mm:ss"];
    NSString *dateStr = [time stringFromDate:now] ;
    NSMutableString *mStr = [[dateStr stringByAppendingString:@" * 已经激活"]mutableCopy];
    [self.mArray insertObject:mStr atIndex:0];
    self.textView.text = [self.mArray componentsJoinedByString:@"\n"];  //拼接数组,并显示
    //    NSLog(@"%@",mStr);
}

@end
