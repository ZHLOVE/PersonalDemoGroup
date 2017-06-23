//
//  ImageScrollView.h
//  11102
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIITImageScrollView : UIView

// 图片名数组
@property (nonatomic,strong) NSArray *imageNames;

// 分页控件的颜色
@property (nonatomic,strong) UIColor *otherColor;
@property (nonatomic,strong) UIColor *curColor;

@end
