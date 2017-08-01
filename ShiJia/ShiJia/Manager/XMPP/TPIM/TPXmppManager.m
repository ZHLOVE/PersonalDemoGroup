
//
//  TPXmppManager.m
//
//
//  Created by yy on 7/2/15.
//  Copyright (c) 2015 yy. All rights reserved.
//

#import "TPXmppManager.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPCapabilities.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPRoom.h"
#import "XMPPRoomMemoryStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPMUC.h"
#import "NSString+Conversion.h"
#import "XMPPModule.h"
#import "XMPPRoomCoreDataStorage.h"
#import "XMPPIDTracker.h"
#import "NSData+XMPP.h"

#import "TPIMConstants.h"
#import "TPIMErrors.h"
#import "TPIMGroup.h"
#import "TPIMConversation.h"
#import "TPIMMessage.h"
#import "TPIMAlertView.h"
#import "TPIMUser.h"
#import "TPIMMinAlertView.h"
#import "BIMSManager.h"
#import "TPIMContentModel.h"
#import "TogetherManager.h"
#import "TPIMNodeModel.h"
#import "TPXmppRoomManager.h"

#define JIDString(name,hostName) [NSString stringWithFormat:@"%@@%@",name,hostName]

static NSString * const TPXmppUserAccountKey  = @"TPXmppUserAccountKey";
static NSString * const TPXmppUserPasswordKey = @"TPXmppUserPasswordKey";
static NSString * const TPXmppHostNameKey     = @"TPXmppHostNameKey";
static NSString * const TPXmppResourceKey     = @"TPXmppResourceKey";
static NSString * const TPXmppMUCDomain       = @"muc";


@interface TPXmppManager ()<XMPPStreamDelegate,XMPPRosterDelegate,XMPPRosterMemoryStorageDelegate,XMPPRoomDelegate,XMPPMUCDelegate,XMPPvCardTempModuleDelegate>

@property (nonatomic, strong, readwrite) XMPPStream               *xmppStream;

@property (nonatomic, strong) XMPPReconnect                       *xmppReconnect;

@property (nonatomic, strong) XMPPRosterCoreDataStorage           *xmppRosterStorage;
@property (nonatomic, strong) XMPPRosterMemoryStorage             *xmppRosterMemoryStorage;
@property (nonatomic, strong) XMPPRoster                          *xmppRoster;

@property (nonatomic, strong) XMPPvCardCoreDataStorage            *xmppvCardStorage;
@property (nonatomic, strong) XMPPvCardTempModule                 *xmppvCardTempModule;
@property (nonatomic, strong) XMPPvCardAvatarModule               *xmppvCardAvatarModule;
@property (nonatomic, strong) XMPPvCardTemp                       *myvCardTemp;//登录用户的个人资料


@property (nonatomic, strong) XMPPCapabilitiesCoreDataStorage     *xmppCapabilitiesStorage;
@property (nonatomic, strong) XMPPCapabilities                    *xmppCapabilities;

@property (nonatomic, strong) XMPPMessageArchiving                *xmppMessageArchiving;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic, strong) XMPPRoom                            *xmppPublicRoom;
@property (nonatomic, strong) XMPPRoom                            *xmppPrivateRoom;
@property (nonatomic, strong) XMPPRoomMemoryStorage               *privateXmppRoomMemoryStorage;
@property (nonatomic, strong) XMPPRoomCoreDataStorage             *privateXmppRoomCoreDataStorage;

@property (nonatomic, strong) XMPPRoomMemoryStorage               *publicXmppRoomMemoryStorage;
@property (nonatomic, strong) XMPPRoomCoreDataStorage             *publicXmppRoomCoreDataStorage;

@property (nonatomic, strong) XMPPMUC                             *xmppMUC;

@property (nonatomic, strong) XMPPModule                          *xmppModule;

@property (nonatomic, strong) XMPPIDTracker                       *responseTracker;

@property (nonatomic, assign) BOOL                                goToRegisterAfterConnected;

@property (nonatomic, assign) BOOL                                logoutActively;//主动登出标志位

@end

@implementation TPXmppManager
{
    NSString *userAccount;
    NSString *userPassword;
    NSString *userHostName;
    NSString *userResource;
    NSString *userHost;
    UInt16 userHostPort;
    NSInteger sendMessageCount;
    BOOL isInvited;
    
}

#pragma mark - init
+ (TPXmppManager *)defaultManager
{
    static TPXmppManager *instance = nil;
    static dispatch_once_t precidate;
    dispatch_once(&precidate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupStream];
    }
    return self;
}

- (void)dealloc
{
    [self teardownStream];
}

#pragma mark -  setup stream
- (void)setupStream
{
    //setup stream
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream setKeepAliveInterval:170]; //心跳包时间
    //setup reconnect（重连）
    self.xmppReconnect = [[XMPPReconnect alloc] init];
    
    //setup roster（花名册）
    //    self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    self.xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterMemoryStorage];
    self.xmppRoster.autoFetchRoster = NO;
    self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    //setup card storage（用户资料）
    self.xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    self.xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.xmppvCardStorage];
    self.xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.xmppvCardTempModule];
    
    //setup capabilities
    self.xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    self.xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:self.xmppCapabilitiesStorage];
    self.xmppCapabilities.autoFetchHashedCapabilities = YES;
    self.xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // Setup message archiving（消息）
    self.xmppMessageArchivingCoreDataStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    self.xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.xmppMessageArchivingCoreDataStorage];
    [self.xmppMessageArchiving setClientSideMessageArchivingOnly:YES];
    [self.xmppMessageArchiving activate:self.xmppStream];
    [self.xmppMessageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //setup xmpproom
    self.privateXmppRoomMemoryStorage = [[XMPPRoomMemoryStorage alloc] init];
    self.privateXmppRoomCoreDataStorage = [XMPPRoomCoreDataStorage sharedInstance];
    
    self.publicXmppRoomMemoryStorage = [[XMPPRoomMemoryStorage alloc] init];
    self.publicXmppRoomCoreDataStorage = [XMPPRoomCoreDataStorage sharedInstance];
    
    self.xmppModule = [[XMPPModule alloc] init];
    [self.xmppModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppModule activate:self.xmppStream];
    
    //activate xmmpp modules
    [self.xmppReconnect          activate:self.xmppStream];
    [self.xmppRoster             activate:self.xmppStream];
    [self.xmppvCardTempModule    activate:self.xmppStream];
    [self.xmppvCardAvatarModule  activate:self.xmppStream];
    [self.xmppCapabilities       activate:self.xmppStream];
    
    //add ourself as a delegate to anything we may be interested in
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (void)teardownStream
{
    [_xmppStream removeDelegate:self];
    [_xmppRoster removeDelegate:self];
    [_xmppMessageArchiving removeDelegate:self];
    [_xmppModule removeDelegate:self];
    
    [_xmppReconnect         deactivate];
    [_xmppRoster            deactivate];
    [_xmppvCardTempModule   deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppCapabilities      deactivate];
    [_xmppMessageArchiving  deactivate];
    [_xmppModule deactivate];
    
    [_xmppStream disconnect];
    
    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppRoster = nil;
    _xmppRosterStorage = nil;
    _xmppvCardStorage = nil;
    _xmppvCardTempModule = nil;
    _xmppvCardAvatarModule = nil;
    _xmppCapabilities = nil;
    _xmppCapabilitiesStorage = nil;
    _xmppMessageArchiving = nil;
    _xmppMessageArchivingCoreDataStorage = nil;
}

#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [self.xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [self.xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_messageArchiving
{
    return [self.xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
}

#pragma mark - data
- (NSError *)errorWithDescription:(NSString *)description code:(TPIMErrors)code
{
    if (description.length == 0) {
        description = @"unknown error";
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:description};
    NSError *error = [NSError errorWithDomain:TPIMErrorDomain code:code userInfo:userInfo];
    return error;
}

#pragma mark - register
- (void)registerWithAccount:(NSString *)account password:(NSString *)password host:(NSString *)host hostName:(NSString *)hostName hostPort:(UInt16)hostPort resource:(NSString *)resource
{
    //check accoun & password
    if (account.length == 0 || password.length == 0) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alert show];
        return;
    }
    
    //save account...
    userAccount = account;
    userPassword = password;
    userHostName = hostName;
    userHostPort = hostPort;
    userResource = resource;
    userHost = host;
    
    if ([self.xmppStream isDisconnected]) {
        //did not connect,connect with anonymous account
        [self connectWithAccount:@"anonymous"];
        self.goToRegisterAfterConnected = YES;
    }
    else{
        [self doRegister];
    }
}

