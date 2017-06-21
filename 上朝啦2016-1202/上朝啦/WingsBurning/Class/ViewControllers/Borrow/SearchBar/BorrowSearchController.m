//
//  MySearchController.m
//  WingsBurning
//
//  Created by MBP on 16/9/1.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BorrowSearchController.h"
#import "BorrowSearchBar.h"
@interface BorrowSearchController ()  <UISearchBarDelegate> {
    UISearchBar *_searchBar;
}
@end

@implementation BorrowSearchController

-(UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[BorrowSearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.showsCancelButton = NO;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchBar.text length] > 0) {
        self.active = true;
    } else {
        self.active = false;
    }
}
@end
