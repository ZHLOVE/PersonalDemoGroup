//
//  UIView+Frame.h
//  Weibo
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>

//增加这个分类的目的是:直接使用x y width height设置UIView的位置和尺寸,减少代码行数
//由于x,y,width,heigt 和 Masonry 里冲突,所以都加个_，加以区分

@interface UIView (Frame)

@property (nonatomic,assign) CGFloat x_;
@property (nonatomic,assign) CGFloat y_;
@property (nonatomic,assign) CGFloat width_;
@property (nonatomic,assign) CGFloat heigt_;

@end
