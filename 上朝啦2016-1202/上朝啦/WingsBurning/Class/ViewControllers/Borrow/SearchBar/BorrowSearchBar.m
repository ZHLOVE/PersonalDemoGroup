//
//  MySearchBar.m
//  WingsBurning
//
//  Created by MBP on 16/9/1.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BorrowSearchBar.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width

@implementation BorrowSearchBar

-(void) layoutSubviews{
    [super layoutSubviews];
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    self.barTintColor = [UIColor whiteColor];
    searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    if([searchTextField isKindOfClass:[UITextField class]]){
        searchTextField.frame = CGRectMake(18, 10, screenWidth - 36, 34);
    }
}


///>>>>>>>>>>此处注释打开，SearchBar上的取消按钮就隐藏了<<<<<<<<<<<<*
-(void)setShowsCancelButton:(BOOL)showsCancelButton {

}

-(void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated {
    
}

@end
