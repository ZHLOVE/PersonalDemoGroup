//
//  UserAccount.m
//  Weibo
//
//  Created by qiang on 4/28/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "UserAccount.h"
#import "NetworkTools.h"
#import "NSString+Path.h"

static UserAccount *instance = nil;

@implementation UserAccount

+ (UserAccount *)sharedUserAccount
{
    if(instance == nil)
    {
        // 先去读取保存的信息
        [self loadUserAccount];
    }
    
    if(instance == nil) // 之前没有登陆过，也可能是登录已过期
    {
        instance = [[UserAccount alloc] init];
    }
    
    return instance;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

// 打印对象信息
- (NSString *)description
{
    return  [NSString stringWithFormat:@"access_token:%@,expires_in:%i,uid:%@",self.access_token,self.expires_in,self.uid];
    
}

// 请求获取用户信息
- (void)requstUserInfo
{
    //1. 路径: oauth2/access_token
    NSString *path = @"2/users/show.json";
    //2. 参数
    NSDictionary *dict = @{@"access_token":self.access_token,@"uid":self.uid};
    
    //3. 发送请求
    [[NetworkTools sharedNetwrokTools] GET:path parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);
        
        [self setValuesForKeysWithDictionary:dict];
        
        NSLog(@"昵称:%@ 头像地址:%@",self.screen_name,self.avatar_large);
        
        // 保存一下用户信息
        [self saveAccount];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
    
}

// 异步的
- (void)requstUserInfoSuccesBlock:(void (^)(UserAccount *account))successBlock
                        failBlock:(void (^)(NSError *error))failBlock
{
    //1. 路径: oauth2/access_token
    NSString *path = @"2/users/show.json";
    //2. 参数
    NSDictionary *dict = @{@"access_token":self.access_token,@"uid":self.uid};
    
    //3. 发送请求
    [[NetworkTools sharedNetwrokTools] GET:path parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);
        
        [self setValuesForKeysWithDictionary:dict];
        
        NSLog(@"昵称:%@ 头像地址:%@",self.screen_name,self.avatar_large);
        
        // 保存一下用户信息
        [self saveAccount];
        successBlock(self);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
        failBlock(error);
    }];
    
}

- (BOOL)isLogined
{
    if(self.access_token.length>0)
    {
        return YES;
    }
    return NO;
}
#pragma mark - 归档功能
#define kUserAccount_AccessToken @"access_token"
#define kUserAccount_ExpiresIn  @"expires_in"
#define kUserAccount_UID        @"uid"
#define kUserAccount_ExpiresDate  @"expires_date"
#define kUserAccount_ScreenName @"screen_name"   // 昵称
#define kUserAccount_AvatarLage @"avatar_large"  // 用户头像地址

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:kUserAccount_AccessToken];
//    [aCoder encodeInt:self.expires_in forKey:kUserAccount_ExpiresIn];
    [aCoder encodeObject:self.uid forKey:kUserAccount_UID];
    [aCoder encodeObject:self.expires_Date forKey:kUserAccount_ExpiresDate];
    [aCoder encodeObject:self.screen_name forKey:kUserAccount_ScreenName];
    [aCoder encodeObject:self.avatar_large forKey:kUserAccount_AvatarLage];
}

// 解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.access_token = [aDecoder decodeObjectForKey:kUserAccount_AccessToken];
//        self.expires_in = [aDecoder decodeIntForKey:kUserAccount_ExpiresIn];
        self.uid = [aDecoder decodeObjectForKey:kUserAccount_UID];
        self.expires_Date = [aDecoder decodeObjectForKey:kUserAccount_ExpiresDate];
        self.screen_name = [aDecoder decodeObjectForKey:kUserAccount_ScreenName];
        self.avatar_large = [aDecoder decodeObjectForKey:kUserAccount_AvatarLage];
    }
    return self;
}

#pragma mark - 保存和读取
// 从保存的plist中读取出账号信息
+ (void)loadUserAccount
{
    UserAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[@"account.plist" docPath]];
    if(account != nil)
    {
        // 判断是否已过期
        if([account.expires_Date timeIntervalSinceNow] > 0)// 还没有过期
        {
            instance = account;
        }
    }
}

// 保存当前账号保存下来
- (void)saveAccount
{
    [NSKeyedArchiver archiveRootObject:self toFile:[@"account.plist" docPath]];
}

@end
