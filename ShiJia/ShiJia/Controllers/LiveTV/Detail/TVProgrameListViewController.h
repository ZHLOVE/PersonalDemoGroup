//
//  TVProgrameListViewController.h
//  ShiJia
//
//  Created by 蒋海量 on 16/6/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVProgram.h"
#import "TVStationDetail.h"

/**
 *  某一频道某天的节目单
 */
@interface TVProgrameListViewController : UIViewController
@property (nonatomic, strong) NSArray *programs;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) TVStationDetail *date;

- (void)selectProgram:(TVProgram*)program;
@end
