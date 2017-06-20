//
//  UIBarButtonItem+Create.h
//  Weibo
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Create)

/**
 *  封装了创建UIBarButtonItem的方法
 *
 *  @param imageName 按钮图片名
 *  @param target    按钮出发后发送消息的对象
 *  @param selector  消息
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)createBarButtonItem:(NSString *)imageName
                                  target:(id)target
                                  action:(SEL)selector;

@end
