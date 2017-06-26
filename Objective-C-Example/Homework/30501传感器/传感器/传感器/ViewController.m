//
//  ViewController.m
//  传感器
//
//  Created by student on 16/4/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

//运动管理器
@property(nonatomic,strong) CMMotionManager *motionManager;
// 运动管理器
//@property (nonatomic,strong) CMMotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 检测运动(不需要知道xyz具体加速度数值) 比如做摇一摇的功能
- (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}

#pragma mark加速计与回转仪

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.motionManager.accelerometerAvailable) {
        //更新频率
        self.motionManager.accelerometerUpdateInterval = 0.1;
        //开始监听
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            NSString *info = [NSString stringWithFormat:@"加速计信息:\nX:%+.2f\nY:%+.2f\nZ:%+.2f", accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
                self.label1.text = info;
        }];
    }else{
        NSLog(@"当前设备加速计不可用");
    }
        if(self.motionManager.gyroAvailable)
        {
            self.motionManager.gyroUpdateInterval = 0.1;
    
            [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
    
                NSString *info = [NSString stringWithFormat:@"回转信息:\nX:%+.2f\nY:%+.2f\nZ:%+.2f", gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z];
                self.label2.text = info;
    
            }];
        }
}
#pragma mark  - 距离传感器

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    // 开启距离传感器
//    [UIDevice  currentDevice].proximityMonitoringEnabled = YES;
//
//    // 监听距离传感器状态改变的通知 UIDeviceProximityStateDidChangeNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChanged:) name:UIDeviceProximityStateDidChangeNotification object:nil];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//
//    [UIDevice  currentDevice].proximityMonitoringEnabled = NO;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//
//- (void)proximityStateChanged:(NSNotification *)n
//{
//    if([UIDevice currentDevice].proximityState == YES)
//    {
//        NSLog(@"有物体靠近了");
//    }
//    else
//    {
//        NSLog(@"远离了!");
//    }
//}









































@end
