//
//  UILabel+Creation.h
//  Weibo
//
//  Created by qiang on 5/5/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Creation)

/**
 *  创建UILabel对象的类方法
 *
 *  @param color    字体颜色
 *  @param fontSize 字体大小
 *
 *  @return UILabel对象
 */
+ (UILabel *)createLabelWithColor:(UIColor *)color
                         fontSize:(CGFloat)fontSize;

/**
 * 让Label上的文字顶格显示;
 */
- (void)topAlignment;
@end
