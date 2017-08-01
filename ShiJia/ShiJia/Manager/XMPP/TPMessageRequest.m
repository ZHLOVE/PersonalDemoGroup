//
//  TPRequestManager.m
//  HiTV
//
//  Created by yy on 15/7/28.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPMessageRequest.h"
#import "AFNetworking.h"
#import "TPIMMessageModel.h"
#import "MJExtension.h"
#import "TPIMNodeModel.h"
#import "MsProtocol.h"
#import "BaseAFHTTPManager.h"
#import "HiTVGlobals.h"
#import "UpYun.h"
#import "NSString+Conversion.h"
#import "SJLocailFileResponseModel.h"
#import "TPIMTokenData.h"

//static NSString * const kXmppServiceUrl = @"http://223.82.249.149:8081";

@implementation TPMessageRequest

#pragma mark - request
+ (void)sendMessage:(TPIMMessageModel *)message completion:(void (^)(id, NSError *))handler
{
    if (message == nil) {
        return;
    }

    //from
    if (message.from == nil) {
        
        TPIMNodeModel *fromNode = [[TPIMNodeModel alloc] init];
        fromNode.uid = [NSString stringWithFormat:@"%@",[HiTVGlobals sharedInstance].uid];
        fromNode.jid = [HiTVGlobals sharedInstance].xmppUserId;
        
        fromNode.nickname = [HiTVGlobals sharedInstance].nickName;
        message.from = fromNode;
    }
    
    NSString *jsonString = [message mj_JSONString];
    
    //manager
    AFHTTPRequestOperationManager *_manager = [[AFHTTPRequestOperationManager alloc] init];
    
    [_manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [_manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [_manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/xml", @"text/plain",@"application/x-www-form-urlencoded", nil]];
    AFJSONResponseSerializer *responseS = (AFJSONResponseSerializer *)_manager.responseSerializer;
    [responseS setReadingOptions:NSJSONReadingAllowFragments];
    [_manager setResponseSerializer:responseS];
    
    [_manager.requestSerializer setTimeoutInterval:30];
    
//    NSString *
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/sendMessage",MSGCENTERHOST]]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
    AFHTTPRequestOperation *op = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogInfo(@"JSON responseObject: %@ ",responseObject);
        handler(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"Error: %@", [error localizedDescription]);
        handler(nil, error);
        
    }];
    
    [op start];

}

+ (void)uploadRecordFile:(NSData *)data completion:(void (^)(NSString *, NSError *))handler
{
    if (data == nil) {
        return;
    }
    
    [[TPMessageRequest class] uploadRecordFileToUpYun:data completion:^(NSString *url, NSError *error) {
        handler(url, error);
    }];
    
}

+ (void)uploadVideoFile:(NSData *)data completion:(void (^)(NSString *, NSError *))handler
{
    if (data == nil) {
        return;
    }
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
#ifdef TEST_UID
    [parameters setValue:TEST_UID forKey:@"phoneUid"];
#else
    [parameters setValue:[[HiTVGlobals sharedInstance]uid] forKey:@"phoneUid"];
#endif
    [parameters setValue:@"view" forKey:@"type"];
    
    NSString *mimetype = @"";
    NSString *filename = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    filename = [NSString stringWithFormat:@"%@.mp4",date];
    
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/ms_selfFile_upload" forParameters:parameters data:data filename:filename mimetype:mimetype completion:^(id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            
            NSString *result = [resultDic objectForKey:@"message"];
            handler(result,nil);
        } else {
            handler(nil,nil);
        }
    } failure:^(NSString *error) {
        
    }];
    
}

// old：上传文件到服务器
+ (void)uploadRecordFileToServer:(NSData *)data completion:(void (^)(NSString *, NSError *))handler
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
#ifdef TEST_UID
    [parameters setValue:TEST_UID forKey:@"phoneUid"];
#else
    [parameters setValue:[[HiTVGlobals sharedInstance]uid] forKey:@"phoneUid"];
#endif
    [parameters setValue:@"audio" forKey:@"type"];
    
    NSString *mimetype = @"";
    NSString *filename = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    filename = [NSString stringWithFormat:@"%@.wav",date];
    
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/ms_selfFile_upload" forParameters:parameters data:data filename:filename mimetype:mimetype completion:^(id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            
            NSString *result = [resultDic objectForKey:@"message"];
            handler(result,nil);
        } else {
            handler(nil,nil);
        }
    } failure:^(NSString *error) {
        
    }];
}

