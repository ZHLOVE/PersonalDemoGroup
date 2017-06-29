//
//  Networking.m
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Networking.h"
#import "AFNetworking.h"
#import "Verify.h"
#import "MD5.h"
#import "MJExtension.h"

@interface Networking()



@end


static Networking *instance = nil;
static AFHTTPSessionManager *manager = nil;
#ifdef DEBUG
static NSString *urlStr = @"http://10.0.0.7:8105/api"; //内测API
#else
static NSString *urlStr = @"https://api.shangchao.la"; //外网API
#endif

@implementation Networking

/**
 *  单例
 *
 */
+ (instancetype)sharedNetwork{
    // 保证线程安全
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[Networking alloc] init];
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 3;
    });
    return instance;
}


#pragma mark - 开启Share
+ (void)shareEnableSuccessBlock:(void (^)(NSString *dictShare))successBlock
                      failBlock:(void (^)(NSInteger statusCode,NSString *errStr))failBlock
{
    NSString *urlString = [urlStr stringByAppendingString:@"/share"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *dictShare = [responseObject objectForKey:@"share"];
        successBlock(dictShare);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        if (errorStr == nil) {
            errorStr = @"服务器连接失败请重试";
        }
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(statusCode,errorStr);
    }];

}

#pragma mark-获取验证码
+ (void)huoQuYZM:(NSString *)phoneNumber
          action:(NSString *)action
    successBlock:(void (^)())successBlock
       failBlock:(void (^)(NSInteger statusCode,NSString *errStr))failBlock
{
    NSString *urlString = [urlStr stringByAppendingString:@"/captchas"];
    NSDictionary *dict = @{@"phone_number":phoneNumber,@"action":action};
    [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        if (errorStr == nil) {
            errorStr = @"服务器连接失败请重试";
        }
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(statusCode,errorStr);
    }];
}

#pragma mark-登录
+ (void)dengLu:(NSString *)phoneNumber
     yanZhenMa:(NSString *)yzm
  successBlock:(void (^)(NSArray *arr))successBlock
     failBlock:(void (^)(NSInteger statusCode,NSString *errStr))failBlock

{
    NSString *urlString = [urlStr stringByAppendingString:@"/tokens"];
    NSDictionary *dict = @{@"phone_number":phoneNumber, @"captcha":yzm};
    [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        TokensM *tokens = [TokensM mj_objectWithKeyValues:dictT];
        NSArray *array = @[employee,tokens];
        successBlock(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(statusCode,errorStr);
    }];
}


#pragma mark-刷新令牌
+ (void)shuaXinLinPai:(NSString *)token
         successBlock:(void (^)(NSArray *arr))successBlock
            failBlock:(void (^)(NSString *errStr))failBlock
{
    NSString *urlString = [urlStr stringByAppendingString:@"/tokens/access"];
    NSDictionary *dict = [[NSDictionary alloc]init];
    if (token) {
        dict = @{@"refresh_token":token};
    }
    [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        TokensM *tokens = [TokensM mj_objectWithKeyValues:dictT];
//        tokens.access_token = @"测试tokens失败";
        [Verify saveToken:tokens];
        NSArray *array = @[employee,tokens];
        successBlock(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        failBlock(errorStr);
    }];
}


#pragma mark-注册「创建雇员」
+ (void)zhuCe:(Employees *) employee
 successBlock:(void (^)(NSArray *arr))successBlock
    failBlock:(void (^)(NSString *errStr))failBlock
{
    NSString *urlString = [urlStr stringByAppendingString:@"/employees"];
    NSDictionary *dict = @{@"name":employee.userName, @"phone_number":employee.phone_number, @"captcha":employee.captcha};
    [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
        NSDictionary *dictULT = [responseObject objectForKey:@"avatar_upload_token"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        TokensM *tokens = [TokensM mj_objectWithKeyValues:dictT];
        ImageUploadToken *imgULToken = [ImageUploadToken mj_objectWithKeyValues:dictULT];
        NSArray *array = @[employee,tokens,imgULToken];
        successBlock(array);
        DLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        failBlock(errorStr);
    }];
}


