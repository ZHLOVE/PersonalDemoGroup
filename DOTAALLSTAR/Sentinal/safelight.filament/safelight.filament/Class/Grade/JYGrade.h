//
//  Grade.h
//  SafeDarkVC
//
//  Created by M on 16/6/21.
//  Copyright © 2016年 leqi. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface JYGrade : NSObject

/**
 *  拍摄环境评分
 *
 *  @param img 照片
 *
 *  @return 评分
 */
+ (NSDictionary *)getScore:(UIImage *)img;

@end
