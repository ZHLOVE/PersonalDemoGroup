//
//  ProgramCell.h
//  HiTV
//
//  Created by 蒋海量 on 15/1/23.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVProgram.h"

extern NSString* const cProgramCellID;
extern CGFloat cProgramCellHeight;

/**
 *  具体单个节目单显示
 */
@interface ProgramCell : UITableViewCell
@property (nonatomic, strong) TVProgram* tvProgram;

@end
