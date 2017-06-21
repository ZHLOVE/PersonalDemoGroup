//
//  Networking.h
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetModel.h"


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
    successBlock:(void (^)())successBlock
       failBlock:(void (^)(NSError *error))failBlock;

/**
 *  登录
 */

+ (void)dengLu:(NSString *)phoneNumber
     yanZhenMa:(NSString *)yzm
  successBlock:(void (^)(NSArray *arr))successBlock
     failBlock:(void (^)(NSError *error))failBlock;

/**
 *  刷新Token
 *
 */
+ (void)shuaXinLinPai:(NSString *)token
         successBlock:(void (^)(NSArray *arr))successBlock
            failBlock:(void (^)(NSError *error))failBlock;

/**
 *  注册
 */
+ (void)zhuCe:(Employees *) employee
 successBlock:(void (^)(NSArray *arr))successBlock
    failBlock:(void (^)(NSError *error))failBlock;

/**
 *  打卡
 */
+ (void)daKa:(EmployeePunches *)punchInfo
       token:(NSString *)token
successBlock:(void (^)(PunchesModel *punModel))successBlock
   failBlock:(void (^)(NSError *error))failBlock;

/**
 *  获得雇员信息
 *
 */
+ (void)huoQuGuYuanXinXi:(NSString *)employee_id
                   token:(NSString *)token
            successBlock:(void (^)(EmployeeM *emp))successBlock
               failBlock:(void (^)(NSError *error))failBlock;
/**
 *  修改雇员信息
 */
+ (void)xiuGaiGuYuanXinXi:(NSString *)employeeID
                Employees:(Employees *)employee
                    token:(NSString *)token
             successBlock:(void (^)(NSArray *array))successBlock
                failBlock:(void (^)(NSError *error))failBlock;

/**
 *  获取公司列表
 */
+ (void)huoQuGSLB:(Employers *)employers
            token:(NSString *)token
     successBlock:(void (^)(NSArray *arr))successBlock
        failBlock:(void (^)(NSError *error))failBlock;

/**
 *  查询公司信息
 */
+ (void)chaXunGSXX:(NSString *)employerID
             token:(NSString *)token
      successBlock:(void (^)(EmployerM *employer))successBlock
         failBlock:(void (^)(NSError *error))failBlock;



/**
 *  创建合约
 */
+ (void)chuangJianHeYue:(NSString *)employerID
                  token:(NSString *)token
           successBlock:(void (^)(ContractM *cont))successBlock
              failBlock:(void (^)(NSError *error))failBlock;

/**
 *  撤销创建合约
 *
 */
+ (void)cheXiaoCJHY:(NSString *)contractID
              token:(NSString *)token
       successBlock:(void (^)())successBlock
          failBlock:(void (^)(NSError *error))failBlock;

/**
 *  申请终止合约
 *
 */
+ (void)zhongZhiHeYue:(NSString *)contractID
                token:(NSString *)token
         successBlock:(void (^)())successBlock
            failBlock:(void (^)(NSError *error))failBlock;

/**
 *  撤销终止合约
 *
 */
+ (void)chexiaoZZHY:(NSString *)contractID
              token:(NSString *)token
       successBlock:(void (^)())successBlock
          failBlock:(void (^)(NSError *error))failBlock;


/**
 *  获取当前合约信息
 */
+ (void)huoQuDQHY:(NSString *)employee_id
            token:(NSString *)token
     successBlock:(void (^)(ContractM *contract))successBlock
        failBlock:(void (^)(NSError *error))failBlock;

/**
 *  根据合约编号查询合约
 */
+ (void)chaXunHeYue:(NSString *)contractID
              token:(NSString *)token
       successBlock:(void (^)(ContractM *contract))successBlock
          failBlock:(void (^)(NSError *error))failBlock;

/**
 *  打卡记录
 */
+ (void)daKaJiLu:(NSString *)employeeID
           token:(NSString *)token
    successBlock:(void (^)(PunchRecordM *punchRecord))successBlock
       failBlock:(void (^)(NSError *error))failBlock;




@end






























