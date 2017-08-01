//
//  SJMediaScrollViewController.h
//  ShiJia
//
//  Created by 峰 on 16/9/18.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJMediaScrollViewController : UIViewController

//相册类型
@property (nonatomic, assign) Album_Type album_type;
//本地数据源
@property (nonatomic, strong) NSMutableArray *localSourceArray;//Alasset
//云端数据源
@property (nonatomic, strong) NSMutableArray *cloudSourceArray;//cloudModel
//当前index
@property (nonatomic, assign) NSInteger currentIndex;


@end
