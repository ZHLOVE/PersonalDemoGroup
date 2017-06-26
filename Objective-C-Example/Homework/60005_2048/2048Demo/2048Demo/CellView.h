//
//  CellView.h
//  2048Demo
//
//  Created by student on 16/3/21.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIView

@property(nonatomic,assign) int number;
@property (nonatomic,strong) UILabel *numberLabel;
@end
