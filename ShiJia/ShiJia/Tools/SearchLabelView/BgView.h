//
//  BgView.h
//  标签
//
//  Created by 回忆网络 on 27/6/16.
//  Copyright © 2016年 回忆网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BgView : UIView
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)NSArray *array;//存放的集合
@property(nonatomic,strong)void(^block)(UIButton *button,NSString *string);//block传值
@property(nonatomic,assign)float height;

@end
