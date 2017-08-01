//
//  DataProvider.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "DataProvider.h"
#import "AFXMLDictionaryRequestSerializer.h"
#import "AFXMLDictionaryResponseSerializer.h"

@implementation DataProvider

- (NSString*)p_getURLWithParameters:(NSString*)param forHost:(NSString*)host{
    return [[NSString stringWithFormat:@"%@%@", host, param] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (AFHTTPRequestOperation*)requestXMLWithParameter:(NSString*)param
                                           forHost:(NSString*)host
                                        completion:(void (^)(id responseObject))success
                                           failure:(void (^)(NSString *error))failure{
    NSURL *URL = [NSURL URLWithString:[self p_getURLWithParameters:param forHost:host]];
//    DDLogInfo(@"XML URL: %@", URL);
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLDictionaryResponseSerializer serializer];
    NSMutableSet *set = [NSMutableSet setWithSet:operation.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    operation.responseSerializer.acceptableContentTypes = set;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
    }];
    
    [operation start];
    return operation;
}

- (AFHTTPRequestOperation*)requestJsonWithParameter:(NSString*)param
                                            forHost:(NSString*)host
                                         completion:(void (^)(id responseObject))success
                                            failure:(void (^)(NSString *error))failure{
    NSString* url = [self p_getURLWithParameters:param forHost:host];
    NSURL *URL = [NSURL URLWithString:url];
    DDLogInfo(@"JSON URL: %@", URL);
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *set = [NSMutableSet setWithSet:operation.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    operation.responseSerializer.acceptableContentTypes = set;
    
    if ([url containsString:@"https"]) {
        AFSecurityPolicy* policy = [AFSecurityPolicy defaultPolicy];
        [policy setValidatesDomainName:NO];
        [policy setAllowInvalidCertificates:YES];
        operation.securityPolicy = policy;
    }
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
    }];
    
    [operation start];
    return operation;
}
@end
