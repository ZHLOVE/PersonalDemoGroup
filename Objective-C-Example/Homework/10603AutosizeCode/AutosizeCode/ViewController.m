//
//  ViewController.m
//  AutosizeCode
//
//  Created by niit on 16/3/2.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"1 将要旋转到方向%i",toInterfaceOrientation);
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 水平方向
        self.label1.frame = CGRectMake(20, 20, 125, 125);
        self.label2.frame = CGRectMake(20, 155, 125, 125);
        self.label3.frame = CGRectMake(177,20, 125, 125);
        self.label4.frame = CGRectMake(177,155,125, 125);
        self.label5.frame = CGRectMake(328,20, 125, 125);
        self.label6.frame = CGRectMake(328,155, 125, 125);
    }
    else
    {
        // 垂直方向
        self.label1.frame = CGRectMake(20, 20, 125, 125);
        self.label2.frame = CGRectMake(172, 20, 125, 125);
        self.label3.frame = CGRectMake(20, 168,125, 125);
        self.label4.frame = CGRectMake(175,168,125, 125);
        self.label5.frame = CGRectMake(20,315, 125, 125);
        self.label6.frame = CGRectMake(175,315, 125, 125);
    }
}


@end
