//
//  LoadImages.h
//  验证码练习
//
//  Created by student on 16/3/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadImages : UIViewController
//放随机取出的8个图片的数组
@property (strong,nonatomic)NSMutableArray *chineseArray;
@property (strong,nonatomic)NSArray * allImgsArray;

- (void)loadImagesToArray;
- (NSMutableArray *)makeBtnImages;
@end
