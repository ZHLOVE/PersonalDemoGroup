//
//  CustomView.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/1/18.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView

//角标长度
@property(nonatomic,assign)float sizeToWidth;

//-(id)initWithFrame:(CGRect)frame corners:(id)model;

-(void)useViewCorners:(id)model;

@end
