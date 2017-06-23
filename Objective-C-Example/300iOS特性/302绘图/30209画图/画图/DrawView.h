//
//  DrawView.h
//  画图
//
//  Created by niit on 16/4/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

// 线宽
@property (nonatomic,assign) int curLineWidth;
@property (nonatomic,strong) UIColor *curColor;

// 撤销上一次画的路径
- (void)undo;
// 清除路径
- (void)clear;

@end
