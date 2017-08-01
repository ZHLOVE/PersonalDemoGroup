//
//  TPIMUser.m
//  XmppDemo
//
//  Created by yy on 7/3/15.
//  Copyright (c) 2015 yy. All rights reserved.
//

#import "TPIMUser.h"
#import "TPXmppManager.h"
#import "XMPPvCardTemp.h"
#import "TPIMErrors.h"
//#import "XMPPUserMemoryStorageObject.h"
#import "XMPPvCardTemp.h"
#import "XMPPJID.h"
#import "TPMessageRequest.h"
#import "HiTVGlobals.h"

NSString * const TPXMPPOfflineNotification = @"TPXMPPOfflineNotification";
NSString * const TPXMPPOnlineNotification = @"TPXMPPOnlineNotification";
NSString * const TPXMPPReconnectNotification = @"TPXMPPReconnectNotification";

//static NSString * const XMPP_Host = @"223.82.249.149";
//static NSString * const XMPP_Host = @"xmpp.formal.taipan.ysten.com";

//static NSString *const XMPP_HostName = @"b.yst";
//static NSString *const XMPP_HostName = @"jx.yst";

@interface TPIMUser ()

//@property (nonatomic,strong, readwrite) NSString *address;
//@property (nonatomic,strong, readwrite) NSString *avatarResourcePath;
//@property (nonatomic,strong, readwrite) NSString *avatarThumbPath;
//@property (nonatomic,strong, readwrite) NSString *birthday;
//@property (nonatomic,assign, readwrite) TPIMUserGender userGender;
//@property (nonatomic,strong, readwrite) NSString *cTime;
//
//@property (nonatomic,assign, readwrite) NSInteger star;
//@property (nonatomic,assign, readwrite) NSInteger blackList;
//@property (nonatomic,strong, readwrite) NSString *region;
//@property (nonatomic,strong, readwrite) NSString *nickname;
//@property (nonatomic,strong, readwrite) NSString *noteName;
//@property (nonatomic,strong, readwrite) NSString *noteText;
//@property (nonatomic,strong, readwrite) NSString *signature;
//@property (nonatomic,strong, readwrite) NSString *jid;
//@property (nonatomic,strong, readwrite) NSString *username;
//@property (nonatomic,strong, readwrite) NSString *password;
//@property (nonatomic,strong, readwrite) UIImage *headImage;

@end

@implementation TPIMUser

@synthesize address,avatarResourcePath,avatarThumbPath,birthday,userGender,cTime,star,blackList,region,nickname,noteName,noteText,signature,jid,username,password;

- (instancetype)initWithItemElement:(DDXMLElement *)item
{
    self = [super init];
    
    if (self) {
        
        XMPPJID *xmppjid = [XMPPJID jidWithString:[item attributeStringValueForName:@"jid"]];
        self.jid = [xmppjid bare];
        
        if (self.jid.length != 0) {
            //self.nickname = [TPIMUser getNickNameWithUsername:self.jid];
            //self.headImage = [TPIMUser getAvatarImageWithUsername:self.jid];
            //self.headImageUrl = [TPIMUser getAvatarImageUrlWithUsername:self.jid];
            [TPIMUser getUserNickNameAndAvatarImageUrlWithUsername:self.jid success:^(NSString *nick_name, NSString *imgurl) {
                self.nickname = nick_name;
                self.headImageUrl = imgurl;
            }];
        }
        
        if (self.nickname.length == 0) {
            self.nickname = [item attributeStringValueForName:@"nick"];
        }
        self.username = nickname;
        self.affiliation = [item attributeStringValueForName:@"affiliation"];
    
        
        
    }
    return self;
}

- (instancetype)initWithItemElement:(DDXMLElement *)item headImage:(UIImage *)img
{
    self = [super init];
    
    if (self) {
        
        self.nickname = [item attributeStringValueForName:@"nick"];
        XMPPJID *xmppjid = [XMPPJID jidWithString:[item attributeStringValueForName:@"jid"]];
        self.jid = [xmppjid bare];
        self.username = nickname;
        self.affiliation = [item attributeStringValueForName:@"affiliation"];
        self.headImage = img;
    }
    return self;
}

