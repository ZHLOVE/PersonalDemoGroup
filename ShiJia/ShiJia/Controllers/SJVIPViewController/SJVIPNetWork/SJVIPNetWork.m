//
//  SJVIPNetWork.m
//  ShiJia
//
//  Created by 峰 on 16/9/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
//http://192.168.1.71:8080/yst-pms-api/notify/phoneApp/validTransaction
#import "SJVIPNetWork.h"
@implementation SJVIPNetWork


+(void)SJ_UserJudegVIPRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BUSINESSHOST,@"/member/queryPrice"];

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

+(void)SJ_CouponTicketsRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BUSINESSHOST,@"/order/getTickets"];
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

+(void)SJ_VIPPackagesRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock {

    //http://192.168.50.97:8080/yst-ord-mpi/  BUSINESSHOST
    //NSString *urlString = [NSString stringWithFormat:@"%@%@",@"http://192.168.50.97:8080/yst-ord-mpi/",@"member/findProductList"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BUSINESSHOST,@"member/findProductList"];
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

+(void)SJ_ValiteAppleStore:(id)params Block:(void(^)(id result,NSString *error))Handleblock {

    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_YSTEN_PAY,@"/notify/phoneApp/validTransaction"];
    [BaseAFHTTPManager postRequestOperationForHost:urlString
                                          forParam:@"" forParameters:[params mj_keyValues] completion:^(id responseObject) {
                                              Handleblock(responseObject,nil);
                                          } failure:^(NSString *error) {

                                              Handleblock(nil,error);
                                          }];
}
@end
