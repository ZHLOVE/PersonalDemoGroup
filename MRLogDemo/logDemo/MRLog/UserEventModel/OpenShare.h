//
//  OpenShare.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 打开分享
 */
@interface OpenShare : EventModel

@property(nonatomic,copy) NSString *share_id;
@property(nonatomic,assign) int result;
@property(nonatomic,assign) int type;

@end
