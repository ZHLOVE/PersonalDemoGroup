//
//  ViewController2.m
//  UIViewDemo
//
//  Created by niit on 16/2/26.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPressed:(id)sender
{
    static int cur = 0;
    
    NSArray *arr = @[
    @"UIViewContentModeScaleToFill",
    @"UIViewContentModeScaleAspectFit",
    @"UIViewContentModeScaleAspectFill",
    @"UIViewContentModeRedraw",
    @"UIViewContentModeCenter",
    @"UIViewContentModeTop",
    @"UIViewContentModeBottom",
    @"UIViewContentModeLeft",
    @"UIViewContentModeRight",
    @"UIViewContentModeTopLeft",
    @"UIViewContentModeTopRight",
    @"UIViewContentModeBottomLeft",
    @"UIViewContentModeBottomRight"];
    self.infoLabel.text = arr[cur];
    self.iamgeView.contentMode = cur++;
    if(cur >= arr.count)
    {
        cur = 0;
    }
}
@end
