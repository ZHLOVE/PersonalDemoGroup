//
//  SJLightView.h
//  ShiJia
//
//  Created by 蒋海量 on 16/9/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJLightView : UIView
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)NSArray *array;//存放的集合
@property(nonatomic,strong)void(^block)(UIButton *button,NSString *string);//block传值
@end