#pragma mark-获取公司列表
+ (void)huoQuGSLB:(Employers *)employers
            token:(TokensM *)token
     successBlock:(void (^)(NSArray *arr))successBlock
          failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlString = [urlStr stringByAppendingFormat:@"/employers?per_page=%@&page=%@&name=%@",employers.per_page,employers.page,employers.name];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arrayTemp = [responseObject objectForKey:@"employers"];
        NSMutableArray *mArr = [EmployerM mj_objectArrayWithKeyValuesArray:arrayTemp];
        successBlock([mArr copy]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        //处理401错误
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSArray *arrayTemp = [responseObject objectForKey:@"employers"];
                    NSMutableArray *mArr = [EmployerM mj_objectArrayWithKeyValuesArray:arrayTemp];
                    successBlock([mArr copy]);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];
        }
        else{
            failBlock(errorStr, statusCode);
        }
    }];
}

#pragma mark-查询公司信息
+ (void)chaXunGSXX:(NSString *)employerID
             token:(TokensM *)token
      successBlock:(void (^)(EmployerM *employer))successBlock
           failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employers"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:employerID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [responseObject objectForKey:@"employer"];
        EmployerM *employer = [EmployerM mj_objectWithKeyValues:dict];
        successBlock(employer);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dict = [responseObject objectForKey:@"employer"];
                    EmployerM *employer = [EmployerM mj_objectWithKeyValues:dict];
                    successBlock(employer);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];
        }else{
            failBlock(errorStr, statusCode);
        }
    }];
}

#pragma mark-获取工作时间
+ (void)huoQuGZSJ:(NSString *)employee_ID
            token:(TokensM *)token
     successBlock:(void (^)(PeriodM *p))successBlock
        failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/periods"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:employee_ID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictP = [responseObject objectForKey:@"period"];
        PeriodM *period = [PeriodM mj_objectWithKeyValues:dictP];
        successBlock(period);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //此处应该刷新token再请求，然而并没有
        }else{
            failBlock(errorStr, statusCode);
        }
    }];
}

#pragma mark-修改工作时间
+ (void)xiuGaiGZSJ:(NSString *)employee_ID
          periodID:(NSString *)period_id
            token:(TokensM *)token
     successBlock:(void (^)(PeriodM *p))successBlock
        failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/periods"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:employee_ID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSDictionary *dictPeriod = @{@"period_id":period_id};
    [manager PUT:urlString parameters:dictPeriod success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictP = [responseObject objectForKey:@"period"];
        PeriodM *period = [PeriodM mj_objectWithKeyValues:dictP];
        successBlock(period);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //此处应该刷新token再请求，然而并没有
        }else{
            failBlock(errorStr, statusCode);
        }
    }];
}

#pragma mark-检查考勤时间变更
+ (void)jianChaSJBG:(NSString *)employee_id
         employerID:(NSString *)employer_id
              token:(TokensM *)token
       successBlock:(void (^)(ChangePeriod *change))successBlock
          failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock{

    NSString *urlTemp = [urlStr stringByAppendingString:@"/periods"];
    NSString *urlTemp1 = [urlTemp stringByAppendingPathComponent:employee_id];
    NSString *urlString = [urlTemp1 stringByAppendingPathComponent:@"check"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSDictionary *body = @{@"employer_id":employer_id};
    [manager POST:urlString parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictCP = [responseObject objectForKey:@"change_period"];
        ChangePeriod *changePeriod = [ChangePeriod mj_objectWithKeyValues:dictCP];
        successBlock(changePeriod);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //此处应该刷新token再请求，然而并没有
        }else{
            failBlock(errorStr, statusCode);
        }
    }];







}

