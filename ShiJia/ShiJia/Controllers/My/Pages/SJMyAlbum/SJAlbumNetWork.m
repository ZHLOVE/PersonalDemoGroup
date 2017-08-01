//
//  SJAlbumNetWork.m
//  ShiJia
//
//  Created by 峰 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJAlbumNetWork.h"
#import "TogetherManager.h"
#import "HiTVDeviceInfo.h"
#define testAddress @"http://192.168.1.71:9898/yst-cas-api"

@implementation SJAlbumNetWork


+(void)SJ_AlbumQueryAlbumRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock {
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_CLOUD_ALBUMS,@"/photo/queryAlbum"];
    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {
                                           Handlerblock(responseObject,nil);
                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              Handlerblock(nil,error);
                                          }];
    
}

+(void)SJ_AlbumQueryPhotoRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_CLOUD_ALBUMS,@"/photo/queryPhoto"];
    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {
                                           Handlerblock(responseObject,nil);
                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              Handlerblock(nil,error);
                                          }];
}

+(void)SJ_AlbumDeletePhotoRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_CLOUD_ALBUMS,@"/photo/deletePhoto"];
    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {
                                           Handlerblock(responseObject,nil);
                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              Handlerblock(nil,error);
                                          }];
}

+(void)SJ_AlbumAddPhotoRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_CLOUD_ALBUMS,@"/photo/addPhoto"];
    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {
                                           Handlerblock(responseObject,nil);  
                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              Handlerblock(nil,error);
                                          }];
}

+(void)SJAlbum_GetUserInfo:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock {
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN
                                          forParam:@"/userservice/taipan/userInfo"
                                     forParameters:[params mj_keyValues]
                                        completion:^(id responseObject) {
                                            Handlerblock(responseObject,nil);
                                            
                                        }failure:^(NSString *error) {
                                            Handlerblock(nil,error);
                                        }];
}

/**
 *  Description   把一些数据保存一个json文件到沙盒中
 *
 *  @param JsonfileName 文件名字
 *  @param Objecet      data是一个数组对象的形式传入
 *
 *  @return 是否保存成功
 */

+(BOOL)SaveJsonData:(NSString *)JsonfileName Data:(NSArray *)Objecet{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *Json_path=[path stringByAppendingPathComponent:JsonfileName];
    
    NSData *registerData = [NSJSONSerialization dataWithJSONObject:Objecet options:NSJSONWritingPrettyPrinted error:nil];
    [registerData writeToFile:Json_path atomically:YES];
    BOOL Success=[registerData writeToFile:Json_path atomically:YES]?1:0;
    
    return Success;
}


/**
 *  读取保存到沙盒中的json文件
 *
 *  @param JsonFileName 文件名字
 *
 *  @return 获取一个数组对象
 */
+(NSArray *)receiveJsonData:(NSString *)JsonFileName{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *Json_path=[path stringByAppendingPathComponent:JsonFileName];
    if (Json_path) {
        NSData *data=[NSData dataWithContentsOfFile:Json_path];
        NSArray *JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
        return JsonObject;
    }else{
        return nil;
    }
    
}
+(void)SJAlbum_GetMyFriendsInfoListBlock:(void(^)(id result ,NSString *error))Handlerblock {
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST
                                          forParam:@"/taipan/getUserFriendList"
                                     forParameters:parameters
                                        completion:^(id responseObject) {
                                            NSDictionary *resultDic = (NSDictionary *)responseObject;
                                            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                                                NSMutableArray *resultArray = [NSMutableArray array];
                                                
                                                NSArray *usersArray = [resultDic objectForKey:@"users"];
                                                [SJAlbumNetWork SaveJsonData:@"Friend" Data:usersArray];
                                                
                                                for (NSMutableDictionary *userDic in usersArray) {
                                                    UserEntity *entity = [[UserEntity alloc]initWithDictionary:userDic];
                                                    
                                                    [resultArray addObject:entity];
                                                }
                                                Handlerblock(resultArray,nil);
                                            
                                            }
                                        }failure:^(NSString *error) {
                            
                                        }];
}

+(NSString *)getFriendName:(NSString *)uid {
    NSString *name ;
    if ([uid isEqualToString:[HiTVGlobals sharedInstance].uid.description]) {
        name = [NSString stringWithFormat:@"%@",[HiTVGlobals sharedInstance].nickName];
        return name;
    }else{
        
//        NSArray *array = [SJAlbumNetWork receiveJsonData:@"Friend"];
//        NSArray *userArray = [UserEntity mj_objectArrayWithKeyValuesArray:array];
        
        for ( HiTVDeviceInfo *entity in [TogetherManager sharedInstance].detectedDevices) {
            if ([[entity.ownerUserId description] isEqualToString:uid]) {
                
                name = [NSString stringWithFormat:@"%@",entity.nickName];
                break;
            }
        }
    }
    return StringNotEmpty(name)?name:@"(用户已退圈)";
}

+(NSString *)getFriendImage:(NSString *)uid {
    NSString *urlString ;
    
    if ([uid isEqualToString:[HiTVGlobals sharedInstance].uid.description]) {
        urlString = [HiTVGlobals sharedInstance].faceImg;
        return urlString;
    }else{
        
        NSArray *array = [SJAlbumNetWork receiveJsonData:@"Friend"];
        NSArray *userArray = [UserEntity mj_objectArrayWithKeyValuesArray:array];
        
        for ( UserEntity *model in userArray) {
            if ([[model.uid description] isEqualToString:uid]) {
                urlString = model.faceImg;
                break;
            }
        }
    }
    return urlString;
}
@end
