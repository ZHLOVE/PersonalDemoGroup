//
//  DWMenusViewController.m
//  DWMenu
//
//  Created by Dwang on 16/4/27.
//  Copyright © 2016年 git@git.oschina.net:dwang_hello/WorldMallPlus.git chuangkedao. All rights reserved.
//

#import "DWMenusViewController.h"
#import "DWViewController.h"

@interface DWMenusViewController ()<DWDelegateIndex>
@end

@implementation DWMenusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) dwDelegateIndex:(NSIndexPath *)index {
    
    NSLog(@"%s",__func__);
    
    NSLog(@"%ld",index.row);
    
}
@end
