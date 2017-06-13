//
//  LXYGradientProgressView.h
//  LXYGradientProgressView
//
//  Created by 宣佚 on 15/8/19.
//  Copyright (c) 2015年 Liuxuanyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXYGradientProgressView : UIView
{
    CALayer *maskLayer;
}

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;
@property (nonatomic, readwrite, assign) CGFloat progress;

-(void)startAnimating;
-(void)stopAnimating;

@end