- (void)doRegister
{
    NSError *error = nil;
    
    if ([_xmppStream isConnected] && [_xmppStream supportsInBandRegistration])
    {
        
        [_xmppStream setMyJID:[self jidWithUsername:userAccount]];
        if (![_xmppStream registerWithPassword:userPassword error:&error])
        {
            if (self.registerHandler) {
                self.registerHandler(nil,error);
            }
            
        }
    }
    else {
        NSError *error = [self errorWithDescription:@"!!!!([xmppStream isConnected] && [xmppStream supportsInBandRegistration])" code:kTPErrorRegisterFailure];
        if (self.registerHandler) {
            self.registerHandler(nil, error);
        }
        DDLogInfo(@"!!!!([xmppStream isConnected] && [xmppStream supportsInBandRegistration])");
    }
    
}

//注册成功回调
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    if (self.registerHandler) {
        self.registerHandler(nil, nil);
    }
    //    [self doLogin];
}

//注册失败回调
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    //注册失败
    DDLogError(@"注册失败");
    NSString *description = [[error elementForName:@"failure"] stringValue];
    if (description.length == 0) {
        description = @"xmpp stream registered failure";
    }
    NSError *tpError = [self errorWithDescription:description code:kTPErrorAuthenticationFailure];
    
    if (self.registerHandler) {
        self.registerHandler(nil,tpError);
    }
}


#pragma mark - connect
#pragma mark connect operation
- (void)connectWithAccount:(NSString *)account password:(NSString *)password host:(NSString *)host hostName:(NSString *)hostName hostPort:(UInt16)hostPort resource:(NSString *)resource
{
    
    if ([self.xmppStream isConnecting]) {
        //connection is currently connecting
        if ([[self.xmppStream.myJID bare] isEqualToString:account]) {
            [self updateMyInfo];
            return;
        }
    }
    
    //check accoun & password
    if (account.length == 0 || password.length == 0) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alert show];
        NSString *description = @"用户名或密码不能为空";
        NSError *tpError = [self errorWithDescription:description code:kTPErrorAuthenticationFailure];
        
        if (self.loginHandler) {
            self.loginHandler(nil,tpError);
        }
        return;
    }
    
    //save account...
    userAccount = account;
    userPassword = password;
    userHostName = hostName;
    userHostPort = hostPort;
    userResource = resource;
    userHost = host;
    
    if ([self.xmppStream isDisconnected]) {
        
        //did not connect
        [self connectWithAccount:account];
        self.goToRegisterAfterConnected = NO;
        
    }
    else{
        //did connect,authenticate password
        [self doLogin];
    }
    
}

//连接
- (void)connectWithAccount:(NSString *)account
{
    //xmppStrem set host
    if (self.xmppStream.isConnecting) {
        return;
    }
    [self.xmppStream setHostName:userHost];
    [self.xmppStream setHostPort:userHostPort];
    
    
    XMPPJID *JID = [self jidWithUsername:account];
    [self.xmppStream setMyJID:JID];
    
    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        //parameters are not correct 用户名或密码错误
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"Xmpp登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alert show];
        if (self.loginHandler) {
            self.loginHandler(nil,error);
        }
        return;
    }
    
}

//验证密码
- (void)doLogin
{
    NSError *error = nil;
    
    if (![self.xmppStream authenticateWithPassword:userPassword error:&error]) {
        if (self.loginHandler) {
            self.loginHandler(nil, error);
        }
    }
    if (!self.logoutActively) {
        //断线重连上报数据
        DDLogInfo(@"断线重连上报数据");
        [[TogetherManager sharedInstance] reconnect];
    }
}

//发送presence
- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}

#pragma mark connect delegate
//验证成功回调
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    DDLogInfo(@"授权成功");
    //验证成功,连接
    [self goOnline];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TPXMPPReconnectNotification object:nil];
    
    self.myvCardTemp = [self.xmppvCardTempModule vCardTempForJID:[sender myJID] shouldFetch:YES];
    [self updateMyInfo];
    if (self.loginHandler) {
        self.loginHandler(nil, nil);
    }
}

//验证失败回调
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    //授权失败
    DDLogError(@"授权失败");
    NSString *description = [[error elementForName:@"failure"] stringValue];
    if (description.length == 0) {
        description = @"xmpp stream authenticated failure";
    }
    NSError *tpError = [self errorWithDescription:description code:kTPErrorAuthenticationFailure];
    
    if (self.loginHandler) {
        self.loginHandler(nil,tpError);
    }
}

//连接成功回调
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    if (self.goToRegisterAfterConnected) {
        [self doRegister];
    }
    else{
        [self doLogin];
    }
    
}

//socket连接成功回调
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    
}

//连接超时回调
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSString *description = @"xmpp stream connected failure because timeout";
    NSError *tpError = [self errorWithDescription:description code:kTPErrorAuthenticationFailure];
    if (self.loginHandler) {
        self.loginHandler(nil,tpError);
    }
}

//收到下线通知
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error
{
    NSXMLNode *errorNode = (NSXMLNode *)error;
    //遍历错误节点
    for(NSXMLNode *node in [errorNode children])
    {
        //若错误节点有【冲突】
        if([[node name] isEqualToString:@"conflict"])
        {
            [HiTVGlobals sharedInstance].isXmppConflicted = YES;
            //显示大窗口
            TPIMAlertView *alert = [[TPIMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName] message:@"你被下线了" leftButtonTitle:@"退出" rightButtonTitle:@"重新登录"];
            [alert setLeftButtonClickBlock:^{
                self.logoutActively = YES;
                //退出
                [[NSNotificationCenter defaultCenter] postNotificationName:TPXMPPOfflineNotification object:nil];
                
            }];
            
            [alert setRightButtonClickBlock:^{
                //重新登录
                self.xmppReconnect.autoReconnect = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:TPXMPPOnlineNotification object:nil];
            }];
            
            [alert show];
            
        }
    }
}

#pragma mark - disconnect
- (void)disconnect
{
    self.logoutActively = YES;
    [self goOffline];
    [self.xmppStream disconnect];
    
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

//断开连接回调
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
//    [self updateMyInfo];
    if (self.logoutHandler) {
        self.logoutHandler(nil, error);
    }
    if (self.loginHandler) {
        self.loginHandler(nil,error);
    }
}

#pragma mark - user info
- (XMPPJID *)jidWithUsername:(NSString *)username
{
    XMPPJID *jid;
    if ([username rangeOfString:[NSString stringWithFormat:@"@%@",userHostName]].location != NSNotFound) {
        jid = [XMPPJID jidWithString:username resource:userResource];
    }
    else{
        jid = [XMPPJID jidWithString:JIDString(username,userHostName) resource:userResource];
    }
    return jid;
}

