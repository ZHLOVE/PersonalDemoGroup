//
//  TVDetailDateViewController.h
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "TVProgram.h"

/**
 *  按日期显示的节目单，管理最近的日期，一般为7天
 */
@interface TVDetailDateViewController : ViewPagerController

@property (nonatomic, strong) NSArray* tvDateListArray;
@property (nonatomic, strong) NSString *uuid;

- (void)selectProgram:(TVProgram*)program ForList:(NSArray*)programList;

@end
