//
//  LiveTVViewController.h
//  ShiJia
//
//  Created by 蒋海量 on 16/6/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "TVProgram.h"

@interface LiveTVViewController : ViewPagerController

@property (nonatomic, strong) NSArray* tvDateListArray;

//- (void)selectProgram:(TVProgram*)program ForList:(NSArray*)programList;
@end
