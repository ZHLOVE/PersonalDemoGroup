//
//  SwitchBtn.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/25.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchBtn : UIButton
@property (nonatomic, assign) BOOL isPressed;
- (void)setIsPressed:(BOOL)isPressed;
@end