- (instancetype)initWithXMPPvCardTemp:(XMPPvCardTemp *)vCard
{
    self = [super init];
    
    if (self) {
        
        if (vCard) {
            self.nickname = [vCard elementForName:@"NICKNAME"].stringValue;
            NSXMLElement *photo = [NSXMLElement elementWithName:@"PHOTO"];
            
            NSXMLElement *binval = [photo elementForName:@"BINVAL"];
            self.headImageUrl = [binval stringValue];
        }
        
    }
    return self;
}
#pragma mark - login
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password host:(NSString *)host hostName:(NSString *)hostname hostPort:(UInt16)port resource:(NSString *)resource complecationHandler:(TPIMCompletionHandler)handler
{
    
    
    
    [[TPXmppManager defaultManager] connectWithAccount:username password:password host:host hostName:hostname hostPort:port resource:resource];
    [[TPXmppManager defaultManager] setLoginHandler:^(id responseObject, NSError *error) {
        handler(responseObject,error);
        
        if (!error) {
            [TPMessageRequest uploadDeviceTokenWithCompletion:^(NSString *responseObject, NSError *error) {
                if (error != nil) {
                    DDLogInfo(@"上传token失败");
                }
            }];
        }
        
    }];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password complecationHandler:(TPIMCompletionHandler)handler
{
    //im,yydemacbook-pro.local, 223.82.249.149,b.yst,muc.b.yst
    //[HiTVGlobals sharedInstance].xmppService
    //@"xmpp.formal.taipan.ysten.com"/XMPPHOST
    NSString *jid = username;
    NSArray *xmpphostarray = [jid componentsSeparatedByString:@"@"];
    NSString *xmpphostname;
    if (xmpphostarray.count > 1) {
        xmpphostname = [xmpphostarray lastObject];
    }
    
    //XMPPHOST
    NSString *xmpphost = XMPPHOST;
    if (xmpphost.length > 0 && [xmpphost rangeOfString:@"http://"].location != NSNotFound) {
        xmpphost = [xmpphost stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    }
    [HiTVGlobals sharedInstance].isXmppConflicted = NO;
    [[TPXmppManager defaultManager] connectWithAccount:username password:password host:xmpphost hostName:xmpphostname hostPort:5222 resource:[NSString stringWithFormat:@"%@_phone",BIMS_DOMAIN]];
    [[TPXmppManager defaultManager] setLoginHandler:^(id responseObject, NSError *error) {
        handler(responseObject,error);
        if (!error) {
            
             [TPMessageRequest uploadDeviceTokenWithCompletion:^(NSString *responseObject, NSError *error) {
             if (error != nil) {
             DDLogInfo(@"上传token失败");
             }
             }];
            
        }
    }];
}

#pragma mark - register
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password host:(NSString *)host hostName:(NSString *)hostname hostPort:(UInt16)port resource:(NSString *)resource complecationHandler:(TPIMCompletionHandler)handler
{
    [[TPXmppManager defaultManager] registerWithAccount:username password:password host:host hostName:hostname hostPort:port resource:nil];
    [[TPXmppManager defaultManager] setRegisterHandler:^(id responseObject, NSError *error){
        handler(responseObject, error);
    }];

}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password complecationHandler:(TPIMCompletionHandler)handler
{
    [[TPXmppManager defaultManager] registerWithAccount:username password:password host:XMPPHOST hostName:[TPIMUser xmppHostName] hostPort:5222 resource:nil];
    [[TPXmppManager defaultManager] setRegisterHandler:^(id responseObject, NSError *error){
        handler(responseObject, error);
    }];
}

#pragma mark - logout
+ (void)logoutWithCompletionHandler:(TPIMCompletionHandler)handler
{
    [[TPXmppManager defaultManager] disconnect];
    [[TPXmppManager defaultManager] setLogoutHandler:^(id responseObject, NSError *error){
        handler(responseObject,error);
        if (!error) {
            
            
             [TPMessageRequest removeDeviceTokenWithCompletion:^(NSString *responseObject, NSError *error) {
                 if (error != nil) {
                     DDLogInfo(@"上传token失败");
                 }
             }];
            
            
        }
    }];
}

#pragma mark - user info
+ (void)getUserInfoWithUsername:(NSString *)username completionHandler:(TPIMCompletionHandler)handler
{
    XMPPvCardTemp *vcardTemp = [[TPXmppManager defaultManager] getUservCardTempWithUsername:username];
    if (vcardTemp != nil) {
        TPIMUser *user = [[TPIMUser alloc] init];
        user->username = [vcardTemp.jid user];
        
        
    }
    else{
        NSString *description = @"get user info failure";
        NSDictionary *dic = @{NSLocalizedDescriptionKey:description};
        NSError *error = [NSError errorWithDomain:TPIMErrorDomain code:kTPErrorGetUserinfoFailure userInfo:dic];
        handler(nil,error);
    }
}

+ (TPIMUser *)getMyInfo
{
    XMPPvCardTemp *vcardTemp = [[TPXmppManager defaultManager] getMyvCardTemp];
    if (vcardTemp != nil) {
        TPIMUser *user = [[TPIMUser alloc] init];
        user.username = [vcardTemp.jid user];
        
        return user;
    }
    else{
        return nil;
    }
}

+ (void)getOriginAvatarImage:(TPIMUser *)userInfo completionHandler:(TPIMCompletionHandler)handler
{

}

+ (void)updateMyInfoWithParameter:(id)parameter withType:(TPIMUpdateUserInfoType)type completionHandler:(TPIMCompletionHandler)handler
{
    if (parameter == nil) {
        return;
    }
    
    XMPPvCardTemp *vcardTemp = [[TPXmppManager defaultManager] getMyvCardTemp];
    if (vcardTemp == nil) {
        
    }
    else{
        
    }
    switch (type) {
        case kTPIMNickname:
            break;
        case kTPIMBirthday:
            break;
        case kTPIMSignature:
            break;
        case kTPIMGender:
            break;
        case kTPIMRegion:
            break;
        case kTPIMAvatar:
            break;
    }
}


+ (void)updatePasswordWithNewPassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword completionHandler:(TPIMCompletionHandler)handler
{

}

+ (UIImage *)getAvatarImageWithUsername:(NSString *)username
{
    return [[TPXmppManager defaultManager] getAvatarImageWithUsername:username];
}

+ (NSString *)getAvatarImageUrlWithUsername:(NSString *)username
{
    return [[TPXmppManager defaultManager] getAvatarImageUrlWithUsername:username];
}

- (void)getAvatarWithCompletionHandler:(TPIMCompletionHandler)handler
{
    [[TPXmppManager defaultManager] getAvatarWithUsername:self.jid];
    [[TPXmppManager defaultManager] setVcardHandler:^(id responseObject, NSError *error){
        handler(responseObject, error);
    }];
}

+ (NSString *)getNickNameWithUsername:(NSString *)username
{
    return [[TPXmppManager defaultManager] getNickNameWithUsername:username];
}

+ (void)getUserNickNameAndAvatarImageUrlWithUsername:(NSString *)username success:(void (^)(NSString *, NSString *))response
{
    TPIMUser *user = [[TPXmppManager defaultManager] getUserInfoWithUsername:username];
    response(user.nickname, user.headImageUrl);
}

+ (NSString *)jidString:(NSString *)uid
{
    NSString *xmpphost = [TPIMUser xmppHostName];

    NSString *jidString = [NSString stringWithFormat:@"p%@@%@",uid,xmpphost];
    return jidString;
}

+ (NSString *)xmppHostName
{
    NSString *jid = [HiTVGlobals sharedInstance].xmppUserId.description;
    NSArray *xmpphostarray = [jid componentsSeparatedByString:@"@"];
    NSString *xmpphost;
    if (xmpphostarray.count > 1) {
        xmpphost = [xmpphostarray lastObject];
    }
    return xmpphost;
}
@end
