//
//  DrawView.h
//  画图
//
//  Created by student on 16/4/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

// 线宽
@property (nonatomic,assign) int curLineWidth;
@property (nonatomic,strong) UIColor *curColor;

- (void)undo;
// 清除路径
- (void)clear;
@end
