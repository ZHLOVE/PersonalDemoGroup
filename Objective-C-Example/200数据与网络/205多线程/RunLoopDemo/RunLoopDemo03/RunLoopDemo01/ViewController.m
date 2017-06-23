//
//  ViewController.m
//  RunLoopDemo01
//
//  Created by qiang on 5/3/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"1"] afterDelay:3];
    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"1"] afterDelay:3 inModes:@[NSDefaultRunLoopMode,UITrackingRunLoopMode]];
}
@end
