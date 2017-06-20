//
//  UserAccount.m
//  WeiBo
//
//  Created by student on 16/4/28.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "UserAccount.h"

#import "NetWorkTools.h"
#import "NSString+Path.h"
static UserAccount *instance = nil;
@implementation UserAccount

+ (UserAccount *)sharedUserAccount{
    if (instance == nil) {
//        instance = [[UserAccount alloc]init];
        //一开始为空，先去读取归档
        [self loadUserAccount];
    }
    
    if (instance == nil) {
        instance = [[UserAccount alloc]init];

    }
    
    return instance;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)description{
    return [NSString stringWithFormat:@"access_token:%@,expires_in:%i,uid:%@",self.access_token,self.expires_in,self.uid];
}

//请求获取用户信息
- (void)loadUserInfo{
    //1. 路径: oauth2/access_token
    NSString *path = @"2/users/show.json";
    //2. 参数
    NSDictionary *dict = @{@"access_token":self.access_token,@"uid":self.uid};
    
    //3. 发送请求
    [[NetWorkTools sharedNetWorkTools] GET:path parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);
        
        [self setValuesForKeysWithDictionary:dict];
        
        NSLog(@"昵称:%@ 头像地址:%@",self.screen_name,self.avatar_large);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];

}

- (BOOL)isLogined{
    if (self.access_token.length>0) {
        return YES;
    }
    return NO;
}

#pragma mark 支持归档
#define kUserAccount_AccessToken @"access_token"
#define kUserAccount_Expires_in @"expires_in"
#define kUserAccount_Uid @"uid"

#define kUserAccount_Screen_name @"screen_name"
#define kUserAccount_Avatar_large @"avatar_large"
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.access_token forKey:kUserAccount_AccessToken];
    [aCoder encodeInt:self.expires_in forKey:kUserAccount_Expires_in];
    [aCoder encodeObject:self.uid forKey:kUserAccount_Uid];
    [aCoder encodeObject:self.screen_name forKey:kUserAccount_Screen_name];
    [aCoder encodeObject:self.avatar_large forKey:kUserAccount_Avatar_large];
}

#pragma mark 支持解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.access_token = [aDecoder decodeObjectForKey:kUserAccount_AccessToken];
        self.expires_in = [aDecoder decodeIntForKey:kUserAccount_Expires_in];
        self.uid = [aDecoder decodeObjectForKey:kUserAccount_Uid];
        self.screen_name = [aDecoder decodeObjectForKey:kUserAccount_Screen_name];
        self.avatar_large = [aDecoder decodeObjectForKey:kUserAccount_Avatar_large];
    }
    return self;
}

//+ (NSString *)filePath{
//    NSArray *myPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *myDocPath = myPath[0];
//    NSString *filePath = [myDocPath stringByAppendingPathComponent:@"account.plist"];
//    return filePath;
//}

//从保存的plist中读取账号信息
+ (void)loadUserAccount{
    UserAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[@"account.plist" docPath]];
    if (account !=nil) {
        //判断是否过期
        if ([account.expires_Date timeIntervalSinceNow]>0) {
            instance = account;
        }
    }
}



- (void)saveAccount{
    [NSKeyedArchiver archiveRootObject:self toFile:[@"account.plist" docPath]];
}

















@end
