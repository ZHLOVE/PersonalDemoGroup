//
//  DrawView.h
//  WingsBurning
//
//  Created by MBP on 16/9/7.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

// 线宽
@property (nonatomic,assign) int curLineWidth;
@property (nonatomic,strong) UIColor *curColor;

@property(nonatomic,assign) CGPoint letfTop;
@property(nonatomic,assign) CGPoint rightBottom;
@property(nonatomic,copy) NSArray *pointArray;

@end
