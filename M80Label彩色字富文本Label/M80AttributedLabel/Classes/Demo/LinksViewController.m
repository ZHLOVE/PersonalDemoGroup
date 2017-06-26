//
//  LinksViewController.m
//  M80AttributedLabel
//
//  Created by amao on 5/21/14.
//  Copyright (c) 2014 www.xiangwangfeng.com. All rights reserved.
//

#import "LinksViewController.h"
#import "M80AttributedLabel.h"


@interface LinksViewController ()<M80AttributedLabelDelegate>

@end

@implementation LinksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //使用自定义的链接检测方法
    /*
    [M80AttributedLabel setCustomDetectMethod:^NSArray *(NSString *text) {
        NSMutableArray *links = [NSMutableArray array];
        return links;
    }];*/
    
    M80AttributedLabel *label = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    label.underLineForLink = NO;
    NSString *text = @"同意《上朝啦》服务协议 和 隐私协议";
    NSRange range1 = [text rangeOfString:@"服务协议"];
    label.text = text;
    [label addCustomLink:[NSValue valueWithRange:range1] forRange:range1 linkColor:[UIColor redColor]];
    NSRange range2 = [text rangeOfString:@"隐私协议"];
    [label addCustomLink:[NSValue valueWithRange:range2] forRange:range2 linkColor:[UIColor redColor]];
    label.delegate = self;
    label.frame = CGRectInset(self.view.bounds,20,20);
    [self.view addSubview:label];

}

- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData
{
    NSString *message = [NSString stringWithFormat:@"LinkData is %@:%@",[[linkData class] description],linkData];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"U click a link"
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch view controller");
}
@end
