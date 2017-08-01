//
//  MsProtocol.m
//  HiTV
//
//  Created by 蒋海量 on 15/8/5.

//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "MsProtocol.h"
#import "BaseAFHTTPManager.h"


@implementation MsProtocol
+(void)creatRelationRequest:(NSDictionary *)parameters
                            completion:(void (^)(id responseObject))success
                               failure:(void (^)(NSString *error))failure;{
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/ms_is_together" forParameters:parameters  completion:^(id responseObject) {
        success(responseObject);
    }failure:^(NSString *error) {
        failure(error);
    }];
}

+(void)removeRelationRequest:(NSDictionary *)parameters
                  completion:(void (^)(id responseObject))success
                     failure:(void (^)(NSString *error))failure{
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/ms_remove_relation" forParameters:parameters  completion:^(id responseObject) {
        success(responseObject);
    }failure:^(NSString *error) {
        failure(error);
    }];
}
+(void)removeFamilyRelationRequest:(NSDictionary *)parameters
                  completion:(void (^)(id responseObject))success
                     failure:(void (^)(NSString *error))failure{
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/removeFamilyRelation" forParameters:parameters  completion:^(id responseObject) {
        success(responseObject);
    }failure:^(NSString *error) {
        failure(error);
    }];
}
+(void)getTVListRequest:(NSDictionary *)parameters
             completion:(void (^)(id responseObject))success
                failure:(void (^)(NSString *error))failure{
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/ms_get_tvList" forParameters:parameters  completion:^(id responseObject) {
        success(responseObject);
    }failure:^(NSString *error) {
        failure(error);
    }];
}

+(void)getScreenListRequest:(NSDictionary *)parameters
                completion:(void (^)(id responseObject))success
                   failure:(void (^)(NSString *error))failure{
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/ms_phone_screenProjection" forParameters:parameters  completion:^(id responseObject) {
        success(responseObject);
    }failure:^(NSString *error) {
        failure(error);
    }];
}

+(void)uploadScreenFileRequest:(NSDictionary *)parameters
                          data:(NSData *)data
                    sourceType:(SouceType)type
                 completion:(void (^)(id responseObject))success
                       failure:(void (^)(NSString *error))failure{
    NSString *mimetype = @"";
    NSString *filename = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    switch (type) {
        case Photo:
            mimetype = @"image/png";
            filename = date;
            break;
        case Video:
            mimetype = @"video/mpeg";
            filename = [NSString stringWithFormat:@"%@.mov",date];
            break;
        case Audio:
            mimetype = @"audio/mpeg";
            filename = [NSString stringWithFormat:@"%@.mp3",date];
            break;
            
        default:
            break;
    }
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/ms_selfFile_upload" forParameters:parameters data:data filename:filename mimetype:mimetype completion:success failure:failure];
}
+(void)getDistrustTvsRequest:(NSDictionary *)parameters
                 completion:(void (^)(id responseObject))success
                    failure:(void (^)(NSString *error))failure{
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/getDistrustTvs" forParameters:parameters  completion:^(id responseObject) {
        success(responseObject);
    }failure:^(NSString *error) {
        failure(error);
    }];
}
+(void)getRoomNumsRequest:(NSDictionary *)parameters
                  completion:(void (^)(id responseObject))success
                     failure:(void (^)(NSString *error))failure{
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/queryRoomNums" forParameters:parameters  completion:^(id responseObject) {
        success(responseObject);
    }failure:^(NSString *error) {
        failure(error);
    }];
}
+(void)confirmTvNet:(NSDictionary *)parameters
               completion:(void (^)(id responseObject))success
                  failure:(void (^)(NSString *error))failure{
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/confirmTvNet" forParameters:parameters  completion:^(id responseObject) {
        success(responseObject);
    }failure:^(NSString *error) {
        failure(error);
    }];
}
@end
