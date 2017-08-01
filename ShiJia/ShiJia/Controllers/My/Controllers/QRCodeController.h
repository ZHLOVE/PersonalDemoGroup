//
//  QRCodeController.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/27.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
//typedef void(^QRUrlBlock)(NSString *url);

@interface QRCodeController : BaseViewController
//@property (nonatomic, copy) QRUrlBlock qrUrlBlock;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL isGuide;
@end
