//
//  SJPhoneFareModel.h
//  ShiJia
//
//  Created by 峰 on 2016/12/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJPhoneFareModel : NSObject

@end
/*
 *下单请求参数 1 必 2选
 */
@interface PayRequestParam : NSObject

@property (nonatomic, strong) NSString  *orderNo;//(1)商户订单号
@property (nonatomic, strong) NSString  *merchantCode;//(1)商家标识
@property (nonatomic, assign) NSInteger totalAmount;//(1)订单总金额(单位：分)
@property (nonatomic, strong) NSString  *productId;//(1)产品包ID
@property (nonatomic, strong) NSString  *contentId;//产品内容ID
@property (nonatomic, strong) NSString  *productName;//-1-产品包名称
@property (nonatomic, strong) NSString  *custId;//-1-用户主帐号
@property (nonatomic, strong) NSString  *uid;//-1-用户中心UID
@property (nonatomic, strong) NSString  *phoneNum;//手机号
@property (nonatomic, strong) NSString  *userSource;//-1-SP CP
@property (nonatomic, strong) NSString  *source;

@end
/**
 *  确定请求
 */
@interface confirmRequsetParams : NSObject
@property (nonatomic, strong) NSString *linkId;//(1)订单linkId
@property (nonatomic, strong) NSString *smsCode;//(2)手机验证码
@property (nonatomic, strong) NSString *source;//PHONE  

@end
/**
 *  获取验证码
 */
@interface smsCodeParams : NSObject

@property (nonatomic, strong) NSString *linkId;

@end
/*{
    detailMessage = "";
    isNeedSmsCode = "";
    linkId = "";
    message = "运营商处理异常";
    reserve = "";
    result = "PAY-670";
}*/
@interface PhoneFareResponse : NSObject

@property (nonatomic, strong) NSString *detailMessage;
@property (nonatomic, strong) NSString *isNeedSmsCode;
@property (nonatomic, strong) NSString *linkId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *result;


@end

@interface ConfirmResponse : NSObject

@end

@interface smsResponse : NSObject

@end
/*
1		result	        必须	String	10	返回结果码
2		message	        选择	String	256	结果信息描述
3		detailMessage	选择	String	200	详细信息描述
4		sessionId	    必须	String	200	支付令牌
5		redirectUrl	    必须	String	100	跳转地址*/
@interface H5PayParams : NSObject

@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *detailMessage;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *redirectUrl;
//@property (nonatomic, copy) NSString *sequenceId;
//@property (nonatomic, copy) NSString *pollingTime;
//@property (nonatomic, copy) NSString *qrCodeImageUrl;
//@property (nonatomic, copy) NSString *reserve;

@end
//获取支付令牌请求参数
/*
 uid	        必须	String	32	用户中心ID
 orderNo	    必须	String	64	订单编号
 merchantCode	必须	String	64	商户号 (下单返回)
 totalAmount	必须	String	19	支付金额(单位：分)
 productId	    必须	String	32	产品包ID
 contentId	    否	String	32	内容ID
 productName	是	String	64	产品包名称
 contentName	否	String	64	产品内容名称
 payCode	    否	String	11	用户登录手机号码
 token	        否	String	300	用户中心TOKEN
 spToken	    否	String	300	运营商TOKEN
 accessType	    是	String	10	接入方式：API(接口接入，需要验签)	HTML(html页面接入-云端接入,无需验签) 手机端传空
 sign	        是	String	500	签名
 */
@interface requestH5Params : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *merchantCode;
@property (nonatomic, assign) NSInteger totalAmount;
@property (nonatomic, strong) NSString *productId;
//@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *productName;
//@property (nonatomic, strong) NSString *contentName;
@property (nonatomic, strong) NSString *payCode;
//@property (nonatomic, strong) NSString *token;
//@property (nonatomic, strong) NSString *spToken;
@property (nonatomic, strong) NSString *accessType;
//@property (nonatomic, strong) NSString *sign;
@end

@interface H5CallBackParams : NSObject
@property (nonatomic, strong) NSString *orderstatus;
@end