- (TPIMUser *)getUserInfoWithUsername:(NSString *)username
{
    TPIMUser *userModel = [[TPIMUser alloc] init];
    if ([self.xmppStream.myJID.bare rangeOfString:username].location != NSNotFound || [username rangeOfString:self.xmppStream.myJID.bare].location != NSNotFound) {
       
        userModel.nickname = [HiTVGlobals sharedInstance].nickName;
        userModel.headImageUrl = [HiTVGlobals sharedInstance].faceImg;
        
        return userModel;
    }
    
    userModel.nickname = @"";
    userModel.headImageUrl = @"";
    
    // nick name
    XMPPvCardTemp *cardtemp = [self getUservCardTempWithUsername:username];
    XMPPvCardTemp *vcard = [XMPPvCardTemp vCardTempFromElement:cardtemp];
    NSXMLElement *nameXml = [vcard elementForName:@"NICKNAME"];
    NSString *nickname = [nameXml stringValue];
    userModel.nickname = nickname;
    
    // head image url
    NSXMLElement *photo = [vcard elementForName:@"PHOTO"];
    NSXMLElement *binval = photo == nil? [vcard elementForName:@"BINVAL"] : [photo elementForName:@"BINVAL"];
    
    if (binval.stringValue != nil ) {
        
        NSXMLElement *type = photo == nil ? [vcard elementForName:@"TYPE"] : [photo elementForName:@"TYPE"];
        
        if ([type.stringValue isEqualToString:@"URL"]) {
            userModel.headImageUrl = binval.stringValue;
        }
    }
    
    return userModel;

}

- (NSString *)getNickNameWithUsername:(NSString *)username
{
    if ([self.xmppStream.myJID.bare rangeOfString:username].location != NSNotFound || [username rangeOfString:self.xmppStream.myJID.bare].location != NSNotFound) {
        return [HiTVGlobals sharedInstance].nickName;
    }
    XMPPvCardTemp *cardtemp = [self getUservCardTempWithUsername:username];
    XMPPvCardTemp *vcard = [XMPPvCardTemp vCardTempFromElement:cardtemp];
    NSXMLElement *nameXml = [vcard elementForName:@"NICKNAME"];
    NSString *nickname = [nameXml stringValue];
    return nickname;
    
}

- (UIImage *)getAvatarImageWithUsername:(NSString *)username
{
        
    if ([self.xmppStream.myJID.bare rangeOfString:username].location != NSNotFound || [username rangeOfString:self.xmppStream.myJID.bare].location != NSNotFound) {
        
        NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[HiTVGlobals sharedInstance].faceImg]];
        return [UIImage imageWithData:imagedata];
    }
    
    XMPPvCardTemp *cardtemp = [self getUservCardTempWithUsername:username];
    
    NSData *data = cardtemp.photo;
    UIImage *image = [UIImage imageWithData:data];
    //    UIImage *defaultImage = [UIImage imageNamed:@"默认头像"];
    UIImage *defaultImage = nil;
    
    if (image == nil ) {
        if (cardtemp != nil) {
            XMPPvCardTemp *vcard = [XMPPvCardTemp vCardTempFromElement:cardtemp];
            NSXMLElement *photo = [vcard elementForName:@"PHOTO"];
            NSXMLElement *binval = photo == nil? [vcard elementForName:@"BINVAL"] : [photo elementForName:@"BINVAL"];
            
            if (binval.stringValue != nil ) {
                
                NSXMLElement *type = photo == nil ? [vcard elementForName:@"TYPE"] : [photo elementForName:@"TYPE"];
                
                if ([type.stringValue isEqualToString:@"URL"]) {
                    
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:binval.stringValue]];
                    image = [UIImage imageWithData:data];
                    
                    if (image != nil) {
                        return image;
                    }
                    
                }
                else{
                    data = [self.xmppvCardAvatarModule photoDataForJID:[self jidWithUsername:username]];
                    image = [UIImage imageWithData:data];
                    if (image != nil) {
                        return image;
                    }
                }
            }
            
        }
        
    }
    else{
        return image;
    }
    return defaultImage;
    
}

- (NSString *)getAvatarImageUrlWithUsername:(NSString *)username
{
    if (username.length == 0 ) {
        return nil;
    }
    
    if (self.xmppStream.myJID.bare.length == 0) {
        return nil;
    }
    
    if ([username rangeOfString:self.xmppStream.myJID.bare].location != NSNotFound || [self.xmppStream.myJID.bare rangeOfString:username].location != NSNotFound) {
        return [HiTVGlobals sharedInstance].faceImg;
    }
    
    XMPPvCardTemp *cardtemp = [self getUservCardTempWithUsername:username];
    
    XMPPvCardTemp *vcard = [XMPPvCardTemp vCardTempFromElement:cardtemp];
    NSXMLElement *photo = [vcard elementForName:@"PHOTO"];
    NSXMLElement *binval = photo == nil? [vcard elementForName:@"BINVAL"] : [photo elementForName:@"BINVAL"];
    
    if (binval.stringValue != nil ) {
        
        NSXMLElement *type = photo == nil ? [vcard elementForName:@"TYPE"] : [photo elementForName:@"TYPE"];
        
        if ([type.stringValue isEqualToString:@"URL"]) {
            return binval.stringValue;
            
            
        }
        
    }
    
    return nil;
}

- (void)getAvatarWithUsername:(NSString *)username
{
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:[self jidWithUsername:username]];
    [iq addAttributeWithName:@"from" stringValue:[self.xmppStream myJID].full];
    NSXMLElement *vCardElement = [NSXMLElement elementWithName:@"vCard"];
    [vCardElement addAttributeWithName:@"xmlns" stringValue:@"vcard-temp"];
    
    [iq addChild:vCardElement];
    [self.xmppStream sendElement:iq];
}

- (XMPPvCardTemp *)getUservCardTempWithUsername:(NSString *)username
{
    /*
     XMPPJID *jid = [self jidWithUsername:username];
     XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:jid];
     [iq addAttributeWithName:@"from" stringValue:[self.xmppStream myJID].full];
     NSXMLElement *vCard = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
     [iq addChild:vCard];
     [self.xmppStream sendElement:iq];
     */
    
    XMPPvCardTemp *cardTemp = [self.xmppvCardTempModule vCardTempForJID:[self jidWithUsername:username] shouldFetch:YES];
    return cardTemp;
}

- (XMPPvCardTemp *)getMyvCardTemp
{
    
    XMPPvCardTemp *cardTemp = [self.xmppvCardTempModule myvCardTemp];
    return cardTemp;
}

- (NSDictionary *)getMyInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[self.xmppStream.myJID bare] forKey:@"jid"];
    UIImage *img;
    if (self.xmppStream.myJID.bare.length != 0) {
        img = [self getAvatarImageWithUsername:[self.xmppStream.myJID bare]];
    }
    
    if (img != nil) {
        [dic setValue:img forKey:@"userhead"];
    }
    
    return dic;
}

