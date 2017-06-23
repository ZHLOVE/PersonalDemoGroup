//
//  ViewController2.m
//  testWeak
//
//  Created by niit on 16/3/30.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController2.h"
#import "NetManager.h"

@interface ViewController2()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
@implementation ViewController2

- (IBAction)btnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 点了获取数据后立即点返回:
// 观察使用self和weakself的dealloc时间的区别

- (IBAction)btn2Pressed:(id)sender {
    
    [NetManager requestMovieListWithSuccessBlock:^(NSArray *list) {
        NSLog(@"回调，更新界面，显示数据信息,当前控制器%@",self);
        self.textView.text = list[arc4random()%list.count];
    } failBlock:^(NSError *error) {
        NSLog(@"回调，更新界面，显示数据信息,当前控制器%@",self);
        self.textView.text = [error localizedDescription];
    }];
}

- (IBAction)btn3Pressed:(id)sender {
    
    __weak ViewController2 *weakSelf = self;
    
    [NetManager requestMovieListWithSuccessBlock:^(NSArray *list) {
        NSLog(@"回调，更新界面，显示数据信息,当前控制器%@",weakSelf);
        weakSelf.textView.text = list[arc4random()%list.count];
    } failBlock:^(NSError *error) {
        NSLog(@"回调，更新界面，显示数据信息,当前控制器%@",weakSelf);
        weakSelf.textView.text = [error localizedDescription];
    }];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
