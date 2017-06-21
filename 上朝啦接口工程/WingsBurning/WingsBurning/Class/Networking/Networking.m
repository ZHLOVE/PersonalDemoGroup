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

static NSString *urlStr = @"http://192.168.1.105:5000/api";
static NSString *testUrl = @"http://httpbin.org/post";

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
    });
    return instance;
}


/**
 *  获取验证码
 */
+ (void)huoQuYZM:(NSString *)phoneNumber
    successBlock:(void (^)())successBlock
       failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlString = [urlStr stringByAppendingString:@"/captchas"];
    NSDictionary *dict = @{@"phone_number":phoneNumber};
    [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}


/**
 *  登录
 */

+ (void)dengLu:(NSString *)phoneNumber
     yanZhenMa:(NSString *)yzm
  successBlock:(void (^)(NSArray *arr))successBlock
     failBlock:(void (^)(NSError *error))failBlock

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
        NSLog(@"%@",[error localizedDescription]);
        failBlock(error);
    }];
}


/**
 *  刷新令牌
 */
+ (void)shuaXinLinPai:(NSString *)token
         successBlock:(void (^)(NSArray *arr))successBlock
            failBlock:(void (^)(NSError *error))failBlock{
    NSString *urlString = [urlStr stringByAppendingString:@"/tokens/access"];
    NSDictionary *dict = @{@"refresh_token":token};
    [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        TokensM *tokens = [TokensM mj_objectWithKeyValues:dictT];
        NSArray *array = @[employee,tokens];
        successBlock(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
        failBlock(error);
    }];
}


/**
 *  注册
 *  「创建雇员」接口客户端请求
 */
+ (void)zhuCe:(Employees *) employee
 successBlock:(void (^)(NSArray *arr))successBlock
    failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlString = [urlStr stringByAppendingString:@"/employees"];
    NSDictionary *dict = @{@"name":employee.userName, @"phone_number":employee.phone_number, @"captcha":employee.captcha};
    [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        NSDictionary *dictT = [responseObject objectForKey:@"tokens"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        TokensM *tokens = [TokensM mj_objectWithKeyValues:dictT];
        NSArray *array = @[employee,tokens];
        successBlock(array);
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}


/**
 *  获取公司列表
 */
+ (void)huoQuGSLB:(Employers *)employers
            token:(NSString *)token
     successBlock:(void (^)(NSArray *arr))successBlock
        failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlString = [urlStr stringByAppendingString:@"/employers"];
    NSDictionary *dict = @{@"page":employers.page, @"phone_number":employers.per_page, @"captcha":employers.name};
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arrayTemp = [responseObject objectForKey:@"employers"];
        NSMutableArray *mArr = [EmployerM mj_objectArrayWithKeyValuesArray:arrayTemp];
        successBlock([mArr copy]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}

/**
 *  查询公司信息
 */
+ (void)chaXunGSXX:(NSString *)employerID
             token:(NSString *)token
      successBlock:(void (^)(EmployerM *employer))successBlock
         failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employers"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:employerID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [responseObject objectForKey:@"employer"];
        EmployerM *employer = [EmployerM mj_objectWithKeyValues:dict];
        successBlock(employer);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];

}

/**
 *  获取雇员信息
 *
 */
+ (void)huoQuGuYuanXinXi:(NSString *)employee_id
                   token:(NSString *)token
            successBlock:(void (^)(EmployeeM *emp))successBlock
               failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employees"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:employee_id];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        successBlock(employee);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}

/**
 *  修改雇员信息
 */
+ (void)xiuGaiGuYuanXinXi:(NSString *)employeeID
                Employees:(Employees *)employee
                    token:(NSString *)token
             successBlock:(void (^)(NSArray *array))successBlock
                failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employees"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:employeeID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict = @{@"name":employee.userName,@"phone_number":employee.phone_number,@"captcha":employee.captcha};
    [manager PUT:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictE = [responseObject objectForKey:@"employee"];
        EmployeeM *employee = [EmployeeM mj_objectWithKeyValues:dictE];
        NSDictionary *dictT = [responseObject objectForKey:@"avatar_upload_token"];
        ImageUploadToken *imgUptokens = [ImageUploadToken mj_objectWithKeyValues:dictT];
        NSMutableArray *mArr = [NSMutableArray array];
        [mArr addObject:employee];
        [mArr addObject:imgUptokens];
        successBlock([mArr copy]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];


}


/**
 *  获取当前生效合约
 */
+ (void)huoQuDQHY:(NSString *)employee_id
            token:(NSString *)token
     successBlock:(void (^)(ContractM *contract))successBlock
        failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employees"];
    NSString *urlTemp2 = [urlTemp stringByAppendingPathComponent:employee_id];
    NSString *urlString = [urlTemp2 stringByAppendingString:@"/contracts/effective"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictC = [responseObject objectForKey:@"contract"];
        ContractM *contract = [ContractM mj_objectWithKeyValues:dictC];
        successBlock(contract);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"the response state code is %ld", (long)urlResponse.statusCode);
    }];
}