#pragma mark-获取雇员信息
+ (void)huoQuGuYuanXinXi:(NSString *)employee_id
                   token:(TokensM *)token
            successBlock:(void (^)(EmployeeM *emp))successBlock
                 failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employees"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:employee_id];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        successBlock(employee);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dictE = [responseObject objectForKey:@"employee"];
                    EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
                    successBlock(employee);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];
        }else{
            failBlock(errorStr, statusCode);
        }
    }];
}


#pragma mark-修改雇员信息
+ (void)xiuGaiGuYuanXinXi:(NSString *)employeeID
                Employees:(Employees *)employee
                    token:(TokensM *)token
             successBlock:(void (^)(NSArray *array))successBlock
                  failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employees"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:employeeID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSDictionary *dictEmployee = @{@"name":employee.userName,@"phone_number":employee.phone_number,@"captcha":employee.captcha};
    [manager PUT:urlString parameters:dictEmployee success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        NSDictionary *dictT = [responseObject objectForKey:@"avatar_upload_token"];
        ImageUploadToken *imgUptokens = [ImageUploadToken mj_objectWithKeyValues:dictT];
        NSMutableArray *mArr = [NSMutableArray array];
        [mArr addObject:employee];
        [mArr addObject:imgUptokens];
        successBlock([mArr copy]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager PUT:urlString parameters:dictEmployee success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dictE = [responseObject objectForKey:@"employee"];
                    EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
                    NSDictionary *dictT = [responseObject objectForKey:@"avatar_upload_token"];
                    ImageUploadToken *imgUptokens = [ImageUploadToken mj_objectWithKeyValues:dictT];
                    NSMutableArray *mArr = [NSMutableArray array];
                    [mArr addObject:employee];
                    [mArr addObject:imgUptokens];
                    successBlock([mArr copy]);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];
        }else{
            failBlock(errorStr, statusCode);
        }
    }];
}

#pragma mark-修改雇员头像
+ (void)xiuGaiGuYuanTouXiang:(NSString *)employeeID
                       token:(TokensM *)token
                successBlock:(void (^)(EmployeeM *employee,ImageUploadToken *imgUpTokens))successBlock
                   failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employees"];
    NSString *urlTemp2 = [urlTemp stringByAppendingPathComponent:employeeID];
    NSString *urlString = [urlTemp2 stringByAppendingPathComponent:@"avatar"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        NSDictionary *dictT = [responseObject objectForKey:@"avatar_upload_token"];
        ImageUploadToken *imgUpTokens = [ImageUploadToken mj_objectWithKeyValues:dictT];
        successBlock(employee,imgUpTokens);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(errorStr, statusCode);
    }];
}


#pragma mark-获取当前生效合约
+ (void)huoQuDQHY:(NSString *)employee_id
            token:(TokensM *)token
     successBlock:(void (^)(ContractM *contract, EmployerM *employer))successBlock
          failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employees"];
    NSString *urlTemp2 = [urlTemp stringByAppendingPathComponent:employee_id];
    NSString *urlString = [urlTemp2 stringByAppendingString:@"/contracts/effective"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictC = [responseObject objectForKey:@"contract"];
        ContractM *contract = [ContractM mj_objectWithKeyValues:dictC];
        NSDictionary *dictEmployer = [dictC objectForKey:@"employer"];
        EmployerM *employer = [EmployerM mj_objectWithKeyValues:dictEmployer];
        successBlock(contract,employer);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dictC = [responseObject objectForKey:@"contract"];
                    ContractM *contract = [ContractM mj_objectWithKeyValues:dictC];
                    NSDictionary *dictEmployer = [dictC objectForKey:@"employer"];
                    EmployerM *employer = [EmployerM mj_objectWithKeyValues:dictEmployer];
                    successBlock(contract,employer);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];
        }else{
            failBlock(errorStr, statusCode);
        }
    }];
}

