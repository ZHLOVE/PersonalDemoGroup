//
//  BaseProgramViewController.h
//  HiTV
//
//  Created by 蒋海量 on 15/1/23.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "VideoPlayerKit.h"
#import "TVProgram.h"

/**
 *  详情页面基类，处理和播放相关的显示
 */
@interface BaseProgramViewController : UIViewController
@property (nonatomic, strong) UIViewController* detailCategoryController;
@property (weak, nonatomic) IBOutlet UIView *videoContainerView;
@property (weak, nonatomic) IBOutlet UIView *detailContainerView;
//@property (nonatomic, strong) VideoPlayerKit* videoPlayerViewController;

- (void)playVideo:(NSString*)url andTitle:(NSString*)title andTVProgram:(TVProgram*)tvProgram isStreaming:(BOOL)isStreaming;
@end
