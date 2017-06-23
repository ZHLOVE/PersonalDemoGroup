//
//  JYManager.h
//  SafeDarkVC
//
//  Created by M on 16/6/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Rotate.h"
#import "CAMPicContext.h"
#import "CAMBuffer.h"
#import "UIImage+RGBAConv.h"
#import "LQ_ShangChaoLa.h"


@interface JYManager : NSObject

/**
 *  初始化
 */
+ (id)sharedInstance;
/**
 *  人脸数
 *
 *  @return int
 */
- (int)renLianShu:(UIImage *)image;

/**
 * 获取人脸区域坐标
 *
 * @param rect [O], 人脸区域坐标，size为4×2.  rect[0...7]依次为lefttop_x,lefttop_y,right_top_x,right_top_y,leftbottom_x,leftbottom_y,rightbottom_x,rightbottom_y
 */
- (void)renLianQuYuZuoBiao:(int [])rect;

/**
 * 获取人脸88个点的坐标
 *
 * @param 88pts[O] 人脸88个点的坐标，size为88×2.   88pts[0...175]依次为pt0_x,pt0_y,pt1_x,pt1_y.....pt87_x,pt87_y
 */

- (void)renLian88Points:(int [])rect;

/**
 * 获取人脸姿态
 *
 * @param pose[O] 人脸姿态，size为3，依次为pitch(上下俯仰角度),yaw（左右侧脸角度）,roll（平面内旋转角度），各项取值范围均为-90～90，越接近于0，表示角度越小
 */
- (void)renLianZiTai:(int [])rect;

/**
 * 获取人脸光照程度
 *
 * @param light[O] 人脸光照程度，为0-100的整数，数值越大，表示光照越明亮
 */
- (void)renLianGuangZhao:(int *)light;



/**
 * 获取眼睛和嘴巴开合程度
 *
 * @param eyemouth[O] 眼睛和嘴巴的开合程度，size为6，
 eyemouth[0]为左眼开合程度(0-1000)，eyemouth[1]为左眼开合程度的置信度(0-1000)
 eyemouth[2]为右眼开合程度(0-1000)，eyemouth[3]为右眼开合程度的置信度(0-1000)
 eyemouth[4]为嘴巴开合程度(0-1000)，eyemouth[5]为嘴巴开合程度的置信度(0-1000)
 */
- (void)yanJingZuiBaKaiHeDu:(int [])rect;


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
- (void)renLianGuanJianDian:(int [])keypt;
@end






