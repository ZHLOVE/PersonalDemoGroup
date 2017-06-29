//
//  MainVC.h
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseViewController.h"

@interface MainVC : BaseViewController

@property(nonatomic,strong) UIButton *punchyBtn;

/**
 *  获取基本信息
 */
- (void)getHeadViewInfo;
/**
 * 获取合约状态
 */
- (void)getContractInfoWithContract:(void (^)(ContractM *contract))contractBlock;
/**
 * 判断定位开启
 */
- (void)judgeLocationEnable;
/**
 * 进入打卡
 */
- (void)goToPunch;
/**
 * 进入打卡记录
 */
- (void)gotoPunchRecordViewController;
@end
