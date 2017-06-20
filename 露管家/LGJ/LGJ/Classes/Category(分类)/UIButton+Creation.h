//
//  UIButton+Creation.h
//  Weibo
//
//  Created by qiang on 5/5/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Creation)

/**
 *  创建按钮
 *
 *  @param title     按钮上的文字
 *  @param imageName 按钮上的图片名字
 *
 *  @return 按钮对象
 */
+ (UIButton *)createButtonWithTitle:(NSString *)title
                          imageName:(NSString *)imageName;

@end
