//
//  ViewController.m
//  RunLoopDemo02
//
//  Created by qiang on 5/3/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) MyThread *myThread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myThread =[[MyThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.myThread start];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(test) onThread:self.myThread withObject:nil waitUntilDone:NO];
}

- (void)test
{
    NSLog(@"%@ ---- test ---",[NSThread currentThread]);
}

- (void)run
{
    NSLog(@"%@ ---- run---",[NSThread currentThread]);
    
//    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(test) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    
    NSLog(@"-----end------");
    
}
@end
