//
//  JYManager.m
//
//  Created by M on 16/9/5.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "JYManager.h"


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
    }
    return self;
}

/**
 *  初始化
 */
-(void)chuShiHua {
    NSError *error;
    NSString *fpath = [[NSBundle mainBundle] pathForResource:@"JY_FaceSDK" ofType:@"bin"];
    h_data = [NSData dataWithContentsOfFile:fpath options:NSDataReadingMappedAlways error:&error];
    if(error) {NSLog(@"%@", error);}
    LQ_ShangChaoLa_Init(h_data.bytes);
    NSLog(@"初始化 完成");
}

/**
 *  人脸数
 *
 *  @return int
 */
#define MY_MAX_PIXELS CGSizeMake(720, 960)//800,800//960,1280
- (int)renLianShu:(UIImage *)image {
    int count = 0;
    UIImage *img  = image;
    if (img.size.width > MY_MAX_PIXELS.width || img.size.height > MY_MAX_PIXELS.height) {
        img = [img fixOrientationWithSize: [self checkSize:MY_MAX_PIXELS :img.size]];
    }
    contentFun = [[CAMPicContext alloc] initWithImg:img];
    [contentFun initOriBuf];
    uint8_t* gray = [contentFun.oriBuf getGray];
    int width = contentFun.oriBuf.width;
    int height = contentFun.oriBuf.height;
//    NSLog(@"计算人脸%d %d",contentFun.oriBuf.width, contentFun.oriBuf.height);
    count = LQ_ShangChaoLa_FaceLoc(gray, width, height);
    free(gray);
    return count;
}

//获取缩放尺寸 :和 CGSize.autoSize 重复了

-(CGSize)checkSize:(CGSize)staticSize :(CGSize)targetSize {
    CGFloat targetScale = targetSize.width / targetSize.height;
    CGFloat usableScale = staticSize.width / staticSize.height;

    if (targetScale > usableScale) {
        return CGSizeMake(staticSize.width, staticSize.width / targetScale );
    }else{
        return CGSizeMake(staticSize.height * targetScale, staticSize.height);
    }
}


/**
 *  人脸区域坐标
 */
- (void)renLianQuYuZuoBiao:(int [])rect{
//    int rect[8];
    LQ_ShangChaoLa_GetFaceRect(rect);
}

/**
 * 获取人脸88个点的坐标
 *
 * @param 88pts[O] 人脸88个点的坐标，size为88×2.   88pts[0...175]依次为pt0_x,pt0_y,pt1_x,pt1_y.....pt87_x,pt87_y
 * @return 成功返回0,失败返回非0
 */
//88个点的x坐标是point[N*2]，y坐标是point[N*2+1]，N为参考图上的序号
- (void)renLian88Points:(int [])rect{
    //此接口暂时废弃
}

/**
 * 获取人脸姿态
 *
 * @param pose[O] 人脸姿态，size为3，依次为pitch(上下俯仰角度),yaw（左右侧脸角度）,roll（平面内旋转角度），各项取值范围均为-90～90，越接近于0，表示角度越小

 * @return 成功返回0,失败返回非0
 */
- (void)renLianZiTai:(int [])rect{
    LQ_ShangChaoLa_GetPose(rect);
}

/**
 * 获取人脸光照程度
 *
 * @param light[O] 人脸光照程度，为0-100的整数，数值越大，表示光照越明亮
 * @return 成功返回0,失败返回非0
 */
//int   LQ_ShangChaoLa_GetLight(int* light);
- (void)renLianGuangZhao:(int *)light{
    LQ_ShangChaoLa_GetLight(light);
}

/**
 * 获取眼睛和嘴巴开合程度
 *
 * @param eyemouth[O] 眼睛和嘴巴的开合程度，size为6，
 eyemouth[0]为左眼开合程度(0-1000)，eyemouth[1]为左眼开合程度的置信度(0-1000)
 eyemouth[2]为右眼开合程度(0-1000)，eyemouth[3]为右眼开合程度的置信度(0-1000)
 eyemouth[4]为嘴巴开合程度(0-1000)，eyemouth[5]为嘴巴开合程度的置信度(0-1000)
 * @return 成功返回0,失败返回非0
 */
- (void)yanJingZuiBaKaiHeDu:(int [])rect{
    LQ_ShangChaoLa_GetEyeMouthOpen(rect);
}


/**
 * 获取人脸9个关键特征点
 *
 * @param keypt[O] 人脸9个关键特征点坐标，size为18，

 （keypt[0],keypt[1]）为左眼内眼角坐标
 （keypt[2],keypt[3]）为左眼外眼角坐标
 （keypt[4],keypt[5]）为左眼中间点坐标
 （keypt[6],keypt[7]）为右眼内眼角坐标
 （keypt[8],keypt[9]）为右眼外眼角坐标
 （keypt[10],keypt[11]）为右眼中间点坐标
 （keypt[12],keypt[13]）为左边嘴角坐标
 （keypt[14],keypt[15]）为右边嘴角坐标
 （keypt[16],keypt[17]）为嘴巴中间点坐标

 * @return 成功返回0,失败返回非0
 */
- (void)renLianGuanJianDian:(int [])keypt{
    LQ_ShangChaoLa_Get9KeyPoints(keypt);
}
@end























