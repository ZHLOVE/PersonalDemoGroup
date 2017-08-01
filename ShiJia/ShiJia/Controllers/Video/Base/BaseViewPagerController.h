//
//  BaseViewPagerController.h
//  HiTV
//
//  created by iSwift on 3/9/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "ViewPagerController.h"

/**
 *  分页基类
 */
@interface BaseViewPagerController : ViewPagerController<ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic, strong) NSArray* menuTitlesArray;
@property (nonatomic, strong) NSMutableArray* menusArray;
@property (nonatomic, strong) NSArray* menusColorArray;
@property (nonatomic, strong) NSMutableArray* contentsArray;

@property (nonatomic) NSUInteger selectedIndex;

- (UIFont*)fontForTopBar;

@end
