//
//  DetailDataPovider.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/17.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "DmsDataPovider.h"

@implementation DmsDataPovider

+(void)getNavigationsRequestCompletion:(void (^)(NSArray *navigationArray))success
                               failure:(void (^)(NSString *message))failure;{
    NSString* url = [NSString stringWithFormat:@"%@findNavigations.json?abilityString=%@",DMS_HOST,T_STBext];

    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {

        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"resultCode"];
        if ([code isEqualToString:@"000"]) {
            NSArray *navigations = responseDic[@"data"][@"navigations"];
            success(navigations);
        }
        else{
            success([responseDic objectForKey:@"resultMessage"]);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        failure(@"网络请求失败");
    }];
}

+(void)getNavigationDetailRequest:(NSString *)navigateId
                       completion:(void (^)(NSArray *detailDatasArray))success
                          failure:(void (^)(NSString *message))failure;{
    
    [HiTVGlobals sharedInstance].districtCode = [NSUserDefaultsManager getObjectForKey:CITYCODE];
    NSString* url = [NSString stringWithFormat:@"%@findNavigationData.json?abilityString=%@&navigateId=%@&districtCode=%@&userId=%@",DMS_HOST,T_STBext,navigateId,[HiTVGlobals sharedInstance].districtCode,[HiTVGlobals sharedInstance].uid];

    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {

        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"resultCode"];
        if ([code isEqualToString:@"000"]) {
            NSArray *detaisArray = responseDic[@"data"][@"detailDatas"];
            success(detaisArray);
        }
        else{
            failure([responseDic objectForKey:@"resultMessage"]);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        failure(@"网络请求失败");
    }];
}

+(void)getBootAdRequestCompletion:(void (^)(id responseObject))success
                          failure:(void (^)(NSString *message))failure{
    NSString* url = [NSString stringWithFormat:@"%@getBootAdData.json?abilityString=%@",DMS_HOST,T_STBext];

    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {

        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"resultCode"];
        if ([code isEqualToString:@"000"]) {
            NSDictionary *adDic = responseDic[@"data"];
            success(adDic);
        }
        else{
            failure([responseDic objectForKey:@"resultMessage"]);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        failure(@"网络请求失败");
    }];
}

+ (void)getHotVideoDetailWithVideoID:(NSString *)videoid
                     CompletionBlock:(void (^)(id responseObject))success
                             failure:(void (^)(NSString *message))failure{
    NSString* url = [NSString stringWithFormat:@"%@getHotVideoDetail.json?id=%@",HOTPRODUCT_HOST,videoid];
    [BaseAFHTTPManager getRequestOperationForHost:url
                                         forParam:@""
                                    forParameters:nil
                                       completion:^(id responseObject) {

                                           NSDictionary *responseDic = (NSDictionary *)responseObject;
                                           NSString *code = [responseDic objectForKey:@"resultCode"];
                                           if ([code isEqualToString:@"000"]) {
                                               NSDictionary *adDic = responseDic[@"data"];
                                               success(adDic);
                                           }
                                           else{
                                               failure([responseDic objectForKey:@"resultMessage"]);
                                           }

                                       } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                           failure(@"网络请求失败");
                                       }];
}

+ (void)hotSpotVideoGenerateWebLinkWith:(requestWebLink *)params
                        CompletionBlock:(void (^)(id responseObject))success
                                failure:(void (^)(NSString *message))failure{
    //!!!:地址需要切换成 下发的shareVideoURL
    //!!!:
     NSString* url = [NSString stringWithFormat:@"%@share/ShortVideo",HOTSHARE_HOST];
    [BaseAFHTTPManager getRequestOperationForHost:url
                                         forParam:nil
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {

                                           NSDictionary *responseDic = (NSDictionary *)responseObject;
                                           NSString *code = [responseDic objectForKey:@"resultCode"];
                                           if ([code isEqualToString:@"000"]) {
                                               NSDictionary *adDic = responseDic;
                                               success(adDic);
                                           }
                                           else{
                                               failure([responseObject objectForKey:@"resultMessage"]);
                                           }

                                       } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                           failure(@"网络请求失败");
                                       }];
    
}



@end
