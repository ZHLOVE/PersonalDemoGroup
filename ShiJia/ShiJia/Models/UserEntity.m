//
//  UserEntity.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/27.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity
MJCodingImplementation
+ (NSDictionary *)modelCustomPropertyMapper
{
    
    return @{
                 @"faceImg" : @"faceImg",
                 @"jid" : @"jid",
                 @"name" : @"name",
                 @"nickName" : @"nickName",
                 @"phoneNo" : @"phoneNo",
                 @"uid" : @"uid",
                 @"userAuth" : @"userAuth",
                 @"xmppCode" : @"xmppCode",
                 @"authorType" : @"authorType",
                 @"friendAuthorType" : @"friendAuthorType"

             };
}
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.faceImg = [dict objectForKey:@"faceImg"];
        if ([self.faceImg isKindOfClass:[NSNull class]]) {
            self.faceImg = @"";
        }
        self.jid = [dict objectForKey:@"jid"];
        self.name = [dict objectForKey:@"name"];
        self.nickName = [dict objectForKey:@"nickName"];
        if ([self.nickName isKindOfClass:[NSNull class]]) {
            self.nickName = @"";
        }
        self.phoneNo = [dict objectForKey:@"phoneNo"];
        if ([self.phoneNo isKindOfClass:[NSNull class]]) {
            self.phoneNo = @"";
        }
        self.uid = [dict objectForKey:@"uid"];
        self.userAuth = [dict objectForKey:@"userAuth"];
        self.xmppCode = [dict objectForKey:@"xmppCode"];
        self.authorType = [dict objectForKey:@"authorType"];
        self.friendAuthorType = [dict objectForKey:@"friendAuthorType"];
        
        self.type = [dict objectForKey:@"type"];
        self.userId = [dict objectForKey:@"userId"];
        
    }
    
    return self;
    
}


@end
