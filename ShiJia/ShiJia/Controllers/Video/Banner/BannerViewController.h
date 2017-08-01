//
//  BannerViewController.h
//  HiTV
//
//  created by iSwift on 3/7/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSummary.h"

extern NSString * const kBannerViewControllerPushDetailNotification;
extern NSString * const kBannerViewControllerSelectedVideoKey;

/**
 *  单个轮播
 */
@interface BannerViewController : UIViewController

@property (nonatomic, strong) VideoSummary* video;

@end
