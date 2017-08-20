//
//  MRVC.m
//  MccReeDemo
//
//  Created by MccRee on 2017/8/5.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "MRVC.h"
#import "CameraVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import "KrVideoPlayerController.h"
#import "UIImage+Rotate.h"



#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height
@interface MRVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>



@property(nonatomic,strong) UIButton *photoBtn;
@property(nonatomic,strong) UIButton *cameraBtn;
@property(nonatomic,strong) UIImageView *imgView;

@property(nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) KrVideoPlayerController  *videoController;

@property(nonatomic,copy)void(^videoOutPutBlock)(CMSampleBufferRef sampleBuffer);


@end

@implementation MRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.photoBtn];
    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.imgView];
}






//选择完图片后会回调 didFinishPickingMediaWithInfo 这个方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    CameraVC *cam = [[CameraVC alloc]init];
    UIImage *oriImg = info[@"UIImagePickerControllerOriginalImage"];
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ( [mediaType isEqualToString:@"public.movie" ])
    {
        NSURL *url =  [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@">>>>>>>\n %@", [url absoluteString]);
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self addVideoPlayerWithURL:url];
        __weak typeof(self) weakSelf = self;
        self.videoOutPutBlock = ^(CMSampleBufferRef sampleBuffer) {
            UIImage *image = [weakSelf newImageFromSampleBuffer:sampleBuffer];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.imgView setImage:image];
                [weakSelf.view setNeedsDisplay];
            });

        };
    }else{
        [self.imgView setImage:[cam grayImageFromImage:oriImg]];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)addVideoPlayerWithURL:(NSURL *)url{
    if (!self.videoController) {
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(W/2, H-W, W/2, W)];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
    
    AVURLAsset* asset = [AVURLAsset assetWithURL:url];
    NSError* errReader=nil;
    AVAssetReader* reader = [AVAssetReader assetReaderWithAsset:asset error:&errReader];
    if(!errReader){
        AVAssetTrack* track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        AVAssetReaderOutput* readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:nil];
        [reader addOutput:readerOutput];
        [reader startReading];
        long long count = 0;
        BOOL isAvailable = NO;
        do {
            CMSampleBufferRef ref = [readerOutput copyNextSampleBuffer];
            _videoOutPutBlock(ref);
            if(ref){
                isAvailable = YES;
                count++;
            }else{
                isAvailable = NO;
            }
        } while (isAvailable == YES);
        NSLog(@"Total Frames in your Video is %@",@(count));
    }else{
        NSLog(@"\nAVAssetReaderError:\n%@",errReader.localizedDescription);
    }
}


/**
 sampleBuffer转UIImage
 */
- (UIImage *)newImageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    //获取灰度图像数据
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    uint8_t *lumaBuffer  = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    //byt * height
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer,0);
    size_t width  = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context=CGBitmapContextCreate(lumaBuffer, width, height, 8, bytesPerRow, grayColorSpace,0);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    UIImage *img = [UIImage imageWithCGImage:cgImage];
    UIImage *tempimage = [img rotate:UIImageOrientationRight];//旋转
    UIImage *image = [tempimage flipHorizontal];//镜像翻转
    CGImageRelease(cgImage);
    CGContextRelease(context);
    CGColorSpaceRelease(grayColorSpace);
    return image;
}


//导航条上面的 Cancel 的点击方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)gotoPhoto{
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)gotoCamera{
    CameraVC *cam = [[CameraVC alloc]init];
    [self.navigationController pushViewController:cam animated:YES];
}






- (UIButton *)photoBtn{
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 40)];
        [_photoBtn setTitle:@"相册" forState:UIControlStateNormal];
        _photoBtn.backgroundColor = [UIColor lightGrayColor];
        [_photoBtn addTarget:self action:@selector(gotoPhoto) forControlEvents:UIControlEventTouchUpInside];

    }
    return _photoBtn;
}

- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(W-120, 100, 100,40)];
        [_cameraBtn setTitle:@"摄像头" forState:UIControlStateNormal];
        _cameraBtn.backgroundColor = [UIColor lightGrayColor];
        [_cameraBtn addTarget:self action:@selector(gotoCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, H-W, W/2, W)];
        _imgView.layer.borderWidth = 1;
        _imgView.layer.borderColor = [UIColor blackColor].CGColor;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _imagePicker.sourceType = sourceType;
        _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];

    }
    return _imagePicker;
}

@end