- (void)updateMyInfo
{
    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
    XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
    [newvCardTemp setNickname:[HiTVGlobals sharedInstance].nickName];
    
    NSXMLElement *photo = [NSXMLElement elementWithName:@"PHOTO"];
    
    NSXMLElement *type = [NSXMLElement elementWithName:@"TYPE" stringValue:@"URL"];
    NSXMLElement *binval = [NSXMLElement elementWithName:@"BINVAL" stringValue:[HiTVGlobals sharedInstance].faceImg];
    [photo addChild:type];
    [photo addChild:binval];
    [newvCardTemp addChild:photo];
    
    [self.xmppvCardTempModule updateMyvCardTemp:newvCardTemp];
    
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(DDXMLElement *)error
{
    DDLogInfo(@"\nxmpp更新头像失败\n");
    [self updateMyInfo];
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    TPIMUser *user = [self getUserInfoWithUsername:self.xmppStream.myJID.bare];
    DDLogInfo(@"\nxmpp更新个人信息成功\n:%@,%@",user.nickname,user.headImageUrl);
}

#pragma mark - message
#pragma mark message operation
- (void)getMessageList
{
    NSManagedObjectContext *context = [self.xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSError *error;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSArray *messages = [context executeFetchRequest:request error:&error];
    
    for (XMPPMessageArchiving_Message_CoreDataObject *object in messages) {
        NSMutableString *showString = [[NSMutableString alloc] init];
        if (object.body) {
            [showString appendFormat:@"%@\n",object.body];
        }
        if (object.isOutgoing) {
            [showString appendFormat:@"to: "];
        }else{
            [showString appendFormat:@"from: "];
        }
        if (object.bareJidStr) {
            [showString appendFormat:@"%@\n",object.bareJidStr];
        }
        if (object.timestamp) {
            
            [showString appendFormat:@"%@",[formatter stringFromDate:object.timestamp]];
        }
        DDLogInfo(@"message: %@\n",showString);
    }
    DDLogInfo(@"message.count:%zd",messages.count);
    
    
    NSEntityDescription *contactEntityDes = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:context];
    NSFetchRequest *contactRequest = [[NSFetchRequest alloc] init];
    [contactRequest setEntity:contactEntityDes];
    
    NSError *contactError;
    NSArray *contacts = [context executeFetchRequest:contactRequest error:&contactError];
    for (XMPPMessageArchiving_Contact_CoreDataObject *object in contacts) {
        DDLogInfo(@"%@,%@,%@,%@,%@,%@",object.bareJid,object.bareJidStr,object.mostRecentMessageTimestamp,object.mostRecentMessageBody,object.mostRecentMessageOutgoing,object.streamBareJidStr);
    }
    DDLogInfo(@"contacts.count:%zd",contacts.count);
    
}

- (NSArray *)getConversationList
{
    NSManagedObjectContext *context = [self.xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    
    //获取聊天记录中的联系人
    NSEntityDescription *contactEntityDes = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:context];
    NSFetchRequest *contactRequest = [[NSFetchRequest alloc] init];
    [contactRequest setEntity:contactEntityDes];
    NSError *contactError;
    NSArray *contacts = [context executeFetchRequest:contactRequest error:&contactError];
    DDLogInfo(@"contacts.count:%zd",contacts.count);
    
    //获取所有的消息列表
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *messages = [context executeFetchRequest:request error:&error];
    return messages;
    
}

- (void)getMessageListOfUser:(NSString *)user completion:(void(^)(NSArray* result,NSError *error))completion
{
    
    NSManagedObjectContext *context = [self.xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    if (user.length != 0) {
        // 过滤内容，只找我与正要聊天的好友的聊天记录
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(bareJidStr like %@) ", user];
        request.predicate = predicate;
    }
    __block NSError *error = nil;
    NSArray *results =[context executeFetchRequest:request error:&error];
    
    if (completion) {
        completion(results, error);
    }
}

- (void)sendMessage:(NSString *)message type:(NSString *)type to:(NSString *)user
{
    XMPPJID *jid;
    if ([type isEqualToString:@"chat"]) {
        jid = [self jidWithUsername:user];
    }
    else if ([type isEqualToString:@"groupchat"]){
        jid = [self roomJidWithRoomName:user];
    }
    
    XMPPMessage *messagea = [XMPPMessage messageWithType:type to: jid];
    XMPPJID *fromJid = [self.xmppStream myJID];
    [messagea addAttributeWithName:@"from" stringValue:fromJid.bare];
    [messagea addBody:message];
    [self.xmppStream sendElement:messagea];
    sendMessageCount = 1;
}

- (void)sendMessage:(XMPPMessage *)message
{
    if (message.from == nil) {
        [message addAttributeWithName:@"from" stringValue:[self.xmppStream myJID].full];
    }
    [self.xmppStream sendElement:message];
    sendMessageCount = 1;
}

- (void)sendMessage:(XMPPMessage *)message totalCount:(NSInteger)count
{
    if (message.from == nil) {
        [message addAttributeWithName:@"from" stringValue:[self.xmppStream myJID].full];
    }
    [self.xmppStream sendElement:message];
    sendMessageCount = count;
}

#pragma mark message delegate
//收到message回调
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    //DDLogInfo(@"didReceiveMessage\n%@\n",message);
    
    if ([message.type isEqualToString:@"chat"]) {
        
        //单聊
    }
    else if ([message.type isEqualToString:@"groupchat"]){
        
        if ([message.body rangeOfString:@"Room is locked"].location == NSNotFound && [message.body rangeOfString:@"Room is now unlocked"].location == NSNotFound) {
            //群聊
            
            NSString *msgBody = message.body;
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[msgBody dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
            
            if (dic != nil) {
                if ([dic.allKeys containsObject:@"video_url"]) {
                    
                    NSString *url = [dic valueForKey:@"video_url"];
                    
                    if (url.length == 0) {
                        
                        //文字消息
                        TPIMContentMessage *msg = [[TPIMContentMessage alloc] initWithXMPPMessage:message];
                        if (msg != nil) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage object:self userInfo:@{TPIMNotification_MessageKey:msg}];
                        }
                        
                    }
                    else{
                        
                        //语音消息
                        TPIMVoiceMessage *msg = [[TPIMVoiceMessage alloc] initWithXMPPMessage:message];
                        if (msg != nil) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage object:self userInfo:@{TPIMNotification_MessageKey:msg}];
                        }
                    }
                    
                }
                else{
                    
                    //文字消息
                    TPIMContentMessage *msg = [[TPIMContentMessage alloc] initWithXMPPMessage:message];
                    if (msg != nil) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage object:self userInfo:@{TPIMNotification_MessageKey:msg}];
                    }
                }
            }
            
        }
        
    }
    
    else if ([message.type isEqualToString:@"normal"]){
        
        NSXMLElement * x = [message elementForName:@"x" xmlns:XMPPMUCUserNamespace];
        NSXMLElement * decline = [x elementForName:@"decline"];
        NSXMLElement * reason = [decline elementForName:@"reason"];
        
        
        if (decline)
        {
            //[multicastDelegate xmppMUC:self roomJID:roomJID didReceiveInvitationDecline:message];
            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_GroupChange_DidDeclineInvitation object:self userInfo:@{TPIMNotification_DeclineReasonKey:reason.stringValue}];
        }
    }
    else{
        //TaiPan消息
        TPIMMessageModel *msgmodel = [[TPIMMessageModel alloc] initWithXMPPMessage:message];
        
        if (msgmodel == nil) {
            return;
        }
        if (message.subject.length != 0) {
            msgmodel.contentModel.content = message.subject;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessages object:self userInfo:nil];
        
        switch ([msgmodel.type integerValue]) {
            case 1:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type1 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 2:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type2 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 3:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type3 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 4:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type4 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 5:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type5 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 6:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type6 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 7:
            {
                if ([msgmodel.contentModel.stype isEqualToString:@"noti"]) {
                    
                    UserEntity *userEntity = [UserEntity new];
                    userEntity.uid = msgmodel.from.uid;
                    userEntity.jid = msgmodel.from.jid;
                    userEntity.nickName = msgmodel.from.nickname;

                    NSArray *arr = [NSArray arrayWithObjects:userEntity, nil];
                    [TPXmppRoomManager defaultManager].invitedUserList = [NSArray arrayWithArray:arr];
                    
                    //显示大窗口
                    NSString *title = [NSString stringWithFormat:@"你的好友%@",msgmodel.title];
                    TPIMAlertView *alert = [[TPIMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName] message:title leftButtonTitle:@"残忍拒绝" rightButtonTitle:@"一起看"];
                    
                    [alert setRightButtonClickBlock:^{
                        AppDelegate *appdelegate = [AppDelegate appDelegate];
                        [appdelegate.appdelegateService modifyMessageStateWithMsgId:msgmodel.msgId];
                       
                        
                        [TPXmppRoomManager defaultManager].stype = @"miao";
                        if ([TPXmppRoomManager defaultManager].roomMemberList.count == 0) {
                            // 创建房间并邀请好友
                            [[TPXmppRoomManager defaultManager] sendInvitationMessageAndCreateRoom];
                        }
                        else{
                            //房间已创建，仅邀请好友
                            [[TPXmppRoomManager defaultManager] sendInvitationMessageWithRoomId:[TPXmppRoomManager defaultManager].roomId];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_FollowJoinRoom object:self];
                    }];
                    
                    [alert setLeftButtonClickBlock:^{
                        //消息设置已读
                        AppDelegate *appdelegate = [AppDelegate appDelegate];
                        [appdelegate.appdelegateService modifyMessageStateWithMsgId:msgmodel.msgId];
                        
                    }];
                    [alert show];
                }
                else if ([msgmodel.contentModel.stype isEqualToString:@"miao"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_FollowFriends object:self];

                    isInvited = YES;
                    
                    //直接进入聊天室邀请
                    [self acceptInvitation:msgmodel];
                }
                else{
                    //显示大窗口
                    TPIMAlertView *alert = [[TPIMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName] message:msgmodel.title leftButtonTitle:@"残忍拒绝" rightButtonTitle:@"马上就约"];
                    
                    [alert setRightButtonClickBlock:^{
                        
                        isInvited = YES;
                        
                        //接受聊天室邀请
                        [self acceptInvitation:msgmodel];
                        AppDelegate *appdelegate = [AppDelegate appDelegate];
                        [appdelegate.appdelegateService modifyMessageStateWithMsgId:msgmodel.msgId];
                        
                        
                    }];
                    
                    [alert setLeftButtonClickBlock:^{
                        
                        //消息设置已读
                        AppDelegate *appdelegate = [AppDelegate appDelegate];
                        [appdelegate.appdelegateService modifyMessageStateWithMsgId:msgmodel.msgId];
                        
                        /*
                         <message
                         from='hecate@shakespeare.lit/broom'
                         to='darkcave@chat.shakespeare.lit'>
                         <x xmlns='http://jabber.org/protocol/muc#user'>
                         <decline to='crone1@shakespeare.lit'>
                         <reason>
                         Sorry, I'm too busy right now.
                         </reason>
                         </decline>
                         </x>
                         </message>
                         
                         //拒绝邀请
                         XMPPJID *roomjid = [self roomJidWithRoomName:msgmodel.contentModel.roomId];
                         XMPPJID *fromroomjid = [XMPPJID jidWithString:roomjid.bare resource:[HiTVGlobals sharedInstance].nickName];
                         XMPPJID *tojid = [XMPPJID jidWithString:msgmodel.from.jid];
                         
                         XMPPMessage *message = [XMPPMessage messageWithType:@"normal" to:tojid];
                         [message addAttributeWithName:@"from" stringValue:fromroomjid.full];
                         
                         NSXMLElement *x = [[NSXMLElement alloc] initWithName:@"x" xmlns:XMPPMUCUserNamespace];
                         
                         NSXMLElement *decline = [[NSXMLElement alloc] initWithName:@"decline"];
                         [decline addAttributeWithName:@"to" stringValue:msgmodel.from.jid];
                         
                         NSXMLElement *reason = [[NSXMLElement alloc] initWithName:@"reason" stringValue:[NSString stringWithFormat:@"%@暂时拒绝了您的请求",[HiTVGlobals sharedInstance].nickName]];
                         
                         [decline addChild:reason];
                         [x addChild:decline];
                         [message addChild:x];
                         
                         [self.xmppStream sendElement:message];
                         */
                        
                    }];
                    [alert show];
                }
                
            }
                
                break;
            case 8:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type8 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 9:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type9 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 10:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type10 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 11:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type11 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 12:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type12 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 26:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type26 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            case 21:
                [HiTVGlobals sharedInstance].getTvType = @"notified";
                [[TogetherManager sharedInstance]setRemoteStatus];
                [[BIMSManager sharedInstance]updateUserInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_NOTI21 object:nil];

                break;
            case 22:
                [[TogetherManager sharedInstance]getDistrustTvsMethod];
                break;
            case 28:
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessage_Type28 object:self userInfo:@{TPIMNotification_MessageKey:msgmodel}];
                break;
            default:
                break;
        }
    }
    
}

