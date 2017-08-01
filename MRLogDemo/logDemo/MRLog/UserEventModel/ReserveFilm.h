//
//  ReserveFilm.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 约片
 */
@interface ReserveFilm : EventModel

@property(nonatomic,assign) int result;
@property(nonatomic,assign) int type;
@property(nonatomic,copy) NSString *ctype;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *pid;

@end
