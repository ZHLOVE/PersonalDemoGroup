//
//  ShiJiaTheme.h
//  ShiJia
//
//  Created by yy on 16/3/10.
//  Copyright © 2016年 yy. All rights reserved.
//
#import "UIColor-Expanded.h"
#define RGB(a, b, c, opacity) [UIColor colorWithRed:(a / 255.0) green:(b / 255.0) blue:(c / 255.0) alpha:opacity]


//屏幕高度
#define H [UIScreen mainScreen].bounds.size.height
#define W [UIScreen mainScreen].bounds.size.width

// 颜色值
#define kColorBlueHexValue        @"08c600" // 导航栏（主题）蓝色背景色值 RGB: 54  / 195 / 237
#define kColorDarkGrayHexValue    @"333435" // 深灰色背景色值 RGB: 51  / 52 / 53

#define kColorWhite               [UIColor colorWithHexString:@"202020"] // RGB: 255 / 255 / 255
//#define kColorBlueTheme           [UIColor colorWithHexString:@"36c3ed"] // RGB: 54  / 195 / 237
#define kColorLightGrayBackground [UIColor colorWithHexString:@"f2f2f2"] // RGB: 242 / 242 / 242
#define kColorGraySeparator       [UIColor colorWithHexString:@"e6e6e6"] // 灰色分割线颜色 RGB: 230 / 230 / 230
#define kColorOrange              [UIColor colorWithHexString:@"F3725A"] // RGB: 243 / 114 / 90
#define kColorLightGray           [UIColor colorWithHexString:@"CCCCCC"] // RGB: 204 / 204 / 204

#define kColorWhiteAlpha          [UIColor colorWithRed:0xff/255.0f green:0xff/255.0f blue:0xff/255.0f alpha:1.0f]
#define kColorNavgationView       [UIColor colorWithRed:0xf2/255.0f green:0xf2/255.0f blue:0xf2/255.0f alpha:1.0]

#define kColorHomeBar             [kColorLightGray4 colorWithAlphaComponent:0.98]
#define kColorTryButton           [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0]
#define kColorDeleteBgImg           [UIColor colorWithRed:243/255.0f green:59/255.0f blue:25/255.0f alpha:1.0]
#define klightGrayColor           [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0]
#define kSliderColor               [UIColor colorWithRed:41/255.0f green:194/255.0f blue:240/255.0f alpha:1.0]

#define kTabLineColor            [UIColor colorWithHexString:@"e5e5e5"]
#define kLiveColor               [UIColor colorWithHexString:@"444444"]

// font
#define kFontColorBlack           [UIColor colorWithHexString:@"000000"]
#define kFontColorGray            [UIColor colorWithHexString:@"9a9a9a"]
#define kFontColorDarkGray        [UIColor colorWithHexString:@"444444"]

#define kFontSizeLarge5_HT        [UIFont fontWithName:@"HelveticaNeue-Thin" size:55]
#define kFontSizeLarge4_HT        [UIFont fontWithName:@"HelveticaNeue-Thin" size:34]
#define kFontSizeLarge3_HT        [UIFont fontWithName:@"HelveticaNeue-Thin" size:26]
#define kFontSizeMedium_HT        [UIFont fontWithName:@"HelveticaNeue-Thin" size:14]

#define kFontSizeLarge5           [UIFont systemFontOfSize:55]
#define kFontSizeLarge4           [UIFont systemFontOfSize:34]
#define kFontSizeLarge3           [UIFont systemFontOfSize:26]
#define kFontSizeLarge2x          [UIFont systemFontOfSize:23]
#define kFontSizeLarge2           [UIFont systemFontOfSize:21]
#define kFontSizeLarge1           [UIFont systemFontOfSize:19]
#define kFontSizeLarge            [UIFont systemFontOfSize:16]
#define kBoldFontSizeLarge1       [UIFont boldSystemFontOfSize:19]
#define kBoldFontSizeLarge        [UIFont boldSystemFontOfSize:16]
#define kBoldFontSizeSmall        [UIFont boldSystemFontOfSize:12]
#define kFontSizeMedium           [UIFont systemFontOfSize:14]
#define kBoldFontSizeMedium       [UIFont boldSystemFontOfSize:14]
#define kFontSizeSmall            [UIFont systemFontOfSize:12]
#define kFontSizeSmall1           [UIFont systemFontOfSize:10]

// 按钮大小
#define kBackButtonSize         CGSizeMake(51, 44)

#define BannerHeight 160

#define DELAYSECONDS 300.0
#define GETTVSDELAY  10
#define REMOTESTATUSDELAY  5
#define SCREENDELAY  10


//首页