//发送message回调
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    //DDLogInfo(@"\ndidSendMessage\n");
    /*
     <message type="chat" to="bbb@im" from="aaa@im"><body>hello,bbb</body></message>
     */
    if ([message.type isEqualToString:@"chat"]) {
        if (self.messageHandler) {
            self.messageHandler(nil,nil);
        }
    }
    else if ([message.type isEqualToString:@"groupchat"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_SendMessageResult object:self userInfo:@{TPIMNotification_MessageKey:message}];
    }
    else if ([message.type isEqualToString:@"normal"]){
        
    }
    else{
        NSXMLElement *yst = [message elementForName:@"yst"];
        if (yst != nil) {
            
            NSString *type = [yst elementForName:@"type"].stringValue;
            
            //TaiPan消息
            switch ([type integerValue]) {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                case 10:
                {
                    static int i = 1;
                    if (i == sendMessageCount) {
                        i = 1;
                        if (self.sendMessageHandler) {
                            self.sendMessageHandler(nil,nil);
                        }
                        else{
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                            TPIMMessageModel *msg = [[TPIMMessageModel alloc] initWithXMPPMessage:message];
                            if (msg != nil) {
                                [dic setValue:msg forKey:TPIMSendMessageObject];
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_SendMessageResult object:self userInfo:dic];
                        }
                    }
                    else{
                        i++;
                    }
                }
                    break;
                default:
                    break;
            }
            
        }
        
    }
    
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    
    if (self.sendMessageHandler) {
        self.sendMessageHandler(nil, error);
    }
    else{
        if (error != nil) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:error forKey:TPIMSendMessageError];
            TPIMMessageModel *msg = [[TPIMMessageModel alloc] initWithXMPPMessage:message];
            if (msg != nil) {
                [dic setValue:msg forKey:TPIMSendMessageObject];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_SendMessageResult object:self userInfo:dic];
        }
    }
}

#pragma mark - room
#pragma mark room operation
- (XMPPJID *)roomJidWithRoomName:(NSString *)name
{
    XMPPJID *roomjid;
    NSString *domain = [NSString stringWithFormat:@"@%@.%@",TPXmppMUCDomain,userHostName];
    if ([name rangeOfString:domain].location != NSNotFound || [name rangeOfString:@"@"].location != NSNotFound) {
        roomjid = [XMPPJID jidWithString:name resource:nil];
    }
    else{
        roomjid = [XMPPJID jidWithString:[name stringByAppendingString:domain] resource:nil];
    }
    return roomjid;
}

