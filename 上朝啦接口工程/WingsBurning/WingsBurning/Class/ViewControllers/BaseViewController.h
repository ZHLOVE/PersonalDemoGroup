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
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

#define ratio  [UIScreen mainScreen].bounds.size.height / 667
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height


@interface BaseViewController : UIViewController

@end
