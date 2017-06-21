#ifndef _JY_FUN_
#define _JY_FUN_
//#include "JY_Head.h"

#include "Common.h"

#include "SdkDT.h"
#include "SdkFPGE.h"
#include "JY_FaceSDK.h"
//#include "SdkFA.h"
#include "JudgeCharacter.h"

class JY_FUN
{
public:
	JY_FUN();
	~JY_FUN();
public:
	void JY_Init(void const * data );
	int  JY_FaceLoc(unsigned char *bgr,int _width,int _height);//人脸定位，返回人脸数
	
private:
	void JY_Free();
	void ResetValue();

public://判断值和框框
	int judgedim_;
	int nPitch;
	int nYaw;
	int nRoll;
	stDTResult   pResult_ ;
	POINT aptFA[88];
	POINT aptKeyPoints[9];

//private://句柄
	HANDLE_DT hdt ;
	HANDLE_FPGE  hfpge ;
	//HANDLE_FA FA;
	
private://人脸检测及其特征点定位
	POINT aptFeat[FPGE_FEATURE_KIND_MAX];
	POINT aptFeatureDetail[FPGEPS_FEATURE_NUM];


	INT32   nDetectFaceNum;
	FPGE_FACEINFO  sfi;
	FACEAREA face[1];
	int anConfidence[FPGE_FEATURE_KIND_MAX];

	int pnCenterX;
	int pnCenterY;
	int pnCenterZ ;
	int pnGazeLR;
	int pnGazeUD;
	int pnConfidenceGaze;

	int anConfidenceDetail[FPGEPS_FEATURE_NUM];

public:
	int pnLeftEyeOpenLevel;
	int pnRightEyeOpenLevel;
	int pnMouthOpenLevel;
	int pnLeftEyeOpenLevelConfidence;
	int pnRightEyeOpenLevelConfidence;
	int pnMouthOpenLevelConfidence;
};

#endif