- (XMPPRoom *)xmppRoomWithRoomName:(NSString *)name isPublicRoom:(BOOL)isPublic
{
    XMPPJID *roomjid = [self roomJidWithRoomName:name];
    
    XMPPRoom *room;
    
    if (isPublic) {
        
        if (self.publicXmppRoomMemoryStorage == nil) {
            self.publicXmppRoomMemoryStorage = [[XMPPRoomMemoryStorage alloc] init];
        }
        room = [[XMPPRoom alloc] initWithRoomStorage:self.publicXmppRoomMemoryStorage jid:roomjid];
    }
    else{
        
        if (self.privateXmppRoomMemoryStorage == nil) {
            self.privateXmppRoomMemoryStorage = [[XMPPRoomMemoryStorage alloc] init];
        }
        
        room = [[XMPPRoom alloc] initWithRoomStorage:self.privateXmppRoomMemoryStorage jid:roomjid];
    }
    
//    [room activate:self.xmppStream];
//    [room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    return room;
}

- (void)joinRoom:(NSString *)roomname isPublicRoom:(BOOL)isPublic
{
    if (roomname.length == 0) {
        
        DDLogInfo(@"房间名不能为空");
        //[self showAlertViewWithMessage:@"房间名不能为空"];
        return;
    }
    
    if (![self.xmppStream isConnected]) {
        
        DDLogInfo(@"用户未登录，请先登录");
//        [self showAlertViewWithMessage:@"Xmpp未登录，请重新登录"];
        //登录xmpp
//        [TPIMUser loginWithUsername:[HiTVGlobals sharedInstance].xmppUserId password:[HiTVGlobals sharedInstance].xmppCode complecationHandler:^(id responseObject, NSError *error) {
//            
//        }];
    }
    else{
        
        isInvited = NO;
        NSString *nickname = [HiTVGlobals sharedInstance].xmppUserId.description;
        if (nickname.length == 0) {
            nickname = self.xmppStream.myJID.user;
        }
        if (isPublic) {
            self.xmppPublicRoom = [self xmppRoomWithRoomName:roomname isPublicRoom:isPublic];
            [self.xmppPublicRoom joinRoomUsingNickname:nickname history:nil password:nil];
            [self.xmppPublicRoom fetchConfigurationForm];
        }
        else{
            self.xmppPrivateRoom = [self xmppRoomWithRoomName:roomname isPublicRoom:isPublic];
            [self.xmppPrivateRoom joinRoomUsingNickname:nickname history:nil password:nil];
            [self.xmppPrivateRoom fetchConfigurationForm];
        }
        
        //[room configureRoomUsingOptions:nil];
    }
}

- (void)acceptInvitation:(TPIMMessageModel *)data
{
    //接受聊天室邀请
    data.videoname = data.contentModel.programName;
    
    if (data.contentModel.roomId.length == 0) {
        return ;
    }
    //XMPPRoom *room = [self xmppRoomWithRoomName:data.contentModel.roomId];
    self.xmppPrivateRoom = [self xmppRoomWithRoomName:data.contentModel.roomId isPublicRoom:NO];
    NSString *nickname = [HiTVGlobals sharedInstance].xmppUserId.description;
    if (nickname.length == 0) {
        nickname = self.xmppStream.myJID.user;
    }
    [[TPXmppRoomManager defaultManager] setInvitedMessageModel:data];
    [[TPXmppRoomManager defaultManager] setCurrentRoom:self.xmppPrivateRoom];
    [self.xmppPrivateRoom joinRoomUsingNickname:nickname history:nil];
}

- (void)leaveXmppRoom:(XMPPRoom *)room isPublicRoom:(BOOL)isPublic
{
    if (isPublic) {
        if (self.xmppPublicRoom) {
            [self.xmppPublicRoom leaveRoom];
        }
    }
    else{
        if (self.xmppPrivateRoom) {
            [self.xmppPrivateRoom leaveRoom];
        }
    }
    
}

- (void)destoryRoom:(NSString *)roomname
{
    BOOL isPublicRoom = YES;
    if (self.xmppPrivateRoom && [self.xmppPrivateRoom.roomJID.bare containsString:roomname]) {
        isPublicRoom = NO;
    }
    XMPPRoom *room = [self xmppRoomWithRoomName:roomname isPublicRoom:isPublicRoom];
    [room destroyRoom];
    [room deactivate];
}

- (void)getRoomInfo:(NSString *)roomname
{
    XMPPJID *roomjid = [self roomJidWithRoomName:roomname];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:roomjid];
    [iq addAttributeWithName:@"from" stringValue:[self.xmppStream myJID].full];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#info"];//http://jabber.org/protocol/muc#roominfo,http://jabber.org/protocol/disco#info
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}

//获取聊天室成员列表
- (void)getMemberListInRoom:(NSString *)roomname
{
//    XMPPRoom *room = [self xmppRoomWithRoomName:roomname];
//    
//    [room fetchModeratorsList];
    
}

- (void)getMemberListInXmppRoom:(XMPPRoom *)room
{
    if (room != nil) {
        [room fetchModeratorsList];
        [room fetchMembersList];
    }
}

- (void)updateGroupInfo:(TPIMGroup *)group
{
    
}

- (void)changeOccupantToAdmin:(NSString *)jid inRoom:(NSString *)roomjid
{
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:[XMPPJID jidWithString:roomjid]];
    [iq addAttributeWithName:@"from" stringValue:[self.xmppStream myJID].full];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:XMPPMUCAdminNamespace];
    
    NSXMLElement *item = [[NSXMLElement alloc] initWithName:@"item"];
    [item addAttributeWithName:@"affiliation" stringValue:@"admin"];
    [item addAttributeWithName:@"jid" stringValue:jid];
    [query addChild:item];
    
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
    
}

- (void)handleRoomError:(NSXMLElement *)error
{
    NSString *code = [error attributeStringValueForName:@"code"];
    if (code.length != 0) {
        NSInteger ecode = [code integerValue];
        switch (ecode) {
            case 409:
            {
                NSError *herror = [[NSError alloc] initWithDomain:TPIMErrorDomain code:[[error attributeStringValueForName:@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:@"昵称冲突"}];
                [self showAlertViewWithMessage:@"昵称冲突"];
                if (self.roomManagerHandler) {
                    self.roomManagerHandler(nil,herror);
                }
            }
                break;
            case 503:
            {
                NSError *herror = [[NSError alloc] initWithDomain:TPIMErrorDomain code:[[error attributeStringValueForName:@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:@"聊天室已满"}];
                [self showAlertViewWithMessage:@"聊天室已满"];
                if (self.roomManagerHandler) {
                    self.roomManagerHandler(nil,herror);
                }
            }
            case 404:
            {
                if (self.roomManagerHandler) {
                    self.roomManagerHandler(nil, nil);
                }
            }
                break;
            default:
                break;
        }
    }
    else{
        //NSString *errortype = [error attributeStringValueForName:@"type"];
    }
}


-(void)sendDefaultRoomConfig:(XMPPRoom *)room
{
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    
    NSXMLElement *field = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *value = [NSXMLElement elementWithName:@"value"];
    
    NSXMLElement *fieldowners = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *valueowners = [NSXMLElement elementWithName:@"value"];
    
    
    [field addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];  // 永久属性
    [fieldowners addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomowners"];  // 谁创建的房间
    
    [field addAttributeWithName:@"type" stringValue:@"boolean"];
    [fieldowners addAttributeWithName:@"type" stringValue:@"jid-multi"];
    
    [value setStringValue:@"0"];
    [valueowners setStringValue:[self.xmppStream.myJID full]]; //创建者的Jid
    
    [x addChild:field];
    [x addChild:fieldowners];
    [field addChild:value];
    [fieldowners addChild:valueowners];
    
    [room configureRoomUsingOptions:x];
    //    DDLogInfo(@"AFTER Config for the room %@",x);
}

#pragma mark XMPPRoomDelegate
//创建房间成功回调
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    //    [sender configureRoomUsingOptions:nil];
    //    [sender fetchConfigurationForm];
    //    [self sendDefaultRoomConfig:sender];
    //    if (self.roomManagerHandler) {
    //        self.roomManagerHandler(nil, nil);
    //    }
}

//加入房间成功回调
- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    if (isInvited) {
        
        [[TPXmppRoomManager defaultManager] joinRoom];
        
        TPIMUser *user = [[TPIMUser alloc] init];
        user.jid = self.xmppStream.myJID.bare;
        user.nickname = [HiTVGlobals sharedInstance].nickName;
        user.username = [HiTVGlobals sharedInstance].nickName;
        user.affiliation = @"none";
        NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[HiTVGlobals sharedInstance].faceImg]];
        user.headImage = [UIImage imageWithData:imagedata];
        user.headImageUrl = [HiTVGlobals sharedInstance].faceImg;
        [[TPXmppRoomManager defaultManager] showMyJoinRoomTip];
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_GroupChange_OccupantDidJoin object:self userInfo:@{TPIMNotification_GroupMemberKey:user,TPIMNotification_GroupNameKey:[sender.roomJID bare]}];
    }
    else{
        if (self.roomManagerHandler) {
            self.roomManagerHandler(sender, nil);
        }
    }
    
}

