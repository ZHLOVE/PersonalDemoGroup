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
 * @param _src [I] 灰度图像数据
 * @param _width [I] 图像宽度
 * @param _height [I] 图像高度
 * @return 返回人脸数目
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


#ifdef   __cplusplus
};
#endif   /*LQ_SHANGCHAOLA*/

#endif  