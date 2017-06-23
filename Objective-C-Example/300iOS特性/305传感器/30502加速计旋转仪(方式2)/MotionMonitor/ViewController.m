//
//  ViewController.m
//  MotionMonitor
//
//  Created by Qiang on 3/16/15.
//  Copyright (c) 2015 QiangTech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSTimer *t;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //创建运动管理器
    self.motionManager = [[CMMotionManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.motionManager.accelerometerAvailable)
    {
        //更新频率
        self.motionManager.accelerometerUpdateInterval = 0.1;
        //开始监听
        [self.motionManager startAccelerometerUpdates];
    }
    else
    {
        self.accelerometerLabel.text = @"该设备没有加速计";
    }
    
    if(self.motionManager.gyroAvailable)
    {
        self.motionManager.gyroUpdateInterval = 0.1;
        [self.motionManager startGyroUpdates];
    }
    else
    {
       self.gyroscopeLabel.text = @"该设备没有回转仪";
    }
    
    //开启定时器
    t = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //关闭定时器
    [t invalidate];
    //停止加速计
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
}

- (void)updateInfo
{
    if(self.motionManager.accelerometerAvailable)
    {
        CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
        self.accelerometerLabel.text = [NSString stringWithFormat:@"回转仪数据:\nX:%+.2f\nY:%+.2f\nZ:%+.2f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
    }
    if(self.motionManager.gyroAvailable)
    {
        CMGyroData *gyroData = self.motionManager.gyroData;
        self.gyroscopeLabel.text = [NSString stringWithFormat:@"回转仪数据:\nX:%+.2f\nY:%+.2f\nZ:%+.2f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z];
    }
}

@end
