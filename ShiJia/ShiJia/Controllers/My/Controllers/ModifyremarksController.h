//
//  ModifyremarksController.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/25.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "UserEntity.h"
@protocol ModifyremarksControllerDelegate <NSObject>
- (void)refreshFriendInfo;

@end
@interface ModifyremarksController : UIViewController
@property (nonatomic,strong) id <ModifyremarksControllerDelegate> m_delegate;
@property(nonatomic,strong)  UserEntity *userEntity;

@end
