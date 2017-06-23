//
//  ViewController.h
//  MotionMonitor
//
//  Created by Qiang on 3/16/15.
//  Copyright (c) 2015 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *accelerometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroscopeLabel;


@property (nonatomic,strong) CMMotionManager *motionManager;
//操作队列
@property (nonatomic,strong) NSOperationQueue *queue;

@end

