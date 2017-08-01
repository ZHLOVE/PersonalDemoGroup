//
//  TPShortVideoProgressView.h
//  HiTV
//
//  Created by yy on 15/10/28.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPShortVideoProgressView : UIView

@property(nonatomic) float progress;                        // 0.0 .. 1.0, default is 0.0. values outside are pinned.
@property(nonatomic, strong, nullable) UIColor* progressTintColor;
@property(nonatomic, strong, nullable) UIColor* trackTintColor;
@property(nonatomic, strong, nullable) UIImage* progressImage;
@property(nonatomic, strong, nullable) UIImage* trackImage;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
