//
//  AAPLPreviewView.m
//  ChatDemo
//
//  Created by yy on 15/10/23.
//  Copyright © 2015年 yy. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AAPLPreviewView.h"

@implementation AAPLPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}

@end
