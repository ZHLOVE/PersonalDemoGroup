//
//  SJAlbumModel.h
//  ShiJia
//
//  Created by 峰 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 code String 是 0：成功； 其它：错误
 message String 否 描述信息
 albumList List 否 相册列表
*/
@interface SJAlbumModel : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray  *albumList;


@end
/*1 code String  相册code
 2 uid String    主人uid
 3 coverUrl String 否 封面相片url
 */
@interface CloudAlbumModel : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;//相册属性
@property (nonatomic, strong) UIImage  *imageV;//本地相册使用的属性
@property (nonatomic, assign) Album_Type albumType;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *coverUrl;

@end

/*
 
 1 uid String 是 主人uid
 2 shareUid String 否 关联用户uid
 3 caller Enum 是 请求来源：TV,APP
 */
@interface SJAlbumRequestModel : NSObject

@property (nonatomic, strong) NSString *uid;
//!!!: 更新文档参数已删除
//@property (nonatomic, strong) NSString *shareUid;
@property (nonatomic, strong) NSString *caller;

@end

/**
 *  请求相片Model
 1 albumCode String 否 相册code，如果些参数有值，按相册code查询（2选1）
 2 uid String 否 用户uid，如果此参数有值，就查询此用户的相册（2选1）
 3 source Enum 否 资源来源：TV,APP,WECHAT
 4 resourceType Enum 否 枚举：VIDEO,PHOTO
 5 pageNo int 否 第几页，默认为1
 6 pageSize int 否 每页几条数据，默认10条
 5 caller Enum 是 请求来源：TV,APP
 */
@interface CloudRequestPhotoModel : NSObject
@property (nonatomic, strong) NSString *albumCode;
@property (nonatomic, strong) NSString *albumUid;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *resourceType;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSString *caller;

@end
/**
 *  单个相片model
 code String 是 资源code
 thumbnailUrl String 是 缩略图url
 resourceUrl String 是 资源url
 resourceLength Int 否 视频长度，单位秒
 resourceType Enum 是 枚举：VIDEO,PHOTO
 source Enum 是 上传方式：TV,APP,WECHAT
 resourceMasterUid String 是 资源主人
 delete Boolean 是 是否可以删除：true，false
 createTime String 是 资源上传时间
 */
@interface CloudPhotoModel : NSObject
@property (nonatomic, strong) NSString *albumCode;
@property (nonatomic, strong) NSString *albumUid;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *resourceUrl;
@property (nonatomic, assign) NSInteger resourceLength;
@property (nonatomic, strong) NSString *resourceType;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *resourceMasterUid;
@property (nonatomic, assign) BOOL delete;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *uploadNickName;
@property (nonatomic, strong) NSString *faceImg;
@property (nonatomic, strong) NSString *md5;


@end
/**
 *  添加相片请求model
 uid      String 是 用户uid
 shareUid String 是 分享的uid
 source    Enum  是 上传方式：TV,APP,WECHAT
 thumbnailUrl  String 是 缩略图url
 resourceUrl   String 是 资源url
 resourceLength Int 否 视频长度，单位秒
 resourceType Enum 是 枚举：VIDEO,PHOTO
 */
@interface AddPhotoRequestModel : NSObject
@property (nonatomic, strong) NSString *uploadUid;
@property (nonatomic, strong) NSString *uploadNickName;
@property (nonatomic, strong) NSString *faceImg;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *shareUid;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *resourceUrl;
@property (nonatomic, assign) NSInteger resourceLength;
@property (nonatomic, strong) NSString *resourceType;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *caller;
@property (nonatomic, strong) NSString *md5;

@end

@interface AddResponseModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;

@end
/**
 *  删除相片请求Model
 *  resourceCode 相片code
 *  caller       请求来源：TV,APP
 */
@interface DeletePhotoRequestModel : NSObject

@property (nonatomic, strong) NSString *resourceCode;
@property (nonatomic, strong) NSString *caller;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *uid;
@end

@interface DeleteResponse : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;

@end

/**
 *  获取用户的信息
 */
@interface RequestUserInfoModel : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *oprUid;

@end

/**
 *  用户model
 */

@interface SJAlbumUserInfoModel : NSObject

@property (nonatomic, strong) NSString  *userName;
@property (nonatomic, strong) NSString  *nickName;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString  *phoneNo;
@property (nonatomic, assign) NSInteger userAuth;
@property (nonatomic, strong) NSString  *faceImg;

@end
