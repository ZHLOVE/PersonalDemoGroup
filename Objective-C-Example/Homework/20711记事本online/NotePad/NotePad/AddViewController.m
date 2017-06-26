//
//  AddViewController.m
//  NotePad
//
//  Created by 马千里 on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "AddViewController.h"

#import "NetManager.h"
#import <MBProgressHUD.h>
@interface AddViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)addNote:(UIButton *)sender {
    //创建菊花
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    //加入到当前视图
    [self.view addSubview:hud];
    //背景变暗
    hud.dimBackground = YES;
    //文字
    hud.labelText = @"请稍后...";
    //显示出来
    [hud show:YES];
//    [hud showAnimated:YES whileExecutingBlock:^{
//        //显示后执行费时操作
//        [self save];
////        sleep(2);
//    }completionBlock:^{
//        //操作完之后
//        [hud removeFromSuperview];
//        hud = nil;
//    }];
    [self save];
    
}

- (void)save{
    NSDate *now = [NSDate date];
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [time stringFromDate:now];
    NSLog(@"%@,%@",self.textView.text,dateStr);
    [NetManager addFromNet:self.textView.text andDate:dateStr successBlock:^(NSString *str) {
        if (str) {
            //hud和alertControl不要同时用
            [hud setLabelText:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
            
        }
    } failBlock:^(NSError *error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud setLabelText:[error localizedDescription]];
            [hud hide:YES];
        });
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