// new: 上传文件到又拍云
+ (void)uploadRecordFileToUpYun:(NSData *)data completion:(void (^)(NSString *, NSError *))handler
{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = UPaiYunKey1;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = UPaiYunKey2;
    [UPYUNConfig sharedInstance].FormAPIDomain = BIMS_CLOUD_ALBUMS_UPLOAD_URL;
    UpYun *uy = [[UpYun alloc] init];
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
            
            NSString *url = [NSString stringWithFormat:@"%@/%@",CLOUD_SERVER,model.url];
            handler(url, nil);
        }
        else{
            handler(nil, nil);
        }
        
        
    };
    uy.failBlocker = ^(NSError * error) {
        
        handler(nil,error);
    };
    uy.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {
        
        handler(nil,nil);
    };
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    NSString *filename = [NSString stringWithFormat:@"%@.wav",date];
    
    [uy uploadFile:data saveKey:filename];
}

+ (void)uploadDeviceTokenWithCompletion:(void (^)(NSString *, NSError *))handler
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //NSString *tokenKey = [NSString stringWithFormat:@"%@%@",[HiTVGlobals sharedInstance].uid,Is_Upload_Device_Token];
    //__block BOOL isUpload = [defaults boolForKey:tokenKey];
    
    if ([HiTVGlobals sharedInstance].isManualLogIn) {
        
        NSString *token = [defaults valueForKey:DEVICE_TOKEN];
        
        if ([HiTVGlobals sharedInstance].isLogin && [HiTVGlobals sharedInstance].uid.description.length != 0 && token.length != 0) {
            
            TPIMTokenData *tokenData = [[TPIMTokenData alloc] init];
            tokenData.uid = [NSString stringWithFormat:@"%@",[HiTVGlobals sharedInstance].uid.description];
            tokenData.jid = [HiTVGlobals sharedInstance].xmppUserId;
            tokenData.token = [NSString stringWithFormat:@"%@",token];
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    tokenData.uid,@"uid",
                                    tokenData.jid,@"jid",
                                    tokenData.token,@"token",
                                    BIMS_DOMAIN,@"area",
                                    nil];
            
            //http://192.168.50.171:8002/yst-ms-facade/，MSGCENTERHOST
            [TPMessageRequest uploadDeviceTokenRequestWithParams:params handler:^(NSString *response, NSError *error) {
                handler(response,error);

            }];
            
        }
    }
    
    
}

+ (void)removeDeviceTokenWithCompletion:(void (^)(NSString *, NSError *))handler
{
    TPIMTokenData *tokenData = [[TPIMTokenData alloc] init];
    tokenData.uid = [NSString stringWithFormat:@"%@",[HiTVGlobals sharedInstance].uid.description];
    tokenData.jid = [HiTVGlobals sharedInstance].xmppUserId;
    tokenData.token = @"";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            tokenData.uid,@"uid",
                            tokenData.jid,@"jid",
                            tokenData.token,@"token",
                            BIMS_DOMAIN,@"area",
                            nil];
    
    //http://192.168.50.171:8002/yst-ms-facade/，MSGCENTERHOST
    [TPMessageRequest uploadDeviceTokenRequestWithParams:params handler:^(NSString *response, NSError *error) {
        handler(response,error);
    }];
}

+ (void)uploadDeviceTokenRequestWithParams:(NSDictionary *)paramDic handler:(void (^)(NSString *, NSError *))handler
{
    [BaseAFHTTPManager postRequestOperationForHost:MSGCENTERHOST forParam:@"reportRegIdAndToken" forParameters:paramDic completion:^(id responseObject) {

        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"resultCode"] intValue] == 0) {
            
            NSString *result = [resultDic objectForKey:@"message"];
            handler(result,nil);
        } else {
            handler(nil,nil);
        }
        
    } failure:^(NSString *error) {
        DDLogError(@"Error: %@", error);
    }];
}

+ (void)reportMessageArrivalCountWithMsgId:(NSString *)msgId handler:(void (^)(NSString *, NSError *))handler
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:msgId,@"msgId",
                              @"APNS",@"pushType",
                              @"1",@"count",
                              @"OPEN",@"action",nil];
    [BaseAFHTTPManager postRequestOperationForHost:MSGCENTERHOST forParam:@"reportMsgStatistic" forParameters:paramDic completion:^(id responseObject) {
        
        //handler(responseObject, nil);
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"resultCode"] intValue] == 0) {
            
            NSString *result = [resultDic objectForKey:@"message"];
            handler(result,nil);
        } else {
            handler(nil,nil);
        }

        
    } failure:^(NSString *error) {
        DDLogError(@"Error: %@", error);
    }];
}

+ (NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
{
    NSMutableArray *parameterArray = [NSMutableArray array];
    
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [TPMessageRequest percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}
@end
