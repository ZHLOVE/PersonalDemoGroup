//
//  SJPhoneFareViewModel.h
//  ShiJia
//
//  Created by 峰 on 2016/12/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJPhoneFareModel.h"
#import "OrderDetailEntity.h"

@protocol PhoneFareDelegate;


@interface SJPhoneFareViewModel : NSObject

@property (nonatomic, weak) id<PhoneFareDelegate>phonefaredelegate;


/**
 * 查询订单
 */

-(void)GetOrderDetailWithSequenceId:(NSString *)idString;

/**
 *  话费支付下单
 */
-(void)payDealByPhoneFare:(PayRequestParam *)params;

/**
 *  话费支付确认
 */
-(void)confirmPayDealByPhoneFare:(confirmRequsetParams *)params;


/**
 *  获取验证码
 */

-(void)getSmsCode:(smsCodeParams *)parmas;

/**
 *  @author Allen, 17-03-29 14:03:34
 *
 *  @brief 获取支付令牌接口
 *
 *  @since
 */
-(void)PhoneFare_receiveH5PayParams:(requestH5Params *)params;

-(void)QueryOrderStatus:(NSString *)orderNo merchantCode:(NSString *)codeString;

@end
//===============================**phonedelegate**=============================================//
@protocol PhoneFareDelegate <NSObject>

@optional

-(void)HandPhoneFareError:(NSError *)error;

-(void)PhoneFare_getChooseTypeRespone:(OrderDetailEntity *)dataEntity andError:(NSError *)error;

/**
 *   下单
 */
-(void)PhoneFare_makeDealResopnse:(BOOL)success withData:(PhoneFareResponse *)dict;

/**
 * 支付
 */

-(void)PhoneFare_payDealResponse:(BOOL)responseSuccess;

/**
 *  获取验证码
 */

-(void)PhoneFare_receiveSmsCode:(BOOL )code;



/**
 *  @author Allen, 17-03-29 14:03:21
 *
 *  @brief 获取H5支付页面参数
 *
 *  @since
 */

-(void)receiveH5PayParams:(H5PayParams *)params;

-(void)OrderStatus:(BOOL)success;


@end
