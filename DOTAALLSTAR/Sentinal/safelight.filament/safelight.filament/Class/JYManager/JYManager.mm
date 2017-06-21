//
//  JYManager.m
//  SafeDarkVC
//
//  Created by M on 16/6/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "JYManager.h"
#import "JY_IDPhoto.h"
#import "UIImage+RGBAConv.h"


@implementation JYManager

NSData* h_data;
CAMPicContext* contentFun;
CAMBuffer* buffertest;

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

/**
 *  初始化
 */
-(void)chuShiHua {
//    NSLog(@"初始化");
    NSError *error;

    NSString *fpath = [[NSBundle mainBundle] pathForResource:@"JY_FaceSDK" ofType:@"bin"];

    h_data = [NSData dataWithContentsOfFile:fpath
                                    options:NSDataReadingMappedAlways
                                      error:&error];
    if(error) {
        NSLog(@"%@", error);
    }
    JY_IDPhoto_Init(h_data.bytes);
//    NSLog(@"初始化 完成");
}

/**
 *  计算人脸数
 *
 */
#define MY_MAX_PIXELS CGSizeMake(720, 960)//800,800//960,1280
-(int)renLianShu:(UIImage*)image {
//    NSLog(@"计算人脸");
    if (image.size.width > MY_MAX_PIXELS.width || image.size.height > MY_MAX_PIXELS.height) {
        UIImage *tempImg = [image fixOrientationWithSize: [self checkSize:MY_MAX_PIXELS :image.size]];
        //todo:这里有问题的哦
        if (nil != tempImg) {
            image = tempImg;
        }
    }
    contentFun = [[CAMPicContext alloc] initWithImg:image];
    [contentFun initOriBuf];

    uint8_t* gray = [contentFun.oriBuf getGray];
    int count = 0;
    count = JY_IDPhoto_FaceLoc(gray, contentFun.oriBuf.width, contentFun.oriBuf.height);
    free(gray);
    if(count > 0) {
        contentFun.param[@"count"] = @(count);
    }
//    NSLog(@"计算人脸 完成");
    return count;
//    return contentFun;
}

/**
 *  计算区域
 */
-(void)jiSuanKuang {
//    NSLog(@"计算框");
    NSMutableDictionary *pp = contentFun.param;
    if(pp[@"count"] == nil || [pp[@"count"] intValue] == 0) {
        return;
    }
    CGRect last;
    int rectLeftPerson[4];  //左边人框
    JY_IDPhoto_GetArea(rectLeftPerson);
    last = CGRectMake(
                      rectLeftPerson[0],
                      rectLeftPerson[1],
                      rectLeftPerson[2] - rectLeftPerson[0] + 1,
                      rectLeftPerson[3] - rectLeftPerson[1] + 1
                      );
    NSMutableArray *box = [NSMutableArray array];
    [box addObject:[NSValue valueWithCGRect: last]];

    //合成出最大的框后，偏移point端点
    last.origin.x = -last.origin.x;
    last.origin.y = -last.origin.y;

    //偏移端点为图片内嵌区域
    pp[@"area"] = [NSValue valueWithCGRect:last];
    pp[@"box"] = box;

//    NSLog(@"pp.area:%@", [NSValue valueWithCGRect:last]);
//    NSLog(@"计算框 完成");
}

/**
 *  设置图片
 */
-(void)sheZhiTuPian:(UIImage*)extImage {
//    NSLog(@"设置图片");
    buffertest.ext32 = YES;
    [buffertest putImage:extImage];
    JY_IDPhoto_SetImg(buffertest.buf, buffertest.width, buffertest.height);
//    NSLog(@"设置图片 完成");
}

/**
 *  打分
 */
-(NSArray *)daFeng {
//    NSLog(@"打分");
    int judgepositive_ = 0;
    int judgedim_;
    int judgetwoFaces_;
    int judgeBFSimilarity_;
//    int judgeHeightDifference_ = 0;
//    int judgeDistanceDifference_ = 0;
    //单人照环境判断
    JY_IDPhoto_EnvJudge(&judgepositive_,&judgedim_,&judgetwoFaces_,&judgeBFSimilarity_);
    NSMutableArray* _judge = [NSMutableArray array];
    [_judge addObject:@(judgetwoFaces_)];
    [_judge addObject:@(judgedim_)];
    [_judge addObject:@(judgeBFSimilarity_)];
    [_judge addObject:@(judgepositive_)];
//    NSLog(@"打分 完成");
    return _judge;

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
@end
