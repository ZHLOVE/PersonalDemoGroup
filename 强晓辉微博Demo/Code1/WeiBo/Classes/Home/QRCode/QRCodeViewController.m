//
//  QRCodeViewController.m
//  WeiBo
//
//  Created by student on 16/4/26.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "QRCodeViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UIImageView *scanView;
//扫描用到的3个对象
//会话
@property(nonatomic,strong)AVCaptureSession *session;
//输入
@property(nonatomic,strong) AVCaptureDeviceInput *inputDevice;
//输出对象
@property(nonatomic,strong)AVCaptureMetadataOutput *output;

//预览层对象
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;

//绘制层 放在preview层上
@property(nonatomic,strong)CALayer *drawLayer;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self startAnimation];
    [self startScan];
}

- (void)startAnimation{
    self.width.constant = [UIScreen mainScreen].bounds.size.width;
     self.height.constant = [UIScreen mainScreen].bounds.size.width;
    self.topCons.constant = -300;
    // 修改了约束 重新布局一下
    [self.scanView layoutIfNeeded];
    [UIView animateWithDuration:2.0 animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        self.topCons.constant = 0;
        [self.scanView.superview layoutIfNeeded];
    }];
}

#pragma mark 懒加载二维码所需要的4个对象
- (AVCaptureSession *) session{
    if ( _session == nil) {
        _session = [[AVCaptureSession alloc]init];
    }
    return _session;
}

- (AVCaptureDeviceInput *)inputDevice{
    if (_inputDevice == nil) {
        AVCaptureDevice *device =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];//得到设备
        //再得到设备的输入
        NSError *error;
       _inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (error != nil) {
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    return _inputDevice;
}

- (AVCaptureMetadataOutput *)output{
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc]init];
    }
    return _output;
}

- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _previewLayer;
}

- (CALayer *)drawLayer{
    if (_drawLayer == nil) {
        _drawLayer = [CALayer layer];
    }
    return _drawLayer;
}

#pragma mark -扫描二维码
- (void)startScan{
    // 1判断能否将输入加入到会话
    if (![self.session canAddInput:self.inputDevice]) {
        return;
    }
    // 2能否将输出加入到会话
    if (![self.session canAddOutput:self.output]) {
        return;
    }
    //3 加入到会话
    [self.session addInput:self.inputDevice];
    [self.session addOutput:self.output];
    
    //4 设置能投解析的数据类型（限制二维码，条形码等）
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    NSLog(@"%@",self.output.availableMetadataObjectTypes);
    //5 设置输出的代理
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //6添加预览层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    //绘制层
    [self.previewLayer addSublayer:self.drawLayer];
    //7 让session开始工作
    [self.session startRunning];
    
}

#pragma mark -代理方法
//扫描到结果的时候
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //把之前绘制的框清除掉
    [self clearDrawLayer];
    //扫描到的二维码信息
    if ([[metadataObjects lastObject] isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        AVMetadataMachineReadableCodeObject *result = [metadataObjects lastObject];
        self.resultLabel.text = result.stringValue;
        NSLog(@"二维码信息%@",result);
        //转换坐标信息
        AVMetadataMachineReadableCodeObject *codeObject = [self.previewLayer transformedMetadataObjectForMetadataObject:result];
        NSLog(@"坐标信息%@",codeObject);
        //绘制
        [self drawConers:codeObject];
    }
}

//进行绘制
- (void)drawConers:(AVMetadataMachineReadableCodeObject *)codeObject{
    if (codeObject.corners == nil ||codeObject.corners.count<1) {
        return;
    }
    //1 创建路径
    //贝塞尔曲线路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point;//点
    int index = 0;//当前第几个点
    NSLog(@"%@",codeObject.corners);
    NSArray *corners = codeObject.corners;
    //第一个点
    CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)corners[index++], &point);//将字典转CGPoint
    [path moveToPoint:point];
    //其他点
    while (index<corners.count) {
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)corners[index++], &point);
        [path addLineToPoint:point];
    }
    [path closePath];//封闭路径
     CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 4;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.drawLayer addSublayer:shapeLayer];
}

- (void)clearDrawLayer{
    if (self.drawLayer.sublayers != nil||self.drawLayer.sublayers.count>0) {
        for (CALayer *layer in self.drawLayer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
}

@end
