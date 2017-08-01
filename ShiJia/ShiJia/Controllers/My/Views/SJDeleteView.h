//
//  SJDeleteView.h
//  ShiJia
//
//  Created by yy on 16/4/18.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kSJDeleteViewHeight;

@interface SJDeleteView : UIView

@property (nonatomic, strong, readonly) UIButton *selectAllButton;
@property (nonatomic, strong, readonly) UIButton *deleteButton;

@property (nonatomic, assign)   BOOL    isSelectedAll;
@property (nonatomic, assign)   BOOL    isDeleteEnabled;


@end
