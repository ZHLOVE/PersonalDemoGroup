//
//  ProgramViewController.h
//  HiTV
//
//  Created by 蒋海量 on 15/1/20.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseProgramViewController.h"

extern NSString * const kPushLiveTVControllerNotification;

@class TVStation;
@interface ProgramViewController :BaseProgramViewController
{
    //VideoPlayerKit *_videoPlayerViewController ;

}
- (instancetype)initWithTVStation:(TVStation*)station;
@property (nonatomic, strong) TVStation* station;
-(void)refashProgramList;
@end
