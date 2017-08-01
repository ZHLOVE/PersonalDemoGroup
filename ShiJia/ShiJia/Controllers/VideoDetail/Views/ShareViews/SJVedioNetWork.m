//
//  SJVedioNetWork.m
//  ShiJia
//
//  Created by 峰 on 16/7/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVedioNetWork.h"
#import "BaseAFHTTPManager.h"

@implementation SJVedioNetWork


+(void)SJ_VedioCutManange:(id)params Block:(void(^)(id result ,NSString *error))block {

    NSString *urlString = [NSString stringWithFormat:@"%@%@",[HiTVGlobals sharedInstance].share_server,@"/video/micro/build"];

    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {
                                           block(responseObject,nil);
                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              block(nil,error);
                                          }];
}

+(void)ShareSmsVideoWithParams:(SMSRequestParams *)params Block:(void(^)(SMSResponseModel *model,NSString *error))block{

    NSString *urlString = [NSString stringWithFormat:@"%@%@",[HiTVGlobals sharedInstance].share_server,@"/share/ShareSmsVideo"];
    // NSString *urlString = [NSString stringWithFormat:@"%@%@",@"http://192.168.50.138:8080",@"/share-facade/share/ShareSmsVideo"];
    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {

                                           SMSResponseModel * model = [SMSResponseModel mj_objectWithKeyValues:responseObject];
                                           block(model,nil);
                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              block(nil,error);
                                          }];
}

+(void)ShareSMSLocalSource:(SMSLocalRequestParams *)params Block:(void(^)(SMSResponseModel *model ,NSString *error))completeBlock{
      NSString *urlString = [NSString stringWithFormat:@"%@%@",[HiTVGlobals sharedInstance].share_server,@"/share/ShareLocalFile"];
   // NSString *urlString = [NSString stringWithFormat:@"%@%@",@"http://192.168.50.138:8080",@"/share-facade/share/ShareLocalFile"];
    NSString *escapedPath = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [BaseAFHTTPManager postRequestOperationForHost:escapedPath
                                          forParam:nil
                                     forParameters:[params mj_keyValues]
                                        completion:^(id responseObject) {
                                            SMSResponseModel * model = [SMSResponseModel mj_objectWithKeyValues:responseObject];
                                            completeBlock(model,nil);
                                        } failure:^(NSString *error) {

                                            completeBlock(nil,error);
                                            
                                        }];
    
}

@end