//离开房间回调
- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    if ([sender.roomJID.bare isEqualToString:self.xmppPrivateRoom.roomJID.bare]) {
        self.xmppPrivateRoom = nil;
    }
    else if ([sender.roomJID.bare isEqualToString:self.xmppPublicRoom.roomJID.bare]){
        self.xmppPublicRoom = nil;
    }
    
    if (self.roomManagerHandler) {
        self.roomManagerHandler(nil, nil);
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_GroupChange_DidLeave_ByDisconnection object:nil];
    }
}

//房间被销毁回调
- (void)xmppRoomDidDestroy:(XMPPRoom *)sender
{
    if (self.roomManagerHandler) {
        self.roomManagerHandler(nil, nil);
    }
}

//新人加入房间回调
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    
    NSXMLElement *x = [presence elementForName:@"x" xmlns:XMPPMUCUserNamespace];
    NSXMLElement *userItem;
    for (NSXMLElement *item in x.children) {
        //获取成员信息
        
        //jid
        NSString *jidS = [item attributeStringValueForName:@"jid"];
        
        //成员在房间中的角色
        NSString *affiliation = [item attributeStringValueForName:@"affiliation"];
        XMPPJID *jid = [XMPPJID jidWithString:jidS];
        if (![jid.bare isEqualToString:self.xmppStream.myJID.bare] && ![affiliation isEqualToString:@"admin"]) {
            
            //修改成员角色为admin
            [self changeOccupantToAdmin:jidS inRoom:[occupantJID bare]];
            
        }
        
        if ([[item attributeStringValueForName:@"nick"] isEqualToString:[occupantJID resource]]) {
            userItem = item;
        }
    }
    
    TPIMUser *user = [[TPIMUser alloc] initWithItemElement:userItem];
    if (occupantJID != nil && user != nil) {
        //发送成员加入房间通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_GroupChange_OccupantDidJoin object:self userInfo:@{TPIMNotification_GroupMemberKey:user,TPIMNotification_GroupNameKey:[sender.roomJID bare]}];
    }
    
}

//好友离开房间回调
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    //    DDLogInfo(@"occupantDidLeave:%@ withPresence:%@",occupantJID,presence);
    
    NSXMLElement *x = [presence elementForName:@"x" xmlns:XMPPMUCUserNamespace];
    NSXMLElement *userItem;
    for (NSXMLElement *item in x.children) {

        if ([[item attributeStringValueForName:@"nick"] isEqualToString:[occupantJID resource]]) {
            userItem = item;
        }
        
    }
    
    TPIMUser *user = [[TPIMUser alloc] initWithItemElement:userItem];
    if (occupantJID != nil && user != nil) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_GroupChange_OccupantDidLeave object:self userInfo:@{TPIMNotification_GroupMemberKey:user,TPIMNotification_GroupNameKey:[sender.roomJID bare]}];
    }
    
}
- (void)xmppRoom:(XMPPRoom *)sender didFailToDestroy:(XMPPIQ *)iqError{
    if (self.roomManagerHandler) {
        NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:nil];
        self.roomManagerHandler(nil, error);
    }
}
//获取到配置回调
- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(DDXMLElement *)configForm
{
    
    NSXMLElement *newConfig = [configForm copy];
    NSArray *fields = [newConfig elementsForName:@"field"];
    
    //    NSXMLElement *ownerField;
    NSXMLElement *allowinvitesField;
    NSXMLElement *getmemberlistField;
    //    NSXMLElement *anonymityField;
    
    for (NSXMLElement *field in fields)
    {
        NSString *var = [field attributeStringValueForName:@"var"];
        // Make Room Persistent
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"0"]];
        }
        //        else if ([var isEqualToString:@"muc#roomconfig_roomowners"]){
        //            ownerField = field;
        //            if (field.children.count > 0) {
        //                [field removeChildAtIndex:0];
        //            }
        //            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:[self.xmppStream.myJID full]]];
        //        }
        else if ([var isEqualToString:@"muc#roomconfig_allowinvites"]){
            allowinvitesField = field;
            if (field.children.count > 0) {
                [field removeChildAtIndex:0];
            }
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
        else if ([var isEqualToString:@"muc#roomconfig_getmemberlist"]){
            getmemberlistField = field;
            if (field.children.count > 0) {
                [field removeChildAtIndex:0];
            }
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"participant"]];
        }
        else if ([var isEqualToString:@"muc#roomconfig_anonymity"]){
            getmemberlistField = field;
            if (field.children.count > 0) {
                [field removeChildAtIndex:0];
            }
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"nonanonymous"]];
        }
        else{
            //其他设置
        }
    }
    //    if (ownerField == nil) {
    //        NSXMLElement *fieldowners = [NSXMLElement elementWithName:@"field"];
    //        NSXMLElement *valueowners = [NSXMLElement elementWithName:@"value"];
    //        [fieldowners addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomowners"];  // 谁创建的房间
    //        [fieldowners addAttributeWithName:@"type" stringValue:@"jid-multi"];
    //        [valueowners setStringValue:[self.xmppStream.myJID full]]; //创建者的Jid
    //        [fieldowners addChild:valueowners];
    //        [newConfig addChild:fieldowners];
    //    }
    if (allowinvitesField == nil) {
        NSXMLElement *fieldallowinvites = [NSXMLElement elementWithName:@"field"];
        NSXMLElement *valueallowinvites = [NSXMLElement elementWithName:@"value"];
        [fieldallowinvites addAttributeWithName:@"var" stringValue:@"muc#roomconfig_allowinvites"];
        [fieldallowinvites addAttributeWithName:@"type" stringValue:@"boolean"];
        [valueallowinvites setStringValue:@"1"];
        [fieldallowinvites addChild:valueallowinvites];
        [newConfig addChild:fieldallowinvites];
    }
    
    if (getmemberlistField == nil) {
        NSXMLElement *fieldgetmemberlist = [NSXMLElement elementWithName:@"field"];
        NSXMLElement *valuegetmemberlist = [NSXMLElement elementWithName:@"value"];
        [fieldgetmemberlist addAttributeWithName:@"var" stringValue:@"muc#roomconfig_getmemberlist"];
        [fieldgetmemberlist addAttributeWithName:@"type" stringValue:@"list-multi"];
        [valuegetmemberlist setStringValue:@"participant"];
        [fieldgetmemberlist addChild:valuegetmemberlist];
        [newConfig addChild:fieldgetmemberlist];
    }
    
    //    DDLogInfo(@"AFTER Config for the room %@",newConfig);
    [sender configureRoomUsingOptions:newConfig];
}

