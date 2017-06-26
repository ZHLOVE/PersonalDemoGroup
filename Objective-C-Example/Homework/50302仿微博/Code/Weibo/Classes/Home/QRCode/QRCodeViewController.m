//
//  QRCodeViewController.m
//  Weibo
//
//  Created by qiang on 4/26/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "QRCodeViewController.h"

#import <AVFoundation/AVFoundation.h>


@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

// 扫描图片 顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;

@property (weak, nonatomic) IBOutlet UIImageView *scanView;

// 扫描结果Label
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

// 扫描用到的4对象
// 扫描会话
@property (nonatomic,strong) AVCaptureSession *session;
// 输入设备
@property (nonatomic,strong) AVCaptureDeviceInput *inputDevice;
// 输出对象
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
// 预览层
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
// 绘制层
@property (nonatomic,strong) CALayer *drawLayer;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startAnimation];
    [self startScan];
}

- (IBAction)closeBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 扫描动画
- (void)startAnimation
{
    self.topCons.constant = -300;
    // 修改了约束 重新布局一下
    [self.scanView layoutIfNeeded];
    [UIView animateWithDuration:2.0 animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        self.topCons.constant = 0;
        [self.scanView.superview layoutIfNeeded];
    }];
}

#pragma mark - 懒加载 二维码所需要的4个对象
- (AVCaptureSession *)session
{
    if(_session == nil)
    {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureDeviceInput *)inputDevice
{
    if(_inputDevice == nil)
    {
//        NSLog(@"%@",AVMediaTypeVideo);
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        _inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if(error!= nil)
        {
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    return _inputDevice;
}

- (AVCaptureMetadataOutput *)output
{
    if(_output == nil)
    {
        _output = [[AVCaptureMetadataOutput alloc] init];
    }
    return _output;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if(_previewLayer == nil)
    {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _previewLayer;
}

- (CALayer *)drawLayer
{
    if(_drawLayer == nil)
    {
        _drawLayer = [CALayer layer];
    }
    return _drawLayer;
}

#pragma mark - 扫描二维码
- (void)startScan
{
    // 1. 判断能否将输入加入到会话
    if(![self.session canAddInput:self.inputDevice])
    {
        return;
    }
    
    // 2. 判断能否将输出加入到会话
    if(![self.session canAddOutput:self.output])
    {
        return;
    }
    
    // 3. 加入到会话
    [self.session addInput:self.inputDevice];
    [self.session addOutput:self.output];
    
    // 4. 设置能够解析的数据类型
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    NSLog(@"%@",self.output.availableMetadataObjectTypes);
    
    // 5. 设置输出的代理
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 6. 添加显示预览层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 绘制层
    [self.previewLayer addSublayer:self.drawLayer];
    
    // 7. 让session开始工作
    [self.session startRunning];
}

#pragma mark - 扫描结果输出代理

// 扫描到结果的时候
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 把之前的绘制的框移除
    [self clearDrawLayer];
    
    // 显示结果
    if( [[metadataObjects lastObject] isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
    {
        AVMetadataMachineReadableCodeObject *result = [metadataObjects lastObject];
        self.resultLabel.text = result.stringValue;
        NSLog(@"%@",result);
        
        // 转成坐标信息
        AVMetadataMachineReadableCodeObject *codeObject = [self.previewLayer transformedMetadataObjectForMetadataObject:result];
        NSLog(@"%@",codeObject);
        
        // 绘制
        [self drawConers:codeObject];
    }
    
}

// 进行绘制
- (void)drawConers:(AVMetadataMachineReadableCodeObject *)codeObject
{
    if(codeObject.corners == nil || codeObject.corners.count <1)
    {
        return;
    }
    
    // 1. 创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point;
    int index = 0;
    NSLog(@"%@",codeObject.corners);
    NSArray *corners = codeObject.corners;
    // 第一个点
    CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)corners[index++], &point);// 将 字典 -> CGPoint
    [path moveToPoint:point];
    // 其他点
    while(index<corners.count)
    {
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)corners[index++], &point);
        [path addLineToPoint:point];
    }
    // 封闭路径
    [path closePath];
    
    // 2. 绘制层
    // CAShapeLayer是CALayer类的之类类
    // 设定它路径，就会进行绘制
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 4;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = path.CGPath;
    
    [self.drawLayer addSublayer:shapeLayer];
}

// 移除之前创建的绘制图层
- (void)clearDrawLayer
{
    if(self.drawLayer.sublayers !=nil && self.drawLayer.sublayers.count > 0)
    {
        for(CALayer *layer in self.drawLayer.sublayers)
        {
            [layer removeFromSuperlayer];
        }
    }
    
}
@end
