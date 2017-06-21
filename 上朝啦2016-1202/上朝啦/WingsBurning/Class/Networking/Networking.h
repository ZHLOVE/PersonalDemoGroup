//
//  Networking.h
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetModel.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif


@interface Networking : NSObject

@property(nonatomic,strong) NSString * urlStr;

/**
 *  创建单例
 */
+ (instancetype)sharedNetwork;

/**
 *  获取验证码
 *
 */
+ (void)huoQuYZM:(NSString *)phoneNumber
          action:(NSString *)action
    successBlock:(void (^)())successBlock
       failBlock:(void (^)(NSInteger statusCode,NSString *errStr))failBlock;

/**
 *  登录
 */

+ (void)dengLu:(NSString *)phoneNumber
     yanZhenMa:(NSString *)yzm
  successBlock:(void (^)(NSArray *arr))successBlock
     failBlock:(void (^)(NSInteger statusCode,NSString *errStr))failBlock;

/**
 *  刷新Token
 *
 */
+ (void)shuaXinLinPai:(NSString *)token
         successBlock:(void (^)(NSArray *arr))successBlock
            failBlock:(void (^)(NSString *errStr))failBlock;



/**
 *  注册
 */
+ (void)zhuCe:(Employees *) employee
 successBlock:(void (^)(NSArray *arr))successBlock
    failBlock:(void (^)(NSString *errStr))failBlock;

/**
 *  打卡
 */
+ (void)daKa:(EmployeePunches *)punchInfo
       token:(TokensM *)token
successBlock:(void (^)(PunchesModel *punModel))successBlock
   failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  替别人打卡
 */
+ (void)tiBieRenDaKa:(EmployeePunches *)punchInfo
         employee_id:(NSString *)employeeID
               token:(TokensM *)token
        successBlock:(void (^)(PunchesModel *punModel))successBlock
           failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  获得雇员信息
 *
 */
+ (void)huoQuGuYuanXinXi:(NSString *)employee_id
                   token:(TokensM *)token
            successBlock:(void (^)(EmployeeM *emp))successBlock
               failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;
/**
 *  修改雇员信息
 */
+ (void)xiuGaiGuYuanXinXi:(NSString *)employeeID
                Employees:(Employees *)employee
                    token:(TokensM *)token
             successBlock:(void (^)(NSArray *array))successBlock
                failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  修改雇员头像
 */
+ (void)xiuGaiGuYuanTouXiang:(NSString *)employeeID
                       token:(TokensM *)token
                successBlock:(void (^)(EmployeeM *employee,ImageUploadToken *imgUpTokens))successBlock
                   failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;
/**
 *  获取同事列表
 */
+ (void)huoQuGYLB:(NSString *)employee_id
            token:(TokensM *)token
             page:(PageM *)page
     successBlock:(void (^)(NSArray *colleagues,PageM *page))successBlock
        failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;


/**
 *  获取每月打卡汇总
 */
+ (void)huoQuDaKaHuiZong:(NSString *)employeeID
                   token:(TokensM *)token
                beginDay:(NSString *)begin
                  endDay:(NSString *)end
            successBlock:(void (^)(PunchesGather *punchGather))successBlock
               failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  获取公司列表
 */
+ (void)huoQuGSLB:(Employers *)employers
            token:(TokensM *)token
     successBlock:(void (^)(NSArray *arr))successBlock
        failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  查询公司信息
 */
+ (void)chaXunGSXX:(NSString *)employerID
             token:(TokensM *)token
      successBlock:(void (^)(EmployerM *employer))successBlock
        failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;
/**
 *  获取工作时间
 */
+ (void)huoQuGZSJ:(NSString *)employer_id
            token:(TokensM *)token
     successBlock:(void (^)(NSArray *array))successBlock
        failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;


/**
 *  创建合约
 */
+ (void)chuangJianHeYue:(NSString *)employerID
                  token:(TokensM *)token
           successBlock:(void (^)(ContractM *cont))successBlock
              failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  撤销创建合约
 *
 */
+ (void)cheXiaoCJHY:(NSString *)contractID
              token:(TokensM *)token
       successBlock:(void (^)())successBlock
          failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  申请终止合约
 *
 */
+ (void)zhongZhiHeYue:(NSString *)contractID
                token:(TokensM *)token
         successBlock:(void (^)())successBlock
            failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  撤销终止合约
 *
 */
+ (void)chexiaoZZHY:(NSString *)contractID
              token:(TokensM *)token
       successBlock:(void (^)())successBlock
          failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;


/**
 *  获取当前合约信息
 */
+ (void)huoQuDQHY:(NSString *)employee_id
            token:(TokensM *)token
     successBlock:(void (^)(ContractM *contract, EmployerM *employer))successBlock
        failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  根据合约编号查询合约
 */
+ (void)chaXunHeYue:(NSString *)contractID
              token:(TokensM *)token
       successBlock:(void (^)(ContractM *contract))successBlock
          failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;

/**
 *  打卡记录
 */
+ (void)daKaJiLu:(NSString *)employeeID
           token:(TokensM *)token
        beginDay:(NSString *)begin
          endDay:(NSString *)end
    successBlock:(void (^)(NSDictionary *punchDict))successBlock
       failBlock:(void (^)(NSString *errStr,NSInteger statusCode))failBlock;




@end






























