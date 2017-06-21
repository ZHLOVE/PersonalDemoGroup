//
//  CaptureImageVC.h
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseViewController.h"

@interface CaptureImageVC : BaseViewController

@property(nonatomic,assign) BOOL punchFlag;
@property(nonatomic,assign) BOOL changeFace;
@property(nonatomic,assign) BOOL firstPunch;

/**替别人打卡时候用到*/
@property(nonatomic,strong) NSString *otherEmployeeID;

//NSLog(@"姿态%i ,面积%i ,中心%i,光照%i",facePose,faceRect,faceCenter,faceLight);
@property(nonatomic,assign) BOOL facePose;
@property(nonatomic,assign) BOOL faceRect;
@property(nonatomic,assign) BOOL faceCenter;
@property(nonatomic,assign) BOOL faceLight;

@property(nonatomic,strong) NSArray *faceResutltArray;

- (instancetype)initWithImage:(UIImage *)image;


@end