#pragma mark-获取打卡汇总(接口已经废弃)
+ (void)huoQuDaKaHuiZong:(NSString *)employeeID
                   token:(TokensM *)token
                beginDay:(NSString *)begin
                  endDay:(NSString *)end
            successBlock:(void (^)(PunchesGather *punchGather))successBlock
               failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlString = [urlStr stringByAppendingFormat:@"/employees/%@/punches_gather",employeeID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    NSDictionary *dayDict = @{@"begin":begin,@"end":end};
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager POST:urlString parameters:dayDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        PunchesGather *pg = [PunchesGather mj_objectWithKeyValues:responseObject];
        successBlock(pg);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(errorStr, statusCode);
    }];
}

#pragma mark-获取雇员列表
+ (void)huoQuGYLB:(NSString *)employee_id
            token:(TokensM *)token
             page:(PageM *)page
     successBlock:(void (^)(NSArray *colleagues,PageM *page))successBlock
        failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlString = [urlStr stringByAppendingFormat:@"/employees/%@/colleagues?per_page=%@&page=%@",employee_id,page.per_page,page.page];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictP = [responseObject objectForKey:@"pages"];
        NSArray *array = [responseObject objectForKey:@"contracts"];
        PageM *page = [PageM mj_objectWithKeyValues:dictP];        
        NSMutableArray *colleagues = [ColleaguesContractM mj_objectArrayWithKeyValuesArray:array];
        successBlock([colleagues copy],page);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(errorStr, statusCode);
    }];
}


#pragma mark-搜索雇员
+ (void)souSuoGYLB:(NSString *)employee_id
              name:(NSString *)searchName
             token:(TokensM *)token
              page:(PageM *)page
      successBlock:(void (^)(NSArray *colleagues,PageM *page))successBlock
         failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;
{
    NSString *urlString = [urlStr stringByAppendingFormat:@"/employees/%@/colleagues?per_page=%@&page=%@&name=%@",employee_id,page.per_page,page.page,searchName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictP = [responseObject objectForKey:@"pages"];
        NSArray *array = [responseObject objectForKey:@"contracts"];
        PageM *page = [PageM mj_objectWithKeyValues:dictP];
        NSMutableArray *colleagues = [ColleaguesContractM mj_objectArrayWithKeyValuesArray:array];
        successBlock([colleagues copy],page);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(errorStr, statusCode);
    }];
}

#pragma mark-根据合约编号查询合约
+ (void)chaXunHeYue:(NSString *)contractID
              token:(TokensM *)token
       successBlock:(void (^)(ContractM *contract))successBlock
            failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/contracts"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:contractID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSDictionary *dict = [responseObject objectForKey:@"contract"];
        ContractM *contract = [ContractM mj_objectWithKeyValues:dict];
        successBlock(contract);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    DLog(@"%@",responseObject);
                    NSDictionary *dict = [responseObject objectForKey:@"contract"];
                    ContractM *contract = [ContractM mj_objectWithKeyValues:dict];
                    successBlock(contract);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];
        }else{
            failBlock(errorStr, statusCode);
        }
    }];
}

#pragma mark-「创建合约」
+ (void)chuangJianHeYue:(NSString *)employerID
                  token:(TokensM *)token
           successBlock:(void (^)(ContractM *cont))successBlock
                failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employers"];
    NSString *urlTempp = [urlTemp stringByAppendingPathComponent:employerID];
    NSString *urlString = [urlTempp stringByAppendingString:@"/contracts"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [responseObject objectForKey:@"contract"];
        ContractM *contract = [ContractM mj_objectWithKeyValues:dict];
        successBlock(contract);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dict = [responseObject objectForKey:@"contract"];
                    ContractM *contract = [ContractM mj_objectWithKeyValues:dict];
                    successBlock(contract);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];

        }else{
            failBlock(errorStr, statusCode);
        }
    }];
}

