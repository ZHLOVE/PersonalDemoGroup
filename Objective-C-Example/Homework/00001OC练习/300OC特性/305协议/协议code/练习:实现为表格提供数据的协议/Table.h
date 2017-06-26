//
//  Table.h
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableDelegate <NSObject>


// 提供表格标题
- (NSString *)tableTitle;

// 提供表格内容数组(字符串数组)
- (NSArray *)tableContent;

@end

@interface Table : NSObject

// 打印输出表格
- (void)print;

// 为表格提供数据的代理对象
@property (nonatomic,weak) id<TableDelegate> delegate;

@end
