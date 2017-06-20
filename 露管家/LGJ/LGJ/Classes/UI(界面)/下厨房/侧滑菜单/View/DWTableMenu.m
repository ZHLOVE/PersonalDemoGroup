//
//  DWTableMenu.m
//  DWMenu
//
//  Created by Dwang on 16/4/26.
//  Copyright © 2016年 git@git.oschina.net:dwang_hello/WorldMallPlus.git chuangkedao. All rights reserved.
//


#import "DWTableMenu.h"
#import "DataBase.h"
#import "DataModel.h"
//#import "DWViewController.h"

@interface DWTableMenu ()<UITableViewDelegate, UITableViewDataSource>



@end

@implementation DWTableMenu

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dataSource = self;
    self.delegate = self;
}




#pragma mark ---delegate
- (NSInteger) numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.leftMenus.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"DWcell";
    
    DataModel *model = self.leftMenus[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //点击时有效果，返回时选中效果消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:indexPath];
    
}

@end