/**
 *  根据合约编号查询合约
 */
+ (void)chaXunHeYue:(NSString *)contractID
              token:(NSString *)token
       successBlock:(void (^)(ContractM *contract))successBlock
          failBlock:(void (^)(NSError *error))failBlock
{
//    GET  /contracts/{contract_id}
    NSString *urlTemp = [urlStr stringByAppendingString:@"/contracts"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:contractID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = [responseObject objectForKey:@"contract"];
        ContractM *contract = [ContractM mj_objectWithKeyValues:dict];
        successBlock(contract);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"the response state code is %ld", (long)urlResponse.statusCode);
    }];
}

/**
 *  「创建合约」接口服务器响应
 *
 */
+ (void)chuangJianHeYue:(NSString *)employerID
                  token:(NSString *)token
           successBlock:(void (^)(ContractM *cont))successBlock
              failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employers"];
    NSString *urlTempp = [urlTemp stringByAppendingPathComponent:employerID];
    NSString *urlString = [urlTempp stringByAppendingString:@"/contracts"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [responseObject objectForKey:@"contract"];
        ContractM *contract = [ContractM mj_objectWithKeyValues:dict];
        successBlock(contract);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}

/**
 *  撤销创建合约
 */
+ (void)cheXiaoCJHY:(NSString *)contractID
               token:(NSString *)token
        successBlock:(void (^)())successBlock
           failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/contracts"];
    NSString *urlString = [urlTemp stringByAppendingPathComponent:contractID];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
   [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       successBlock();
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       failBlock(error);
   }];


}

/**
 *  创建合约终止
 */
+ (void)zhongZhiHeYue:(NSString *)contractID
                token:(NSString *)token
         successBlock:(void (^)())successBlock
            failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/contracts"];
    NSString *urlTemp2 = [urlTemp stringByAppendingPathComponent:contractID];
    NSString *urlString = [urlTemp2 stringByAppendingString:@"/termination"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager PUT:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];

}

/**
 *  撤销合约的终止
 */
+ (void)chexiaoZZHY:(NSString *)contractID
              token:(NSString *)token
       successBlock:(void (^)())successBlock
          failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlTemp = [urlStr stringByAppendingString:@"/contracts"];
    NSString *urlTemp2 = [urlTemp stringByAppendingPathComponent:contractID];
    NSString *urlString = [urlTemp2 stringByAppendingString:@"/termination"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSLog(@"%@",responseObject);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       failBlock(error);
   }];


}






/**
 *  打卡
 */
+ (void)daKa:(EmployeePunches *)punchInfo
       token:(NSString *)token
successBlock:(void (^)(PunchesModel *punModel))successBlock
   failBlock:(void (^)(NSError *error))failBlock

{
    NSString *urlString = [urlStr stringByAppendingString:@"/punches"];
    NSDictionary *dict = @{@"image_hash":punchInfo.imageHash, @"latitude":punchInfo.latitude, @"longitude":punchInfo.longitude, @"wireless_ap": punchInfo.wirelessAp, @"operating_system": punchInfo.operatingSystem, @"phone_model":punchInfo.phone_model};
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *image_upload_token = [responseObject objectForKey:@"image_upload_token"];
        NSDictionary *punch = [responseObject objectForKey:@"punch"];
        ImageUploadToken *imageUT = [ImageUploadToken mj_objectWithKeyValues:image_upload_token];
        Punch *p = [Punch mj_objectWithKeyValues:punch];
        PunchesModel *punchesModel = [[PunchesModel alloc]init];
        punchesModel.image_upload_token = imageUT;
        punchesModel.punch = p;
        successBlock(punchesModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",task);
        failBlock(error);
    }];

}

/**
 *  获取打卡记录
 */
+ (void)daKaJiLu:(NSString *)employeeID
           token:(NSString *)token
    successBlock:(void (^)(PunchRecordM *punchRecord))successBlock
       failBlock:(void (^)(NSError *error))failBlock
{
//    /employees/{employee_id}/punches
    NSString *urlTemp = [urlStr stringByAppendingString:@"/employees"];
    NSString *urlTemp2 = [urlTemp stringByAppendingPathComponent:employeeID];
    NSString *urlString = [urlTemp2 stringByAppendingString:@"/punches"];
    NSString *tokenStr = [NSString stringWithFormat:@"token %@",token];
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = [responseObject objectForKey:@"pages"];
        NSArray *array = [responseObject objectForKey:@"punches"];
        PageM *page = [PageM mj_objectWithKeyValues:dict];
        NSMutableArray *punchMuArray = [Punch mj_objectArrayWithKeyValuesArray:array];
        PunchRecordM *punchRecord = [[PunchRecordM alloc]init];
        punchRecord.page = page;
        NSLog(@"%@",punchMuArray);
        punchRecord.punchArray = [punchMuArray copy];
        successBlock(punchRecord);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}
@end













