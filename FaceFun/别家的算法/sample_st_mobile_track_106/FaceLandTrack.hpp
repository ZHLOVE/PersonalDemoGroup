//
//  FaceLandTrack.hpp
//  FaceLandTrack
//
//  Created by WangSheng on 16/5/18.
//  Copyright © 2016年 ColorReco. All rights reserved.
//

#ifndef _COLOR_RECO_FACE_TRACK_HPP
#define _COLOR_RECO_FACE_TRACK_HPP

//人脸关键点追踪主要的接口

int FaceAlignInit_ColorReco();

bool FaceLandTrack_ColorReco(unsigned  char*gray_image_data,int width,int height,int* facebox,float *landmarkpos,float *pose);


//为了兼容 摄像头获取视频的方向 而改
bool FaceLandTrackCamera_ColorReco(unsigned char *gray_image_data,int width,int height,int ori,int* facebox,float *landmarkpos,float *pose);



//为了显示方便 将坐标系转回去
void UpdatePostionForShow(float *src,int ori,int width,int height);


// 拓展应用接口
float *GetLeftEyeShape(float *landmarkpos,int len);

float *GetRightEyeShape(float *landmarkpos,int len);

float *GetNoseLineShape(float *landmarkpos,int len);

float *GetNoseTipShape(float *landmarkpos,int len);

float *GetLeftEyeBrowShape(float *landmarkpos,int len);

float *GetRightEyeBrowShape(float *landmarkpos,int len);

float *GetMouseOutSideShape(float *landmarkpos,int len);

float *GetMouseInSideShape(float *landmarkpos,int len);

float *GetChinShape(float *landmarkpos,int len);


float GetEyeStatus(unsigned char *gray_image_data,int width,int height,float *landmark,float *eyescore);
float GetMouseStatus(float *landmark);


#endif /* FaceLandTrack_hpp */
