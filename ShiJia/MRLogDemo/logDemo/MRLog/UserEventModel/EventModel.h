//
//  EventModel.h
//  logDemo
//
//  Created by MccRee on 2017/7/26.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : NSObject

/*
startup         APP启动
login           登陆
expose          曝光
click           点击（基础点击动作)
recdelete       看单删除
search          搜索
filter          筛选
collect         收藏
scancode        扫码
screenmapping   投屏
share           分享
share_open      打开分享链接
message         私聊/约片/广场
addfriend       添加好友
control         遥控器
pull            拉屏
externalservice	外部服务
openaction      打开视频
playaction      播放视频
playqos         播放质量
*/
@property(nonatomic,copy) NSString *event_id;

@end
