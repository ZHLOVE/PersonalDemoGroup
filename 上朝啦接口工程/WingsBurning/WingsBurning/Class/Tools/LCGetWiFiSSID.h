//
//  LCGetWiFiSSID.h
//  WiFi-SSID
//
//  Created by MoGo on 16/3/24.
//  Copyright © 2016年 李策--MoGo--. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCGetWiFiSSID : NSObject
/**
 *SSID（Service Set Identifier）也可以写为ESSID，用来区分不同的网络，最多可以有32个字符，无线网卡通过连接不同的SSID（即AP）并输入相应AP的密码就可以进入不同网络，SSID通常由AP广播出来，通过Windows自带的扫描功能可以相看当前区域内的SSID。出于安全考虑可以不广播SSID，此时用户就要手工设置SSID才能进入相应的网络。简单说，SSID就是一个局域网的名称，只有设置为名称相同SSID的值的电脑才能互相通信。
 
        BSSID 是指站点的 MAC 地址，（STA）在一个接入点，（AP）在一个基础架构模式BSS是由 IEEE 802.11-1999 无线局域网规范定义的。这个区域唯一地定义了每个BSS 。在一个 IBSS 中，BSSID 是一个本地管理的 IEEE MAC 地址，从一个 46位的任意编码中产生。地址的个体/组位被设置为 0 。通用/本地地址位被设置为1 。
 *
 *
 */


/**
*  SSID就是一个局域网的名称，只有设置为名称相同SSID的值的电脑才能互相通信
*/
+ (NSString *)getSSID;
/**
 *  BSSID 是指站点的 MAC 地址
 */
+ (NSString *)getBSSID;
/**
 *  IP地址
 */
+ (NSString *)localIPAddress;
@end
