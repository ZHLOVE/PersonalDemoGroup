//
//  BaseViewController.h
//  WeiBo
//
//  Created by student on 16/4/22.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VisitorView;
@interface BaseViewController : UITableViewController

//临时定义变量保存用户是否登录
@property (nonatomic,assign) BOOL userLogin;

@property (nonatomic,strong) VisitorView *vistorView;

@end