//房间配置失败回调
- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult
{
    [sender fetchConfigurationForm];
}

//房间配置成功回调
- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult
{
    if (self.roomManagerHandler) {
        self.roomManagerHandler(nil, nil);
    }
}

#pragma mark - presence
- (void)sendPresence:(XMPPPresence *)presence
{
    if (presence != nil) {
        if (presence.from == nil) {
            [presence addAttributeWithName:@"from" stringValue:[self.xmppStream.myJID bare]];
        }
        [self.xmppStream sendElement:presence];
    }
}

//收到presence回调
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    if ([presence.type isEqualToString:@"error"]) {
        /*<?xml version="1.0" encoding="utf-8"?>
         <presence xmlns="jabber:client" to="p14842727@jx.yst/1405531707-tigase-618" from="28ce26bdee7e4312bd72059daa08be2f@muc.jx.yst" type="error">
         <x xmlns="vcard-temp:x:update">
         <photo>1c68900a6180130021e2f1c29804f189b67be578</photo>
         </x>
         <error code="404" type="cancel">
         <item-not-found xmlns="urn:ietf:params:xml:ns:xmpp-stanzas"></item-not-found>
         <text xmlns="urn:ietf:params:xml:ns:xmpp-stanzas" lang="en">Unkown room</text>
         </error>
         </presence>
         */
        //加入房间/创建房间 出错处理
        NSXMLElement *error = [presence elementForName:@"error"];
        [self handleRoomError:error];
    }
    else{
       
        //成员进入/离开房间信息（用于房间拥有者进入/离开房间事件处理）
        NSXMLElement *x = [presence elementForName:@"x" xmlns:XMPPMUCUserNamespace];
        NSXMLElement *userItem;
        
        XMPPJID *from = [presence from];
        for (NSXMLElement *item in x.children) {
            //成员jid
            NSString *jidS = [item attributeStringValueForName:@"jid"];
            
            //成员在房间中角色
            NSString *affiliation = [item attributeStringValueForName:@"affiliation"];
            XMPPJID *jid = [XMPPJID jidWithString:jidS];
            
            if (![jid.bare isEqualToString:self.xmppStream.myJID.bare] && ![affiliation isEqualToString:@"admin"]) {
                //修改成员角色为admin（角色为none的成员无法邀请好友加入房间）
                [self changeOccupantToAdmin:jidS inRoom:[from bare]];
                
            }
            if ([[item attributeStringValueForName:@"nick"] isEqualToString:[from resource]]) {
                userItem = item;
            }
            
        }
        
        if (x.children.count > 0) {
            //用户类型转换
            TPIMUser *user = [[TPIMUser alloc] initWithItemElement:userItem];
            
            //房间jid
            NSString *fromStr = [presence fromStr];
            XMPPJID *roomJid = [self jidWithUsername:fromStr];
            
            if (from != nil && user != nil && userItem != nil) {
                
                if ([presence.type isEqualToString:@"unavailable"]) {
                    
                    if ([user.affiliation isEqualToString:@"owner"]) {
                        //成员（房间拥有者）离开房间
                        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_GroupChange_OccupantDidLeave object:self userInfo:@{TPIMNotification_GroupMemberKey:user,TPIMNotification_GroupNameKey:[roomJid bare]}];
                    }
                    
                }
                else{
                    //成员（房间拥有者）加入房间
                    if ([user.affiliation isEqualToString:@"owner"]) {
                        
                        //私聊房间jid不为空
                        if ([TPXmppRoomManager defaultManager].roomId.length > 0 && [fromStr containsString:[TPXmppRoomManager defaultManager].roomId]) {
                            //私聊房间信息更新
                            XMPPRoom *xmpproom = [self xmppRoomWithRoomName:[from bare] isPublicRoom:NO];
                            [[TPXmppRoomManager defaultManager] setCurrentRoom:xmpproom];
                           
                            //发送成员加入房间通知
                            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_GroupChange_OccupantDidJoin object:self userInfo:@{TPIMNotification_GroupMemberKey:user,TPIMNotification_GroupNameKey:[roomJid bare]}];
                        }
                        
                    }
                    
                }
                
            }
        }
        
    }
    
}

//发送presence回调
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence
{
    DDLogInfo(@"didSendPresence:%@",presence);
}

#pragma mark - IQ
- (void)sendIQ:(XMPPIQ *)iq
{
    if (iq != nil) {
        [self.xmppStream sendElement:iq];
    }
}

//收到iq回调
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    if([iq isResultIQ])
    {
        if([iq elementForName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"]){
        }
        else if ([iq elementForName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"]){
            //群组信息
            if (self.roomManagerHandler) {
                self.roomManagerHandler(iq,nil);
            }
        }
        else if ([iq elementForName:@"vCard" xmlns:@"vcard-temp"]){
            //用户资料
            XMPPvCardTemp *vcardt = [XMPPvCardTemp vCardTempSubElementFromIQ:iq];
            if (vcardt) {
                //头像
                NSXMLElement *photo = [vcardt elementForName:@"PHOTO"];
                
                if (photo != nil) {
                    //头像url
                    NSXMLElement *type = [photo elementForName:@"TYPE"];
                    
                    NSXMLElement *binval = [photo elementForName:@"BINVAL"];
                    
                    if ([type.stringValue isEqualToString:@"URL"]) {
                        
                        //url
                        //                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:binval.stringValue]];
                        //                        UIImage *image = [UIImage imageWithData:data];
                        if (self.vcardHandler) {
                            self.vcardHandler(binval.stringValue,nil);
                        }
                        
                    }
                    else{
                        //image/jpeg,image/png
                        NSData *base64Data = [[binval stringValue] dataUsingEncoding:NSASCIIStringEncoding];
                        NSData *decodedData = [base64Data xmpp_base64Decoded];
                        UIImage *image = [UIImage imageWithData:decodedData];
                        if (self.vcardHandler) {
                            self.vcardHandler(image,nil);
                        }
                        
                    }
                    
                }
                else{
                    if (self.vcardHandler) {
                        self.vcardHandler(nil,nil);
                    }
                }
                
            }
        }
    }
    return YES;
}

//发送iq回调
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq
{
    //    DDLogInfo(@"didSendIQ:%@",iq);
}

#pragma mark - alert
- (void)showAlertViewWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Setter
- (void)setXmppPublicRoom:(XMPPRoom *)xmppPublicRoom
{
    if (xmppPublicRoom) {
        _xmppPublicRoom = xmppPublicRoom;
        [_xmppPublicRoom deactivate];
        [_xmppPublicRoom removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppPublicRoom activate:self.xmppStream];
        [_xmppPublicRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    else{
        if (_xmppPublicRoom) {
            
            [_xmppPublicRoom deactivate];
            [_xmppPublicRoom removeDelegate:self delegateQueue:dispatch_get_main_queue()];
            
        }
        _xmppPublicRoom = xmppPublicRoom;
    }
}

- (void)setXmppPrivateRoom:(XMPPRoom *)xmppPrivateRoom
{
    if (xmppPrivateRoom) {
        _xmppPrivateRoom = xmppPrivateRoom;
        [_xmppPrivateRoom deactivate];
        [_xmppPrivateRoom removeDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppPrivateRoom activate:self.xmppStream];
        [_xmppPrivateRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    else{
        if (_xmppPrivateRoom) {
            
            [_xmppPrivateRoom deactivate];
            [_xmppPrivateRoom removeDelegate:self delegateQueue:dispatch_get_main_queue()];
            _privateXmppRoomMemoryStorage = nil;
        }
        _xmppPrivateRoom = xmppPrivateRoom;
    }
}

@end
