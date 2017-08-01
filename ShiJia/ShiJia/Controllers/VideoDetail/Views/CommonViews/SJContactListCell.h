//
//  SJContactListCell.h
//  ShiJia
//
//  Created by yy on 16/3/11.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface SJContactListCell : ASCellNode

@property (nonatomic, assign) BOOL checked;

- (void)showData:(UserEntity *)data;

@end
