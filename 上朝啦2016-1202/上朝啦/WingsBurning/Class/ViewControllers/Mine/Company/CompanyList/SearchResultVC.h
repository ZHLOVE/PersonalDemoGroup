//
//  SearchResultVC.h
//  WingsBurning
//
//  Created by MBP on 16/9/1.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultVC : BaseViewController

@property(nonatomic,strong) NSMutableArray *searchResultArr;
@property(nonatomic,strong) EmployeeM *employee;

@property(nonatomic,weak) UINavigationController *navi;

@end
