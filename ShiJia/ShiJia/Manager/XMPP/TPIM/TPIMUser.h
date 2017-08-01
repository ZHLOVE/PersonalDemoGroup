//
//  TPIMUser.h
//  XmppDemo
//
//  Created by yy on 7/3/15.
//  Copyright (c) 2015 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPIMConstants.h"
#import "NSXMLElement+XMPP.h"
#import <UIKit/UIKit.h>
@class XMPPvCardTemp;

/**
 *  被下线通知
 */
extern NSString * const TPXMPPOfflineNotification;

/**
 *  重新登录通知
 */
extern NSString * const TPXMPPOnlineNotification;

/**
 *  xmpp重新连接通知
 */
extern NSString * const TPXMPPReconnectNotification;

/**
 *  更新用户信息类型Enum
 */
typedef NS_ENUM(NSUInteger, TPIMUpdateUserInfoType) {
    kTPIMNickname  = 0,//别名
    kTPIMBirthday  = 1,//生日
    kTPIMSignature = 2,//个性签名
    kTPIMGender    = 3,//性别
    kTPIMRegion    = 4,//地区
    kTPIMAvatar    = 5,//个人头像
};

/**
 *  性别Enum
 */
typedef NS_ENUM(NSUInteger, TPIMUserGender){
    kTPIMUnknown = 0,
    kTPIMMale,
    kTPIMFemale,
};

@interface TPIMUser : NSObject

@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *avatarResourcePath;
@property (nonatomic,strong) NSString *avatarThumbPath;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,assign) TPIMUserGender userGender;
@property (nonatomic,strong) NSString *cTime;

@property (nonatomic,assign) NSInteger star;
@property (nonatomic,assign) NSInteger blackList;
@property (nonatomic,strong) NSString *region;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *noteName;
@property (nonatomic,strong) NSString *noteText;
@property (nonatomic,strong) NSString *signature;
@property (nonatomic,strong) NSString *jid;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong) NSString *headImageUrl;
@property (nonatomic,strong) NSString *affiliation;

- (instancetype)initWithItemElement:(NSXMLElement *)item;
- (instancetype)initWithItemElement:(DDXMLElement *)item headImage:(UIImage *)img;
- (instancetype)initWithXMPPvCardTemp:(XMPPvCardTemp *)vCard;

#pragma mark - login
/**
 *  用户登录接口（设置成自己的服务器）
 *
 *  @param username 用户名。定义参照注册接口
 *  @param password 用户密码。定义参照注册接口
 *  @param hostname 主机名
 *  @param port     端口号（默认5222）
 *  @param resource 资源
 *  @param handler  结果回调
 */
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                     host:(NSString *)host
                 hostName:(NSString *)hostname
                 hostPort:(UInt16)port
                 resource:(NSString *)resource
      complecationHandler:(TPIMCompletionHandler)handler;

/**
 *  用户登录接口（Ysten服务器）
 *
 *  @param username 用户名。定义参照注册接口
 *  @param password 用户密码。定义参照注册接口
 *  @param handler  结果回调
 */
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
      complecationHandler:(TPIMCompletionHandler)handler;


#pragma mark - register
/**
 *  用户登录接口（设置成自己的服务器）
 *
 *  @param username 用户名。定义参照注册接口
 *  @param password 用户密码。定义参照注册接口
 *  @param hostname 主机名
 *  @param port     端口号（默认5222）
 *  @param resource 资源
 *  @param handler  结果回调
 */
+ (void)registerWithUsername:(NSString *)username
                 password:(NSString *)password
                 host:(NSString *)host
                 hostName:(NSString *)hostname
                 hostPort:(UInt16)port
                 resource:(NSString *)resource
      complecationHandler:(TPIMCompletionHandler)handler;

/**
 *  用户登录接口（Ysten服务器）
 *
 *  @param username 用户名。定义参照注册接口
 *  @param password 用户密码。定义参照注册接口
 *  @param handler  结果回调
 */
+ (void)registerWithUsername:(NSString *)username
                 password:(NSString *)password
      complecationHandler:(TPIMCompletionHandler)handler;


#pragma mark - logout
/**
 *  用户登出接口
 *
 *  @param handler 结果回调
 */
+ (void)logoutWithCompletionHandler:(TPIMCompletionHandler)handler;


#pragma mark - userinfo
/**
 *  获取用户信息接口
 *
 *  @param username      用户名
 *  @param handler       结果回调。resultObject对象类型为TPIMUser。
 */
+ (void)getUserInfoWithUsername:(NSString *)username
              completionHandler:(TPIMCompletionHandler)handler;

/**
 *  获取用户本身个人信息接口
 *
 *  @return 当前登陆账号个人信息
 */
+ (TPIMUser *)getMyInfo;

/**
 *  获取头像原始图片
 *
 *  @param  userInfo      需要获取头像的用户信息(可以通过getUserInfo接口获取)
 *  @param  handler       结果回调。resultObject对象为TPIMUser类型,通过avatarResourcePath属性获取下载图片绝对路径
 *
 */
+ (void)getOriginAvatarImage:(TPIMUser *)userInfo
           completionHandler:(TPIMCompletionHandler)handler;

/**
 *  更新用户信息接口
 *
 *  @param parameter     更新的值。除kTPIMGender性别类型，需要传入TPIMUserGender包装成NSNumber的对象，其他类型传NSString类型的对象。
 *  @param type          更新属性类型,这是一个 enum 类型
 *  @param handler       结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)updateMyInfoWithParameter:(id)parameter
                         withType:(TPIMUpdateUserInfoType)type
                completionHandler:(TPIMCompletionHandler)handler;

/**
 *  更新密码接口
 *
 *  @param newPassword   用户新的密码,长度 4~128 位，字符不限。
 *  @param oldPassword   用户旧的密码,长度 4~128 位，字符不限。
 *  @param handler       结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)updatePasswordWithNewPassword:(NSString *)newPassword
                          oldPassword:(NSString *)oldPassword
                    completionHandler:(TPIMCompletionHandler)handler;

/**
 *  获取用户头像
 *
 *  @param username 用户jid或uid
 *
 *  @return 返回头像image
 */
+ (UIImage *)getAvatarImageWithUsername:(NSString *)username;

/**
 *  获取用户头像url
 *
 *  @param username 用户jid或uid
 *
 *  @return 返回头像url
 */
+ (NSString *)getAvatarImageUrlWithUsername:(NSString *)username;

/**
 *  获取用户头像
 *
 *  @param handler 回调
 */
- (void)getAvatarWithCompletionHandler:(TPIMCompletionHandler)handler;

/**
 *  获取用户昵称
 *
 *  @param username 用户名
 *
 *  @return 返回昵称
 */
+ (NSString *)getNickNameWithUsername:(NSString *)username;


+ (void)getUserNickNameAndAvatarImageUrlWithUsername:(NSString *)username
                                             success:(void(^)(NSString *nick_name, NSString *imgurl))response;

+ (NSString *)jidString:(NSString *)uid;

+ (NSString *)xmppHostName;

@end
