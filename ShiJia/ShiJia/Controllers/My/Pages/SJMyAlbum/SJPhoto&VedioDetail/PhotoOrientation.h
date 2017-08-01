//
//  PhotoOrientation.h
//  ShiJia
//
//  Created by 峰 on 16/9/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^ChangeOrientation)(UIButton *button);

@interface PhotoOrientation : UIView

@property (nonatomic, copy) ChangeOrientation ChangeOrientationBlock;

@end
