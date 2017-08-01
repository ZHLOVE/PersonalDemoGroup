//
//  TagManagerViewController.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"
#import "ChannelUnitModel.h"

@interface TagManagerViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray<ChannelUnitModel *> *topDataSource;
@property (nonatomic, strong) NSMutableArray<ChannelUnitModel *> *bottomDataSource;
/**
 * @b 编辑后, 删除初始选中项排序的回调
 */
@property (nonatomic, copy) void(^removeInitialIndexBlock)(NSMutableArray *topArr, NSMutableArray *bottomArr);

/**
 * @b 选中某一个频道回调
 */
@property (nonatomic, copy) void(^chooseIndexBlock)(NSInteger index, NSMutableArray *topArr, NSMutableArray *bottomArr);

@end