#pragma mark-撤销创建合约
+ (void)cheXiaoCJHY:(NSString *)contractID
               token:(TokensM *)token
        successBlock:(void (^)())successBlock
            failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/contracts"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:contractID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
   [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       DLog(@"%@",responseObject);
       successBlock();
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
       NSDictionary *dict = [errResponse mj_JSONObject];
       NSString *errorStr =  dict[@"message"];
       NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
       NSInteger statusCode = response.statusCode;
       if (statusCode == 401) {
           NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
           NSDictionary *dictToken = [[NSDictionary alloc]init];
           dictToken = @{@"refresh_token":token.refresh_token};
           //刷新token
           [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               //刷新成功后重新请求
               NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
               TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
               [Verify saveToken:newTokens];
               NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
               [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
               [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   DLog(@"%@",responseObject);
                   successBlock();
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                   NSDictionary *dict = [errResponse mj_JSONObject];
                   NSString *errorStr =  dict[@"message"];
                   NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                   NSInteger statusCode = response.statusCode;
                   failBlock(errorStr, statusCode);
               }];
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
               NSDictionary *dict = [errResponse mj_JSONObject];
               NSString *errorStr =  dict[@"message"];
               NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
               NSInteger statusCode = response.statusCode;
               failBlock(errorStr, statusCode);
           }];

       }else{
           failBlock(errorStr, statusCode);
       }
   }];
}

#pragma mark-创建合约终止
+ (void)zhongZhiHeYue:(NSString *)contractID
                token:(TokensM *)token
         successBlock:(void (^)())successBlock
              failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/contracts"];
    NSString *urlTemp2 = [urlTemp stringByAppendingPathComponent:contractID];
    NSString *urlString = [urlTemp2 stringByAppendingString:@"/termination"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager PUT:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager PUT:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    successBlock();
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];

        }else{
            failBlock(errorStr, statusCode);
        }
    }];

}

#pragma mark-撤销合约的终止
+ (void)chexiaoZZHY:(NSString *)contractID
              token:(TokensM *)token
       successBlock:(void (^)())successBlock
            failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/contracts"];
    NSString *urlTemp2 = [urlTemp stringByAppendingPathComponent:contractID];
    NSString *urlString = [urlTemp2 stringByAppendingString:@"/termination"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    successBlock();
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];

        }else{
            failBlock(errorStr, statusCode);
        }
    }];


}


#pragma mark-打卡
+ (void)daKa:(EmployeePunches *)punchInfo
       token:(TokensM *)token
successBlock:(void (^)(PunchesModel *punModel))successBlock
   failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock

{
    NSString *urlString = [urlStr stringByAppendingString:@"/punches"];
    NSDictionary *dictEmployee = @{@"image_hash":punchInfo.imageHash, @"latitude":punchInfo.latitude, @"longitude":punchInfo.longitude, @"wireless_ap": punchInfo.wirelessAp, @"operating_system": punchInfo.operatingSystem, @"phone_model":punchInfo.phone_model};
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager POST:urlString parameters:dictEmployee progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *image_upload_token = [responseObject objectForKey:@"image_upload_token"];
        NSDictionary *punch = [responseObject objectForKey:@"punch"];
        ImageUploadToken *imageUT = [ImageUploadToken mj_objectWithKeyValues:image_upload_token];
        Punch *p = [Punch mj_objectWithKeyValues:punch];
        PunchesModel *punchesModel = [[PunchesModel alloc]init];
        punchesModel.image_upload_token = imageUT;
        punchesModel.punch = p;
        successBlock(punchesModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401) {
            NSString *urlToken = [urlStr stringByAppendingString:@"/tokens/access"];
            NSDictionary *dictToken = [[NSDictionary alloc]init];
            dictToken = @{@"refresh_token":token.refresh_token};
            //刷新token
            [manager POST:urlToken parameters:dictToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //刷新成功后重新请求
                NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
                TokensM *newTokens = [TokensM mj_objectWithKeyValues:dictT];
                [Verify saveToken:newTokens];
                NSString *tokenStr = [NSString stringWithFormat:@"token %@",newTokens.access_token];
                [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
                [manager POST:urlString parameters:dictEmployee progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *image_upload_token = [responseObject objectForKey:@"image_upload_token"];
                    NSDictionary *punch = [responseObject objectForKey:@"punch"];
                    ImageUploadToken *imageUT = [ImageUploadToken mj_objectWithKeyValues:image_upload_token];
                    Punch *p = [Punch mj_objectWithKeyValues:punch];
                    PunchesModel *punchesModel = [[PunchesModel alloc]init];
                    punchesModel.image_upload_token = imageUT;
                    punchesModel.punch = p;
                    successBlock(punchesModel);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [errResponse mj_JSONObject];
                    NSString *errorStr =  dict[@"message"];
                    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                    NSInteger statusCode = response.statusCode;
                    failBlock(errorStr, statusCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [errResponse mj_JSONObject];
                NSString *errorStr =  dict[@"message"];
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger statusCode = response.statusCode;
                failBlock(errorStr, statusCode);
            }];
        }else{
            failBlock(errorStr, statusCode);
        }
    }];
}

