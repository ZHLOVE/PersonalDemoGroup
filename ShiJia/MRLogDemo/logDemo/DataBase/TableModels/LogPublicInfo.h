//
//  LogPublicInfo.h
//  logDemo
//
//  Created by MccRee on 2017/7/25.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 事件公共信息表
 */
@interface LogPublicInfo : NSObject
@property(nonatomic,copy)NSString * uid;        //	用户ID	String	uid
@property(nonatomic,copy)NSString * phone_no;   //	手机号	String	phone_no
@property(nonatomic,copy)NSString * brand;      //	手机品牌	String	brand
@property(nonatomic,copy)NSString * t;          //	时间戳	String	t
@property(nonatomic,copy)NSString * y_cookie;   //	cookie标识	String	y_cookie H5页面使用
@property(nonatomic,copy)NSString * versionid; 	//app版本	String	versionid
@property(nonatomic,copy)NSString * nettype;	//wifi eth 2g 3g 4g 5g
@property(nonatomic,copy)NSString * wifiid;     //无线网络的ssid	String	wifiid
@property(nonatomic,copy)NSString * innerip;    //	内网ip地址	String	innerip
@property(nonatomic,copy)NSString * gatwaymac;  //	网关mac地址	String	gatwaymac
@property(nonatomic,copy)NSString * event_id;   //	事件ID	String	event_id
@property(nonatomic,strong)NSObject *props;     //	事件属性	Object	props

@end
