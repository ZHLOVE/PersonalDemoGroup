//
//  FriendInfoController.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/24.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UserEntity.h"
#import "ModifyremarksController.h"

@interface FriendInfoController : UIViewController
@property(nonatomic,strong)  UserEntity *userEntity;
@property(nonatomic,strong)  NSMutableArray *watchRecordArray;
@property(nonatomic,strong)  NSMutableArray *saveRecordArray;

@end
