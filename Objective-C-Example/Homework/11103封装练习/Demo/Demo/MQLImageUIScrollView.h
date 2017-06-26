//
//  MQLImageUIScrollView.h
//  Demo
//
//  Created by 马千里 on 16/2/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MQLImageUIScrollView : UIView
// 图片名数组
@property(nonatomic,strong) NSArray *imageNames;

// 分页控件的颜色
@property (nonatomic,strong) UIColor *otherColor;
@property (nonatomic,strong) UIColor *curColor;
@end
