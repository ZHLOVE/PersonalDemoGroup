//FIXME:后期 domain 修改
//FIXME:后期 上传 又拍云的URL
//FIXME:后期 查询云相册的URL
//FIXME:后期 缩略图后缀配置



//
//  SJAlbumNetWork.h
//  ShiJia
//
//  Created by 峰 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJAlbumNetWork : NSObject
/**
 *  查询可以浏览的相册
 */
+(void)SJ_AlbumQueryAlbumRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock;

/**
 *  相片查询
 */
+(void)SJ_AlbumQueryPhotoRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock;
/**
 *  相片删除
 */
+(void)SJ_AlbumDeletePhotoRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock;
/**
 *  相片添加接口
 */
+(void)SJ_AlbumAddPhotoRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock;

/**
 *  根据Uid获取该用户的相关信息
 */
+(void)SJAlbum_GetUserInfo:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock;


/**
 *  获取好友资料
 */
+(void)SJAlbum_GetMyFriendsInfoListBlock:(void(^)(id result ,NSString *error))Handlerblock;

/**
 *  读取保存到沙盒中的json文件
 *
 *  @param JsonFileName 文件名字
 *
 *  @return 获取一个数组对象
 */
+(NSArray *)receiveJsonData:(NSString *)JsonFileName;
/**
 *  Description   把一些数据保存一个json文件到沙盒中
 *
 *  @param JsonfileName 文件名字
 *  @param Objecet      data是一个数组对象的形式传入
 *
 *  @return 是否保存成功
 */
+(BOOL)SaveJsonData:(NSString *)JsonfileName Data:(NSArray *)Objecet;


/**
 *  根据UID 获取好友名字
 *
 *  @param uid uid
 *
 *  @return 好友名字
 */
+(NSString *)getFriendName:(NSString *)uid;
/**
 *  根据UID 获取好友头像
 *
 *  @param uid uid
 *
 *  @return 头像URL
 */
+(NSString *)getFriendImage:(NSString *)uid;

@end
