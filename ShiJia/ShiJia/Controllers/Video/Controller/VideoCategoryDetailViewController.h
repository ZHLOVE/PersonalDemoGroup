//
//  VideoCategoryDetailViewController.h
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewPagerController.h"
#import "VideoCategory.h"

/**
 *  点播分类详情
 */
@interface VideoCategoryDetailViewController : BaseViewPagerController

- (instancetype)initWithVideoCategory:(VideoCategory*)videoCategory;

@end
