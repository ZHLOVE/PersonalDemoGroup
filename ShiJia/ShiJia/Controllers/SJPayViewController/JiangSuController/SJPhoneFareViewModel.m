 //
//  SJPhoneFareViewModel.m
//  ShiJia
//
//  Created by 峰 on 2016/12/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPhoneFareViewModel.h"
#import "OrderDetailEntity.h"

@implementation SJPhoneFareViewModel
-(void)GetOrderDetailWithSequenceId:(NSString *)idString{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:idString forKey:@"sequenceId"];
    [parameters setValue:@"IOS" forKey:@"phoneType"];
    [parameters setValue:@"" forKey:@"token"];
    [parameters setValue:@"6.5.2" forKey:@"version"];

//@"http://192.168.50.97:8080/yst-ord-mpi/"  BUSINESSHOST
    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/phone/order/getOrderDetail" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            OrderDetailEntity *entity = [[OrderDetailEntity alloc]initWithDictionary:responseDic];
            if ([self.phonefaredelegate respondsToSelector:@selector(PhoneFare_getChooseTypeRespone:andError:)]) {
                [self.phonefaredelegate PhoneFare_getChooseTypeRespone:entity andError:nil];
            }

        }else{
            if ([self.phonefaredelegate respondsToSelector:@selector(PhoneFare_getChooseTypeRespone:andError:)]) {
                [self.phonefaredelegate PhoneFare_getChooseTypeRespone:nil andError:SJERROR([responseDic objectForKey:@"detailMessage"])];
            }

        }

    }failure:^(NSString *error) {
        if ([self.phonefaredelegate respondsToSelector:@selector(PhoneFare_getChooseTypeRespone:andError:)]) {
            [self.phonefaredelegate PhoneFare_getChooseTypeRespone:nil andError:SJERROR(error)];
        }
    }];

}

-(void)payDealByPhoneFare:(PayRequestParam *)params{

    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_YSTEN_PAY,@"/order/submitPayRequest"];
    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {

                                           PhoneFareResponse *result = [PhoneFareResponse mj_objectWithKeyValues:responseObject];

                                           if ([result.result isEqualToString:@"PAY-000"]) {
                                               [self.phonefaredelegate PhoneFare_makeDealResopnse:YES withData:result];
                                           }else{
                                               [self.phonefaredelegate HandPhoneFareError:SJERROR(result.message)];
                                           }

                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {

                                              if ([self.phonefaredelegate respondsToSelector:@selector(HandPhoneFareError:)]) {
                                                  [self.phonefaredelegate HandPhoneFareError:SJERROR(error)];
                                              }

                                          }];

}

-(void)confirmPayDealByPhoneFare:(confirmRequsetParams *)params{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_YSTEN_PAY,@"/order/payAccept"];

    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {
                                           
                                           if ([[responseObject objectForKey:@"result"] isEqualToString:@"PAY-000"]) {
                                               if ([self.phonefaredelegate respondsToSelector:@selector(PhoneFare_payDealResponse:)]) {
                                                   [self.phonefaredelegate PhoneFare_payDealResponse:YES];
                                               }
                                           }else{
                                               if ([self.phonefaredelegate respondsToSelector:@selector(HandPhoneFareError:)]) {
                                                   [self.phonefaredelegate HandPhoneFareError:SJERROR([responseObject objectForKey:@"message"])];
                                               }
                                           }
                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              [self.phonefaredelegate HandPhoneFareError:SJERROR(error)];
                                          }];

}

-(void)getSmsCode:(smsCodeParams *)params{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_YSTEN_PAY,@"/order/getSmsCode"];
    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {
                                           if ([[responseObject objectForKey:@"result"] isEqualToString:@"PAY-000"]){
                                               if ([self.phonefaredelegate respondsToSelector:@selector(PhoneFare_receiveSmsCode:)]) {
                                                   [self.phonefaredelegate PhoneFare_receiveSmsCode:YES];
                                               }
                                           }else{
                                               if ([self.phonefaredelegate respondsToSelector:@selector(HandPhoneFareError:)]) {
                                                   [self.phonefaredelegate HandPhoneFareError:SJERROR([responseObject objectForKey:@"message"])];
                                               }
                                               
                                           }
                                           
                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              [self.phonefaredelegate HandPhoneFareError:SJERROR(error)];
                                          }];
    
}

-(void)PhoneFare_receiveH5PayParams:(requestH5Params *)params{

    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_YSTEN_PAY,@"order/getSessionId"];
    //NSString *urlString = @"http://112.25.7.58:8118/yst-pms-api/order/getSessionId";
    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:[params mj_keyValues]
                                       completion:^(id responseObject) {
                                           if ([[responseObject objectForKey:@"result"] isEqualToString:@"PAY-000"]){
                                               if ([self.phonefaredelegate respondsToSelector:@selector(receiveH5PayParams:)]) {
                                                   H5PayParams *params = [H5PayParams mj_objectWithKeyValues:responseObject];
                                                   [self.phonefaredelegate receiveH5PayParams:params];
                                               }
                                           }else{
                                               if ([self.phonefaredelegate respondsToSelector:@selector(HandPhoneFareError:)]) {
                                                   [self.phonefaredelegate HandPhoneFareError:SJERROR([responseObject objectForKey:@"message"])];
                                               }

                                           }

                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              [self.phonefaredelegate HandPhoneFareError:SJERROR(error)];
                                          }];

}

-(void)QueryOrderStatus:(NSString *)orderNo merchantCode:(NSString *)codeString{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BIMS_YSTEN_PAY,@"/order/queryStatus.json"];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:orderNo forKey:@"orderNo"];
    [dict setObject:codeString forKey:@"merchantCode"];

    [BaseAFHTTPManager getRequestOperationForHost:urlString
                                         forParam:@""
                                    forParameters:dict
                                       completion:^(id responseObject) {
                                           if ([[responseObject objectForKey:@"result"] isEqualToString:@"PAY-000"]){
                                               if ([self.phonefaredelegate respondsToSelector:@selector(OrderStatus:)]) {
                                                   [self.phonefaredelegate OrderStatus:YES];
                                               }
                                           }else{
                                               if ([self.phonefaredelegate respondsToSelector:@selector(OrderStatus:)]) {
                                                   [self.phonefaredelegate OrderStatus:NO];
                                               }

                                           }

                                       }
                                          failure:^(AFHTTPRequestOperation *operation, NSString *error) {
                                              [self.phonefaredelegate HandPhoneFareError:SJERROR(error)];
                                          }];
}
@end
