//
//  UIBarButtonItem+Create.h
//  WeiBo
//
//  Created by student on 16/4/25.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Create)
/**
 *  封装了创建UIBarButtonIten
 *
 *  @param imageName 图片名
 *  @param target    触发事件对象
 *  @param selector  消息
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)createBarButtonItem:(NSString *)imageName
                                  target:(id)target
                                  action:(SEL)selector;

@end
