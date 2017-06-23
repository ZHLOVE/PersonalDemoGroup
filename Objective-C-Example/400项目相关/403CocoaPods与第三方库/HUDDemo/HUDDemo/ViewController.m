//
//  ViewController.m
//  HUDDemo
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import <MBProgressHUD.h>
#import <SVProgressHUD.h>

@interface ViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 1. MBProgressHUD
- (IBAction)btn1Pressed:(id)sender
{
    // 创建进度条
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    // 加入到当前视图
    [self.view addSubview:hud];
    // 背景变暗
    hud.dimBackground = YES;
    // 文字
    hud.labelText = @"请稍后";
    // 显示出来
    [hud showAnimated:YES whileExecutingBlock:^{
        // 显示后执行的费时操作
        sleep(3);// => [NSThread sleepForTimeInterval:3];
        
    } completionBlock:^{
        // 操作完了之后
        [hud removeFromSuperview];
        hud = nil;
    }];
}

///** Progress is shown using an UIActivityIndicatorView. This is the default. */
//MBProgressHUDModeIndeterminate,
///** Progress is shown using a round, pie-chart like, progress view. */
//MBProgressHUDModeDeterminate,
///** Progress is shown using a horizontal progress bar */
//MBProgressHUDModeDeterminateHorizontalBar,
///** Progress is shown using a ring-shaped progress view. */
//MBProgressHUDModeAnnularDeterminate,
///** Shows a custom view */
//MBProgressHUDModeCustomView,
///** Shows only labels */
//MBProgressHUDModeText

- (IBAction)btn2Pressed:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view] ;
    [self.view addSubview:hud];
    
    hud.dimBackground = YES;
    // hud的转的样式
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    // 文字
    hud.labelText = @"请稍后";
    // 代理
    hud.delegate = self;
    // 在执行某任务过程中显示,执行完会隐藏
    [hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
   
}

- (void)myTask // 一个费时的操作
{
    float progress = 0.0f;
    while(progress <1.0f)
    {
        progress += 0.01f;
        hud.progress = progress;
        usleep(50000);//0.05s
    }
}

// 自定义
- (IBAction)btn3Pressed:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view] ;
    [self.view addSubview:hud];
    
    hud.dimBackground = YES;
    // hud的转的样式
    hud.mode = MBProgressHUDModeCustomView;
    // 文字
    hud.labelText = @"请稍后";
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark3.png"]];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
        hud = nil;
    }];
}

- (IBAction)btn4Pressed:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view] ;
    [self.view addSubview:hud];
    
    hud.dimBackground = YES;
    // hud的转的样式 纯文字
    hud.mode = MBProgressHUDModeText;
    // 文字
    hud.labelText = @"请稍后";
    
    hud.yOffset = 50.0f;
    hud.xOffset = 50.0f;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
        hud = nil;
    }];
}

#pragma mark MBProgressHUD Delegatge Method
// 当hud隐藏式会调用该方法
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // 彻底移除,不占内存。
    [hud removeFromSuperview]; // 从父视图移除
    hud = nil;// 指针设置为空
}

#pragma mark - 2. SVProgressHUD

- (IBAction)btn5Pressed:(id)sender
{
    [SVProgressHUD showInfoWithStatus:@"abc123"];
}

- (IBAction)btn6Pressed:(id)sender
{
    [SVProgressHUD showSuccessWithStatus:@"abc123"];
}

- (IBAction)btn7Pressed:(id)sender
{
    [SVProgressHUD showErrorWithStatus:@"abc123"];
}

- (IBAction)btn8Pressed:(id)sender
{
    [SVProgressHUD dismiss];
}

- (IBAction)btn9Pressed:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在登陆"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack]; // 背景变暗
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);// 全局队列
    dispatch_async(queue, ^{
        // 登陆的操作
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
        });
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
    
}
@end
