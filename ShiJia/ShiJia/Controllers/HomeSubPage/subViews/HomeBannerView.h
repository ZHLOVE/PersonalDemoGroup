//
//  HomeBannerView.h
//  YHImageCarousel
//
//  Created by 峰 on 2017/2/20.
//  Copyright © 2017年 zyh. All rights reserved.
//

/**
 *  Banner 滚动View
 */

#import <UIKit/UIKit.h>
#import "homeModel.h"
#import "HomeCallBackDelegate.h"

@interface HomeBannerView : UIView
@property (nonatomic, weak) id<CallBackDelegate>delegate;
@property (nonatomic, strong)  homeModel *bannerModel;//banner对象model

@end
