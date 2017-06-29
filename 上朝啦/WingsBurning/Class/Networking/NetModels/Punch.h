//
//  Punch.h
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  打卡信息
 */
@interface Punch : NSObject

/** 打卡编号 */
@property(nonatomic,copy) NSString *ID;

/** 打卡时间 */
@property(nonatomic,copy) NSString *created_at;

/**punchDate格式2016-09-08*/
@property(nonatomic,copy) NSString *punchDate;

/**  打卡结果 "状态：`normal_accepted` 正常上班；
                    `late_accepted`  迟到；
                    `early_accepted`早退;
                    `absent_accepted` 旷工"*/
@property(nonatomic,copy) NSString *attence_state;

/**  备注信息 */
@property(nonatomic,copy) NSString *note;

/**  迟到早退多少分钟 */
@property(nonatomic,copy) NSString *unnormal_minutes;


@end
