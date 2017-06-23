//
//  DetailViewController.m
//  Prsidents
//
//  Created by niit on 16/3/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//


// A页面 -> B页面
//
// A类
// 属性
// NSString language;
//
// 某方法里弹出B页面
// B *b =[B alloc] init];
// b.a = self;
// [self presentViewController:b];
//
//
// B里创建一个属性
// @property (weak) A *a;
//
// 回传数据
// self.a.language = @"en";



#import "DetailViewController.h"

#import "LaguageViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,strong) UIPopoverController *popVC;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LaguageViewController *lVC = [[LaguageViewController alloc] init];
    lVC.detailVC = self;
    self.popVC = [[UIPopoverController alloc] initWithContentViewController:lVC];
    self.popVC.popoverContentSize = CGSizeMake(320, 44*4);
    
}

- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    
    [self loadWeb];
}

- (void)setLanguage:(NSString *)language
{
    _language = language;
    [self.popVC dismissPopoverAnimated:YES];
    
    [self loadWeb];
}

- (void)loadWeb
{
    NSString *tmpUrlStr = self.urlStr;
    NSString *tmpLanguage = self.language;
    
    if(tmpUrlStr!= nil)
    {
        if(tmpLanguage!=nil)
        {
            NSRange range = NSMakeRange(7, 2);
            
            tmpUrlStr = [tmpUrlStr stringByReplacingCharactersInRange:range withString:self.language];
        }
        
        // 网址写到label
        self.urlLabel.text = tmpUrlStr;

        // 加载网页
        NSURL *url = [NSURL URLWithString:tmpUrlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (IBAction)selectLanguageBtnPressed:(id)sender
{
    if(self.popVC.popoverVisible)
    {
        [self.popVC dismissPopoverAnimated:YES];
    }
    else
    {
        [self.popVC presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}



@end
