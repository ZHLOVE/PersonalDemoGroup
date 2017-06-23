//
//  DrawView.h
//  饼状图和柱状图
//
//  Created by niit on 16/4/6.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic,strong) NSArray *list;

@property (nonatomic,assign) int type;// 0 饼图 1 状图
@end
