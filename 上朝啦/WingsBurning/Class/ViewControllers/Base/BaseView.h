//
//  BaseView.h
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Create.h"
#import "UILabel+Creation.h"
#import "UIColor+HexColor.h"
#import "NetModel.h"
#import "Verify.h"
#import "HJCornerRadius.h"
#import "UIImage+SubImage.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#define ratio  [UIScreen mainScreen].bounds.size.height / 667
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height



#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

@interface BaseView : UIView

- (void)loadUI;

@end
