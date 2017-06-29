#ifndef _LQ_SHANGCHAOLA_
#define _LQ_SHANGCHAOLA_

#ifdef   __cplusplus
extern "C"{
#endif

/**
 * 初始化
 *
 * @param data [I] 数据文件
 * @return 成功返回0，失败返回非0
 */
    int   LQ_ShangChaoLa_Init(void const * data);


/**
 * 人脸检测
 *
 * @param _src [I] 图像数据灰度
 * @param _width [I] 图像宽度
 * @param _height [I] 图像高度
 * @return 返回人脸数目，当返回值不为1时，以下的各函数无意义
 */
    int  LQ_ShangChaoLa_FaceLoc(const unsigned char *_src,const int _width,const int _height);


/**
 * 获取人脸区域坐标
 *
 * @param rect [O], 人脸区域坐标，size为4×2.  rect[0...7]依次为lefttop_x,lefttop_y,right_top_x,right_top_y,leftbottom_x,leftbottom_y,rightbottom_x,rightbottom_y

 * @return 成功返回0,失败返回非0
 */
    int  LQ_ShangChaoLa_GetFaceRect(int rect[]);



/**
 * 获取人脸88个点的坐标
 *
 * @param 88pts[O] 人脸88个点的坐标，size为88×2.   88pts[0...175]依次为pt0_x,pt0_y,pt1_x,pt1_y.....pt87_x,pt87_y
 * @return 成功返回0,失败返回非0
 */
    int   LQ_ShangChaoLa_Get88Points(int pts88[]);

/**
 * 获取人脸姿态
 *
 * @param pose[O] 人脸姿态，size为3，依次为pitch(上下俯仰角度),yaw（左右侧脸角度）,roll（平面内旋转角度），各项取值范围均为-90～90，越接近于0，表示角度越小

 * @return 成功返回0,失败返回非0
 */
   int   LQ_ShangChaoLa_GetPose(int pose[]);


/**
 * 获取人脸光照程度
 *
 * @param light[O] 人脸光照程度，为0-100的整数，数值越大，表示光照越明亮
 * @return 成功返回0,失败返回非0
 */
    int   LQ_ShangChaoLa_GetLight(int* light);


/**
 * 获取眼睛和嘴巴开合程度
 *
 * @param eyemouth[O] 眼睛和嘴巴的开合程度，size为6，
 eyemouth[0]为左眼开合程度(0-1000)，eyemouth[1]为左眼开合程度的置信度(0-1000)
 eyemouth[2]为右眼开合程度(0-1000)，eyemouth[3]为右眼开合程度的置信度(0-1000)
 eyemouth[4]为嘴巴开合程度(0-1000)，eyemouth[5]为嘴巴开合程度的置信度(0-1000)
 * @return 成功返回0,失败返回非0
 */
    int   LQ_ShangChaoLa_GetEyeMouthOpen(int eyemouth[]);


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
    int   LQ_ShangChaoLa_Get9KeyPoints(int keypt[]);

#ifdef   __cplusplus
};
#endif   /*LQ_SHANGCHAOLA*/

#endif  