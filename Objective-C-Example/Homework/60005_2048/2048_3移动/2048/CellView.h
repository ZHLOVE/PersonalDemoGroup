//
//  CellView.h
//  2048
//
//  Created by niit on 16/3/21.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIView

@property (nonatomic,assign) int number;
@property (nonatomic,strong) UILabel *numberLabel;

@end
