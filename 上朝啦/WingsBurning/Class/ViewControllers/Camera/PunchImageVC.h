//
//  PunchImageVC.h
//  WingsBurning
//
//  Created by MBP on 2016/11/14.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseViewController.h"

@interface PunchImageVC : BaseViewController

@property(nonatomic,assign) BOOL punchFlag;
/**替别人打卡时候用到*/
@property(nonatomic,strong) NSString *otherEmployeeID;

@property(nonatomic,strong) NSString *naviTitle;

//NSLog(@"姿态%i ,面积%i ,中心%i,光照%i",facePose,faceRect,faceCenter,faceLight);
@property(nonatomic,assign) BOOL facePose;
@property(nonatomic,assign) BOOL faceRect;
@property(nonatomic,assign) BOOL faceCenter;
@property(nonatomic,assign) BOOL faceLight;

@property(nonatomic,strong) NSArray *faceResutltArray;

- (instancetype)initWithImage:(UIImage *)image;

@end
