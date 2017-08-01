//
//  HotSpotAlertView.h
//  ShiJia
//
//  Created by 峰 on 2017/2/25.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HotSpotShareViewBlock)(id sender,NSString *text);

@interface HotSpotAlertView : UIView

@property (nonatomic, copy) HotSpotShareViewBlock shareViewBlock;
@property (nonatomic, strong) NSString         *title;
@property (nonatomic, strong) NSString         *content;
@property (nonatomic, strong) NSArray          *buttonTtileArray;
@property (nonatomic, strong) UIColor          *cancelColor;
@property (nonatomic, strong) UIColor          *deterColor;
@property (nonatomic, strong) UIImage          *alertImage;
@property (nonatomic, strong) NSString         *alertImageString;
@property (nonatomic) BOOL showMessage;

@property (nonatomic, assign) NSInteger socailType;

+ (instancetype)alertViewDefault;
- (void)show;
@end
