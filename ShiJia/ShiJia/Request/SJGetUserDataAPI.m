//
//  SJGetUserDataAPI.m
//  ShiJia
//
//  Created by yy on 16/5/13.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "SJGetUserDataAPI.h"
#import "TPXmppRoomManager.h"
#import "TPIMUser.h"

@implementation SJGetUserDataAPI

+ (void)getFriendListWithSuccess:(void (^)(NSArray<UserEntity *> *))success
                          failed:(void (^)(NSString *))failure

{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    
    //获取好友列表
    [[self class] postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/getUserFriendList" forParameters:parameters  completion:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            
            NSArray *array = [NSArray modelArrayWithClass:[UserEntity class]
                                                     json:[resultDic objectForKey:@"users"]];
     
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (UserEntity *entity in array) {
                    [[TPXmppRoomManager defaultManager] saveNickname:entity.name withUserJid:entity.jid];
                    [[TPXmppRoomManager defaultManager] saveHeadImageUrl:entity.faceImg withUserJid:entity.jid];
                }

               
            });

            success(array);
        
        }
    }failure:^(NSString *error) {
        
        DDLogInfo(@"fail");
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        failure(error);
        
    }];
}

@end
