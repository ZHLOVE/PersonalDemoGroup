//
//  AAPLPreviewView.h
//  ChatDemo
//
//  Created by yy on 15/10/23.
//  Copyright © 2015年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface AAPLPreviewView : UIView

@property (nonatomic, strong) AVCaptureSession *session;

@end
