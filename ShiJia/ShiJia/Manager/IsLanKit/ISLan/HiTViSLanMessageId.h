//
//  HiTVDeviceMessageId.h
//  HiTV
//
//  Created by ringyee on 15/1/26.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

/**
 * @brief (客户端->服务器端)心跳请求信息。
 */
MSGID_DEF(CTS_HEARTBEAT, 0x00000000)

/**
 * @brief (客户端->服务器端)取得服务器信息。
 */
MSGID_DEF(CTS_INFO, 0x00000001)

/**
 * @brief (客户端->服务器端)登陆。
 */
MSGID_DEF(CTS_LOGIN, 0x00000002)

/**
 * @brief (客户端->服务器端)登出。
 */
MSGID_DEF(CTS_LOGOUT, 0x00000003)

/**
 * @brief (客户端->服务器端)按键消息ID。
 */
MSGID_DEF(CTS_KEY, 0x00000004)

/**
 * @brief (客户端->服务器端)触摸消息ID。
 */
MSGID_DEF(CTS_TOUCH, 0x00000005)

/**
 * @brief (客户端->服务器端)屏幕画面截取请求消息ID。
 */
MSGID_DEF(CTS_SCREEN_SNAP, 0x00000006)

/**
 * @brief (客户端->服务器端)图片显示请求消息ID。
 */
MSGID_DEF(CTS_SHOW_PIX, 0x00000007)

/**
 * @brief (客户端->服务器端)视频显示请求消息ID。
 */
MSGID_DEF(CTS_SHOW_VIDEO, 0x00000008)

/**
 * @brief (客户端->服务器端)音乐显示请求消息ID。
 */
MSGID_DEF(CTS_SHOW_MUSIC, 0x00000009)

/**
 * @brief (客户端->服务器端)关闭所有窗口。
 */
MSGID_DEF(CTS_CLOSE_ALL_WINDOW, 0x0000000a)

/**
 * @brief (客户端->服务器端)隐藏服务器页面悬浮图标。
 */
MSGID_DEF(CTS_HIDE_VIEW_ICON, 0x0000000b)

/**
 * @brief (客户端->服务器端)播放器开始播放。
 */
MSGID_DEF(CTS_PLAYER_START, 0x0000000c)

/**
 * @brief (客户端->服务器端)播放器暂停。
 */
MSGID_DEF(CTS_PLAYER_PAUSE, 0x0000000d)

/**
 * @brief (客户端->服务器端)播放器seek。
 */
MSGID_DEF(CTS_PLAYER_SEEK, 0x0000000e)

/**
 * @brief (客户端->服务器端)设置桌面背景。
 */
MSGID_DEF(CTS_SET_DESKTOP, 0x0000000f)

/**
 * @brief (客户端->服务器端)取得应用列表。
 */
MSGID_DEF(CTS_GET_APP_LIST, 0x00000010)

/**
 * @brief (客户端->服务器端)启动应用。
 */
MSGID_DEF(CTS_START_APP, 0x00000011)

/**
 * @brief (客户端->服务器端)请求seek信息。
 */
MSGID_DEF(CTS_GET_SEEK, 0x00000012)

/**
 * @brief (客户端->服务器端)传感器消息ID。
 */
MSGID_DEF(CTS_SENSOR, 0x00000013)

/**
 * @brief (客户端->服务器端)停止应用。
 */
MSGID_DEF(CTS_STOP_APP, 0x00000014)

/**
 * @brief (客户端->服务器端)播放器停止播放。
 */
MSGID_DEF(CTS_PLAYER_STOP, 0x00000015)

/**
 * @brief (客户端->服务器端)播放器播放下一首。
 */
MSGID_DEF(CTS_PLAYER_NEXT, 0x00000016)

/**
 * @brief (客户端->服务器端)播放器播放上一首。
 */
MSGID_DEF(CTS_PLAYER_PREVIOUS, 0x00000017)

/**
 * @brief (客户端->服务器端)追加图片显示请求消息ID。
 */
MSGID_DEF(CTS_ADD_SHOW_PIX, 0x00000018)

/**
 * @brief (客户端->服务器端)追加视频显示请求消息ID。
 */
MSGID_DEF(CTS_ADD_SHOW_VIDEO, 0x00000019)

/**
 * @brief (客户端->服务器端)追加视频显示请求消息ID。
 */
MSGID_DEF(CTS_ADD_SHOW_MUSIC, 0x0000001a)

/**
 * @brief (客户端->服务器端)请求播放器状态。
 */
MSGID_DEF(CTS_GET_PLAYER_STATE, 0x0000001b)

/**
 * @brief (客户端->服务器端)图片的旋转消息
 */
MSGID_DEF(CTS_SET_ROTATION, 0x0000001c)

/**
 * @brief (客户端->服务器端)下载APK并安装消息
 */
MSGID_DEF(CTS_DOWNLOAD_APK, 0x0000001d)

/**
 * @brief (客户端->服务器端)卸载APK消息
 */
MSGID_DEF(CTS_UNINSTALL_APK, 0x00000100)

/**
 * @brief (服务器端->客户端)心跳回复信息。
 */
MSGID_DEF(STC_HEARTBEAT_REQUEST, 0x10000000)

/**
 * @brief (服务器端->客户端)取得服务器结果信息。
 */
MSGID_DEF(STC_INFO_REQUEST, 0x10000001)

/**
 * @brief (服务器端->客户端)登陆结果。
 */
MSGID_DEF(STC_LOGIN_REQUEST, 0x10000002)

/**
 * @brief (服务器端->客户端)登出结果。
 */
MSGID_DEF(STC_LOGOUT_REQUEST, 0x10000003)

/**
 * @brief (服务器端->客户端)屏幕画面截取结果。
 */
MSGID_DEF(STC_SCREEN_SNAP_REQUEST, 0x10000006)

/**
 * @brief (服务器端->客户端)取得应用列表结果。
 */
MSGID_DEF(STC_GET_APP_LIST_REQUEST, 0x10000007)

/**
 * @brief (服务器端->客户端)请求seek信息结果。
 */
MSGID_DEF(STC_GET_SEEK_REQUEST, 0x10000008)

/**
 * @brief (服务器端->客户端)播放视频结果。
 */
MSGID_DEF(STC_SHOW_VIDEO_REQUEST, 0x10000009)

/**
 * @brief (服务器端->客户端)播放音频结果。
 */
MSGID_DEF(STC_SHOW_MUSIC_REQUEST, 0x1000000a)

/**
 * @brief (服务器端->客户端)请求播放器状态结果。
 */
MSGID_DEF(STC_GET_PLAYER_STATE_REQUEST, 0x1000000b)

//modify by jianghailiang
/**
 * @brief (客户端->服务器端)语音发送。
 */
MSGID_DEF(CTS_SEND_SPEECH_REQUEST, 0x00000080)
