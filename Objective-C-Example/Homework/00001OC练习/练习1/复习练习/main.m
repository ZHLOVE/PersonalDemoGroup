//
//  main.m
//  复习练习
//
//  Created by student on 16/3/11.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataSource.h"
#import "CMTableView.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 用以下代码测试:
        DataSource *data = [[DataSource alloc] init];
        CMTableView *tableView = [[CMTableView alloc] init];
        tableView.dataSource = data;
        
        [tableView show];
 
    }
    return 0;
}
