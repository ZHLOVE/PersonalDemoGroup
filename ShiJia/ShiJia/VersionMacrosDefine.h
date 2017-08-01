//
//  VersionMacrosDefine.h
//  ShiJia
//
//  Created by 峰 on 2016/11/11.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#ifndef VersionMacrosDefine_h
#define VersionMacrosDefine_h

/*
 *北京版本
 */
#if  BeiJing
#define DOMAIN_SHORT_NAME  @"BJ"
#define CHANNELID          @"BJTPTPTEST"     //服务集
#define CurrentAppName     @"云视界"
#define ProtocolTitle      @"云视界会员服务协议"
#define AgreeProtocal      @"同意《云视界会员协议》"
#define ProtocalHtmlName   @"ysten_member_protocol_BeiJing"
#define LoginLogoImageName @"视加logoiphone6_BJ.png"
#define SocialPlistName    @"SocialShareData_BeiJing"
#define SocialShareContent @"我正在用追剧神器【云视界】，看电视剧看大片可以和好友边看边聊，挺有意思，来这里咱们一起吐槽侃大山吧！"
#define VideoShareTitle    @"云视界视频分享"
#define ImageShareTitle    @"云视界图片分享"
#define MsgImageName       @"msgdefault.png"
#define AboutImageName     @"about_logo_icon_bj.png"
#define UMengAppKey        @"58f036cc04e205b35e001722"


#define SJAlbumImage       @"SJAlbum_help.png"
#define SJRight            @"Copyrights ©2017 BMCC All Rights Reserved"
#define SJCompanyName      @"无锡易视腾科技有限公司"
#define SJLOGINBELLOWTIP   @"登录可享受云遥控、多屏互动、好友聊天等更多服务"
#define DEFAULTHEADICON    @"头像默认"
#define LIGHTHEADICON      @"头像默认"
#define BOOTHOST           @"http://bimsmobile.ott.bj.chinamobile.com:8084"
#define APPStroreID         @""
#define GoumaiImage         @"goumai"

#define AppLOGO             @"bj_logo.png"
#define kColorBlueTheme          RGB(8, 198, 0, 1)  //系统颜色
#define kNavgationBarColor        RGB(32, 32, 32, 1)//导航栏颜色
#define kNavTitleColor          [UIColor whiteColor]
#define k1StatusStyle        1//状态栏类型
#define k2StatusStyle        1//状态栏类型 用于播放详情页的状态
#define htmlString  @"<font color='#aaaaaa'>聊天室有点凄凉,</font> <font color='#08c600'>邀请好友</font> <font color='#aaaaaa'>一起看</font>"
#define APPVersion     [NSString stringWithFormat:@"BJ_%@_%@",kAPP_VERSION,kAPP_SUB_VERSION]

//------第三方-----//
#define BuglyId             @"91fd77e101"
#define kSinaAppID        @"341726974"
#define kWeChatAppID      @"wx053be1fadf449381"


/*
 *江苏版本
 */
#elif JiangSu
//#define CHANNELID          @"JSTPTPDMS"     //服务集
//#define CHANNELID          @"JSTPTPHW"     //华为CDN

#define CHANNELID          @"jstptphwtest"     //6.5.2 DMS支付服务集

#define CurrentAppName     @"和家庭"
#define ProtocolTitle      @"和家庭会员服务协议";
#define AgreeProtocal      @"同意《和家庭会员协议》"
#define ProtocalHtmlName   @"ysten_member_protocol_JS"
#define LoginLogoImageName @"视加logoiphone6_JS.png"
#define SocialPlistName    @"SocialShareData_JS"
#define SocialShareContent @"我正在用约片神器【和家庭】，看电视剧看大片可以和好友边看边聊，挺有意思，来这里咱们一起吐槽侃大山吧！"
#define VideoShareTitle    @"和家庭视频分享"
#define ImageShareTitle    @"和家庭图片分享"
#define MsgImageName       @"msgdefault_JS.png"
#define AboutImageName     @"about_logo_icon_JS.png"
#define SJAlbumImage       @"SJAlbum_help.png"
#define SJRight            @"Copyrights ©2017 江苏移动 All Rights Reserved"
#define SJCompanyName      @"中国移动通信集团江苏有限公司"
#define SJLOGINBELLOWTIP      @""
#define DEFAULTHEADICON    @"登录"
#define LIGHTHEADICON      @"登录成功"
#define BOOTHOST           @"https://jsmobileboot.ssl.ysten.com:8084"

#define APPStroreID         @"JSTP_"
#define GoumaiImage         @"goumai"

#define BuglyChannel             @"jstp"
#define AppLOGO               @"js_logo.png"
#define UMengAppKey        @"58c7a7a065b6d63f8e00173d"
#define kColorBlueTheme     RGB(1, 132, 207, 1)     //系统颜色
#define kNavgationBarColor        [UIColor whiteColor] //导航栏颜色
#define kNavTitleColor          [UIColor blackColor]
#define k1StatusStyle        0//状态栏类型
#define k2StatusStyle        1//状态栏类型 用于播放详情页的状态
#define htmlString  @"<font color='#aaaaaa'>聊天室有点凄凉,</font> <font color='#0085CF'>邀请好友</font> <font color='#aaaaaa'>一起看</font>"
#define APPVersion     [NSString stringWithFormat:@"JS_%@_%@",kAPP_VERSION,kAPP_SUB_VERSION]

//------第三方--AppID-----//
#define BuglyId               @"636ec8376d"
#define kSinaAppID            @"2989012782"
#define kWeChatAppID          @"wxc411861caf5c1065"

#endif

#endif /* VersionMacrosDefine_h */
