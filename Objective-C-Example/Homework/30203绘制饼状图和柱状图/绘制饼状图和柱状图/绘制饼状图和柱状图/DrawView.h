//
//  DrawView.h
//  绘制饼状图和柱状图
//
//  Created by student on 16/4/6.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic,copy)NSArray *list;
@property (nonatomic,assign) int type;// 0 饼图 1 状图

@end
