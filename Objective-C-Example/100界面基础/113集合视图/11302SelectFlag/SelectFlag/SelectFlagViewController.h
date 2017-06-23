//
//  SelectFlagViewController.h
//  SelectFlag
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlagModel.h"

// 1. 定义一个协议，
@protocol SelectFlagViewControllerDelegate <NSObject>

// 定义方法，要传递的东西作为方法的参数
- (void)changeFlag:(FlagModel *)flag;

@end


@interface SelectFlagViewController : UICollectionViewController

// 2. 定义一个支持这个协议的代理人
@property (nonatomic,weak) id<SelectFlagViewControllerDelegate> delegate;

@end