#pragma mark-替别人打卡
+ (void)tiBieRenDaKa:(EmployeePunches *)punchInfo
         employee_id:(NSString *)employeeID
               token:(TokensM *)token
        successBlock:(void (^)(PunchesModel *punModel))successBlock
           failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlString = [urlStr stringByAppendingFormat:@"/punches/%@",employeeID];
    NSDictionary *dictEmployee = @{@"image_hash":punchInfo.imageHash, @"latitude":punchInfo.latitude, @"longitude":punchInfo.longitude, @"wireless_ap": punchInfo.wirelessAp, @"operating_system": punchInfo.operatingSystem, @"phone_model":punchInfo.phone_model};
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager POST:urlString parameters:dictEmployee progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *image_upload_token = [responseObject objectForKey:@"image_upload_token"];
        NSDictionary *punch = [responseObject objectForKey:@"punch"];
        ImageUploadToken *imageUT = [ImageUploadToken mj_objectWithKeyValues:image_upload_token];
        Punch *p = [Punch mj_objectWithKeyValues:punch];
        PunchesModel *punchesModel = [[PunchesModel alloc]init];
        punchesModel.image_upload_token = imageUT;
        punchesModel.punch = p;
        successBlock(punchesModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(errorStr, statusCode);
    }];

}



#pragma mark-获取打卡记录
+ (void)daKaJiLu:(NSString *)employeeID
           token:(TokensM *)token
           beginDay:(NSString *)begin
             endDay:(NSString *)end
    successBlock:(void (^)(NSDictionary *punchDict,PunchesGather *punchGather))successBlock
       failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock
{
    NSString *urlString = [urlStr stringByAppendingFormat:@"/employees/%@/punches",employeeID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    NSDictionary *dayDict = @{@"begin":begin,@"end":end};
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager POST:urlString parameters:dayDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictP = [responseObject objectForKey:@"punches"];
        NSDictionary *dictS = [responseObject objectForKey:@"statistics"];
        PunchesGather *pg = [PunchesGather mj_objectWithKeyValues:dictS];
        successBlock(dictP,pg);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(errorStr, statusCode);
    }];
}

#pragma mark-跨24点考勤检查
+ (void)twentyfourCheckPoint:(NSString *)employee_id
                       token:(TokensM *)token
                SuccessBlock:(void (^)(BOOL waring,PeriodM *period))successBlock
                   failBlock:(void (^)(NSInteger statusCode,NSString *errStr))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/warning"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:employee_id];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token.access_token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictP = [responseObject objectForKey:@"period"];
        PeriodM *period = [PeriodM mj_objectWithKeyValues:dictP];
        BOOL waring = [[responseObject objectForKey:@"warning"] boolValue];
        successBlock(waring,period);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [errResponse mj_JSONObject];
        NSString *errorStr =  dict[@"message"];
        if (errorStr == nil) {
            errorStr = @"服务器连接失败请重试";
        }
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        failBlock(statusCode,errorStr);
    }];

}



@end













