//
//  PresidentDetail.m
//  11402PresidentList
//
//  Created by student on 16/3/10.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "PresidentDetail.h"

#import "ChangeLangunge.h"
@interface PresidentDetail ()

// 弹出控制器


@end

@implementation PresidentDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWebUrl:@"https://www.zhihu.com/"];
    
    // pop内容视图控制器
    ChangeLangunge *langungeVC = [[ChangeLangunge alloc] init];
    /*不使用代理传值*/
    langungeVC.preDetail = self;
    // 创建弹出控制器
    self.popVC = [[UIPopoverController alloc] initWithContentViewController:langungeVC];
    // 弹出的尺寸
    self.popVC.popoverContentSize = CGSizeMake(120, 330);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseLangungeBtnPressed:(id)sender
{
    // 弹出pop窗口
    if(self.popVC.popoverVisible)
    {
        [self.popVC dismissPopoverAnimated:YES];
    }
    else
    {
        // 从按钮旁弹出
        [self.popVC presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

}

- (void)setWebUrl:(NSString *)webUrl{
//    NSLog(@"%s",__func__);
    _webUrl = webUrl;
    // 网址对象
    NSURL *curUrl = [NSURL URLWithString:webUrl];
    // 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:curUrl];
    [self.webView loadRequest:request];
    self.label.text = webUrl;
   
//    解决办法：
//    在Info.plist文件中添加"App Transport SecuritySettings", Type为"Dictionary",再添加"Allow Arbitray Loads", Type 为"Boolean"，“Value”为“YES”即可。
}





@end
