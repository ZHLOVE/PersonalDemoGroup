//
//  BaseViewController.h
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Creation.h"
#import "UIColor+HexColor.h"
#import "Networking.h"
#import "NetModel.h"
#import "Verify.h"
#import "UIViewController+MMDrawerController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "QiniuSDK.h"
#import "SHA1.h"
#import "CustomIOSAlertView.h"
#import "CustomView.h"
#import "CCLocationManager.h"
#import "LCGetWiFiSSID.h"
#import "NSObject+XWAdd.h"
#import "HJCornerRadius.h"
#import "CheckDataTool.h"
#import "JZLocationConverter.h"
#import "UIImage+SubImage.h"
#import "GetPhoneType.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

#define ratio  [UIScreen mainScreen].bounds.size.height / 667
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

@interface BaseViewController : UIViewController

@end
