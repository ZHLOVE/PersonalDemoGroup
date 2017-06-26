//
//  CustomTextViewController.m
//  M80AttributedLabel
//
//  Created by amao on 5/21/14.
//  Copyright (c) 2014 www.xiangwangfeng.com. All rights reserved.
//

#import "CustomTextViewController.h"
#import "M80AttributedLabel.h"

@interface CustomTextViewController ()

@end

@implementation CustomTextViewController

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
    
    NSArray *colors= @[UIColorFromRGB(0x0000FF),UIColorFromRGB(0xFF0000),UIColorFromRGB(0x0000FF),UIColorFromRGB(0xFF0000)];
    M80AttributedLabel *label = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    NSString *plainText = @"同意《上朝啦》 服务条款 和 隐私条款";
    NSArray *components = [plainText componentsSeparatedByString:@" "];
    for (int i=0;i<components.count;i++)
    {
        NSString *text = components[i];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text];
        [attributedText m80_setFont:[UIFont systemFontOfSize:12]];
        [attributedText m80_setTextColor:[colors objectAtIndex:i]];
        [label appendAttributedText:attributedText];
        [label appendText:@" "];
    }
    NSString *testStr1 = components[1];
    NSString *testStr3 = components[3];
    NSLog(@"%@",testStr1);
    NSLog(@"%@",testStr3);

    label.frame = CGRectInset(self.view.bounds,20,20);
    
    [self.view addSubview:label];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
