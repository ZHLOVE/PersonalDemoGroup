//
//  def.h
//  Hospital_PTX
//
//  Created by 马千里 on 16/5/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "UILabel+Creation.h"
#import "UIButton+Creation.h"
#import "NSString+Path.h"
#import "UIImage+RoundedRectImage.h"
#import "UILabel+Creation.h"
#import "UIView+Frame.h"

#import "HHAlertView.h"
#import "DataBase.h"
#import "DataModel.h"

#ifndef def_h
#define def_h


#define kHospitalDict @"HospitalDict" 

#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width

//T_CookGoods表中的字段
#define kName @"name"
#define kImage @"image"
#define kCounts @"counts"
#define kDayFrom @"dayFrom"
#define kDayTo @"dayTo"
#define kType @"type"


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif



//设备的物理宽度
#define ScreenWidth self.view.frame.size.width
//设备的物理高度
#define ScreenHeight self.view.frame.size.height
//菜单的宽度 用来判断菜单是否为显示状态
#define MenuWidth self.menu.frame.size.width
//菜单显示的frame，宽度就是显示的尺寸
#define MenusFrame CGRectMake(0, 64, ScreenWidth / 4 * 2, ScreenHeight-50)
//菜单不显示的frame
#define MenusFrameAfter CGRectMake(0, 64, 0, ScreenHeight)
//背景图片在左侧菜单显示时的宽度
#define ImageFrame CGRectMake(ScreenWidth / 4 * 3, 0, ScreenWidth, ScreenHeight)
//背景图片在左侧菜单没有显示时的宽度
#define Frame CGRectMake(0, 0, ScreenWidth, ScreenHeight)
#define viewClickFrame CGRectMake(ScreenWidth / 4 * 3, 0, ScreenWidth / 4, ScreenHeight)



#endif /* def_h */
