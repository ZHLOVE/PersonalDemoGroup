//
//  MSJYShell.m
//  mugshot
//
//  Created by Venpoo on 15/9/6.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

#import "MSJYManager_OC.h"
#import "UIImage+RGBAConv.h"
#include "JY_FUN.h"


@interface MSJYManager_OC()

@end

@implementation MSJYManager_OC {
    JY_FUN suanfa;
    NSData* h_data;
    
    CAMPicContext* contentFun;
    CAMBuffer* buffertest;
}

+ (id)sharedInstance{
    static dispatch_once_t timer = 0;
    static id instance = nil;
    dispatch_once(&timer, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init {
    if(self=[super init]) {
        [self chuShiHua];
        buffertest = [CAMBuffer new];
    }
    return self;
}

-(void)chuShiHua {
    NSLog(@"初始化");
    NSString *fpath = [[NSBundle mainBundle] pathForResource:@"JY_FaceSDK" ofType:@"bin"];
    NSError *error;
    h_data = [NSData dataWithContentsOfFile:fpath
                                    options:NSDataReadingMappedAlways
                                      error:&error];
    if(error) {
        NSLog(@"%@", error);
    }
    suanfa.JY_Inin(h_data.bytes);
    NSLog(@"初始化 完成");
}

-(void)sheZhiCanShuWidth:(NSNumber*)idphotow
                  Height:(NSNumber*)idphotoh
                     RX1:(NSNumber*)ratiox1
                     RX2:(NSNumber*)ratiox2
                     RY1:(NSNumber*)ratioy1
                     RY2:(NSNumber*)ratioy2
                    new1:(NSNumber*)new1
                    new2:(NSNumber*)new2
                    new3:(NSNumber*)new3
                    new4:(NSNumber*)new4
                    new5:(NSNumber*)new5
                    new6:(NSNumber*)new6 {
    NSLog(@"设置参数");
    suanfa.JY_SetPhotoParam(idphotow.intValue,
                            idphotoh.intValue,
                            ratiox1.doubleValue,
                            ratiox2.doubleValue,
                            ratioy1.doubleValue,
                            ratioy2.doubleValue,
                            new1.doubleValue,
                            new2.doubleValue,
                            new3.doubleValue,
                            new4.doubleValue,
                            new5.doubleValue,
                            new6.doubleValue
                            );
    NSLog(@"设置参数 完成");
}

//获取缩放尺寸 :和 CGSize.autoSize 重复了
-(CGSize)checkSize:(CGSize)staticSize :(CGSize)targetSize {
    CGFloat targetScale = targetSize.width / targetSize.height;
    CGFloat usableScale = staticSize.width / staticSize.height;
    
    return (targetScale > usableScale ?
            CGSizeMake(staticSize.width, CGFloat(staticSize.width / targetScale)) :
            CGSizeMake(CGFloat(staticSize.height * targetScale), staticSize.height)
            );
}

#define MY_MAX_PIXELS CGSizeMake(720, 960)//800,800//960,1280
-(CAMPicContext *)renLianShu:(UIImage*)image {
    NSLog(@"计算人脸");
    if (image.size.width > MY_MAX_PIXELS.width || image.size.height > MY_MAX_PIXELS.height) {
        image = [image fixOrientationWithSize: [self checkSize:MY_MAX_PIXELS :image.size]];
    }
    contentFun = [[CAMPicContext alloc] initWithImg:image];
    [contentFun initOriBuf];
    
    uint8_t* gray = [contentFun.oriBuf getGray];
    int count = suanfa.JY_FaceLoc(gray, contentFun.oriBuf.width, contentFun.oriBuf.height);
    free(gray);
    if(count > 0) {
        contentFun.param[@"count"] = @(count);
    }
    NSLog(@"计算人脸 完成");
    return contentFun;
}

-(void)jiSuanKuang {
    NSLog(@"计算框");
    NSMutableDictionary *pp = contentFun.param;
    if(pp[@"count"] == nil || [pp[@"count"] intValue] == 0) {
        return;
    }
    suanfa.JY_Area();
    
    [self outPutDebugInfo];
    
    CGRect last = CGRectMake(
                             suanfa.rectangle[0],
                             suanfa.rectangle[1],
                             suanfa.rectangle[2] - suanfa.rectangle[0] + 1,
                             suanfa.rectangle[3] - suanfa.rectangle[1] + 1
                             );
    NSMutableArray *box = [NSMutableArray array];
    [box addObject:[NSValue valueWithCGRect: last]];
    
    //合成出最大的框后，偏移point端点
    last.origin.x = -last.origin.x;
    last.origin.y = -last.origin.y;
    
    //偏移端点为图片内嵌区域
    pp[@"area"] = [NSValue valueWithCGRect:last];
    pp[@"box"] = box;
    
    NSLog(@"pp.area:%@", [NSValue valueWithCGRect:last]);
    NSLog(@"计算框 完成");
}

-(void)sheZhiTuPian:(UIImage*)extImage {
    NSLog(@"设置图片");
    buffertest.ext32 = YES;
    [buffertest putImage:extImage];
    
    suanfa.JY_SetImg(buffertest.buf, buffertest.width, buffertest.height);
    
    NSLog(@"设置图片 完成");
}

-(void)daFeng {
    NSLog(@"打分");
    suanfa.JY_Judge_Env();
    NSMutableArray* _judge = [NSMutableArray array];
    [_judge addObject:@(suanfa.judgetwoFaces_)];
    [_judge addObject:@(suanfa.judgedim_)];
    [_judge addObject:@(suanfa.judgeBFSimilarity_)];
    [_judge addObject:@(suanfa.judgepositive_)];
    contentFun.param[@"judge"] = _judge;
    NSLog(@"打分 完成");
}

-(UIImage*)shengChengMask {
    NSLog(@"人脸分割");
    NSDictionary *pp = contentFun.param;
    if (pp[@"count"] == nil || [pp[@"count"]intValue] == 0) {
        return nil;
    }
    int width = buffertest.width;
    int height = buffertest.height;
    
    NSData *gray = [NSMutableData dataWithCapacity:(width*height + 3) / 4 * 4];//用4倍方便反色
    suanfa.JY_Segment((uint8_t*)gray.bytes);
    
    //反色
    uint32_t *p = (uint32_t*)gray.bytes;
    for (int i = 0; i < (width * height + 3) / 4; ++i, ++p) {
        *p = -1 - *p;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    NSUInteger bytesPerPixel = 1;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)gray);
    CGImageRef img = CGImageCreate(width, height,
                                   bitsPerComponent, bytesPerPixel*bitsPerComponent, bytesPerRow, colorSpace,
                                   0,provider, NULL, true, kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    
    UIImage* ret = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    CGDataProviderRelease(provider);
    
    NSLog(@"人脸分割 完成");
    return ret;
}

//没测试呢
-(UIImage*)meiYan:(double)_leye :(double)_reye :(double)_mouse :(double)_white :(double)_skin :(double)_coseye {
    NSLog(@"美颜");
    suanfa.JY_Cosmetology(_leye / 20.0, _reye / 20.0, _mouse / 20.0, _white, _skin / 50.0, _coseye /1.0);
    CAMBuffer* temp = [CAMBuffer new];
    temp.ext32 = YES;
    [temp putBuf:suanfa.psrc_ width:buffertest.width height:buffertest.height];
    UIImage* rtn = [temp getImage];
    [temp clear];
    NSLog(@"美颜 完成");
    return rtn;
}

-(void)jiSuanKuangAgain:(UIImage*)maskImg {
    NSLog(@"重新计算边框");
    NSMutableDictionary *pp = contentFun.param;
    if(pp[@"count"] == nil || [pp[@"count"] intValue] == 0) {
        return;
    }
    CAMBuffer* buffermask = [CAMBuffer new];
    buffermask.ext32 = YES;
    [buffermask putImage:maskImg];
    CGRect area = [contentFun.param[@"area"] CGRectValue];
    uint8_t* gray = [buffermask getJYGray];
    suanfa.JY_AdjustArea(gray, -area.origin.x, -area.origin.y);
    free(gray);
    [buffermask clear];
    
    [self zuiZhongKuang];
    
    [self outPutDebugInfo];
    
    NSLog(@"重新计算边框 完成");
}

-(NSArray*)zuiZhongKuang {
    NSMutableDictionary *pp = contentFun.param;
    if(pp[@"count"] == nil || [pp[@"count"] intValue] == 0) {
        return [NSArray new];
    }
    int res[4] = {0};
    suanfa.JY_GetDstArea(res);
    NSMutableArray *_box = [NSMutableArray array];
    CGRect rc = CGRectStandardize(
                                  CGRectMake(
                                             res[0],
                                             res[1],
                                             res[2]-res[0]+1,
                                             res[3]-res[1]+1
                                             )
                                  );
    [_box addObject:[NSValue valueWithCGRect:rc]];
    //NSLog(@"rectoutput:(%d, %d), (%d, %d)", res[0], res[1], res[2], res[3]);
    NSLog(@"rectoutput:%@", [NSValue valueWithCGRect:rc]);
    pp[@"final_box_eyrefree"] = _box;
    return _box;
}

-(void)shiFang {
    NSLog(@"释放");
    suanfa.JY_Free();
    NSLog(@"释放 完成");
}

-(void)outPutDebugInfo {
    //        for(int i = 0 ; i < 38; ++i){
    //            NSLog(@"aptFeat[%i]: (%i, %i)", i, suanfa.aptFeat[i].x, suanfa.aptFeat[i].y);
    //        }
    //        //坐标相对于原始输入图像的剪切框;
    //        for(int i=0;i<4*IDPHOTO_TYPES;i+=4){
    //            NSLog(@"suanfa rectangle: %i, %i, %i, %i", suanfa.rectangle[0 + i], suanfa.rectangle[1 + i], suanfa.rectangle[2 + i], suanfa.rectangle[3 + i]);
    //        }
    //        //最终输出的剪切框
    //        NSLog(@"suanfa rectoutput: %i, %i, %i, %i", suanfa.rectoutput[0], suanfa.rectoutput[1], suanfa.rectoutput[2], suanfa.rectoutput[3]);
    //        //一开始预裁剪得到的剪切框
    //        NSLog(@"suanfa rectoutput_org: %i, %i, %i, %i", suanfa.rectoutput_org[0], suanfa.rectoutput_org[1], suanfa.rectoutput_org[2], suanfa.rectoutput_org[3]);
    //
    //        int res[4]={0};
    //        suanfa.JY_GetDstArea(res);
    //        NSLog(@"suanfa JY_GetDstArea: %i, %i, %i, %i", res[0], res[1], res[2], res[3]);
}

-(CGSize) getOriArea {
    return contentFun.oriImg.size;
}

@end


