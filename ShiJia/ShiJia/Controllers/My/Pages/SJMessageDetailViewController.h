//
//  SJMessageDetailViewController.h
//  ShiJia
//
//  Created by yy on 16/6/23.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPMessageCenterDataModel;

@interface SJMessageDetailViewController : UIViewController

/**
 *  消息id（用于列表界面与详细界面传值）
 */
@property (nonatomic, copy) NSString *msgId;

/**
 *  消息数据
 */
@property (nonatomic, retain) TPMessageCenterDataModel *msgModel;

- (void)refreshDataWithMsgId:(NSString *)msgid messageModel:(TPMessageCenterDataModel *)msgmodel;



@end
