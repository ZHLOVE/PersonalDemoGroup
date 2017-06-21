#ifndef _JY_FUN_
#define _JY_FUN_
#include "JY_Head.h"
#include "JY_CosmeticEye.h"
#include "JY_FaceFreckleRemovSDK.h"
#include "JY_OrganExaggerateSDK.h"
#include "JY_SmartSkinSDK.h"

#include "SdkDT.h"
#include "SdkFPGE.h"
#include "JY_FaceSDK.h"
#include "SdkFA.h"
#include "JudgeCharacter.h"
#include "JY_Certificate.h"
#include "JY_FUN.h"


class JY_FUN
{
public:
	JY_FUN();
	~JY_FUN();
public:
	void JY_Inin(void const *data);//初始化
	void JY_SetPhotoParam(int idphotow,int idphotoh,double ratiox1,double ratiox2,double ratioy1,double ratioy2,
		                  double headlen1,double headlen2,double eyebtm1,double eyebtm2,double headtop1,double headtop2); //idphotow,idphotoh分别为最终宽高，ratio为人脸中心点距上下左右边缘的距离与双眼距离之比,后面6个参数为比例范围：头长/照片高度、眼睛到照片底部距离/照片高度、头发到照片顶部距离/照片高度
	int JY_FaceLoc(unsigned char *_src,int _width,int _height);//人脸定位，返回人脸数,
	void JY_Area();//1个
	void JY_SetImg(unsigned char *_src,int _width,int _height);//设置图片数据，同时根据五个框计算定位点相关信息
	void JY_Judge_Env();//四个判断值
	void JY_Segment(unsigned char *_dst);//分割
	void JY_Cosmetology(double _leye,double _reye,double _mouse,double _white,double _skin,double _coseye);//美化

	void JY_IsShoulderOK(
		const	int		orgwidth,	//(I) width of original image before clipping
		const	int		orgheight,	//(I) height of original image before clipping
		unsigned char const	*mask,	//(I) forground/background mask
		const	int		masktopX,
		const	int     masktopY,
		bool	boxok[]				//(O) size:IDPHOTO_TYPES(9), return whether the shoulder is OK under this size clipping(true:OK, false:Not OK), 
		);
void   JY_AdjustArea(
		unsigned char	const	*mask,							//(I) forground/background mask
		const	int		masktopX,
		const	int     masktopY
		);

void   JY_GetDstArea(int _rectoutput[]);   //(O)将最终剪切框输出add by zhou

void  JY_Free();//释放
public://判断值和框框
    //int rectangle[4*IDPHOTO_TYPES];  //坐标相对于原始输入图像的剪切框;
    int rectangle[4];
	POINT aptFeat[FPGE_FEATURE_KIND_MAX];
	POINT aptFeatureDetail[FPGEPS_FEATURE_NUM];
	int rectoutput[4]; //最终输出的剪切框
	int rectoutput_org[4];//一开始预裁剪得到的剪切框
	
public://剪切后的图片相关信息
	int height_;
	int width_;
	unsigned char *src_;
	unsigned char *dst_;
	unsigned char *psrc_;
	unsigned char *gary_;
	int judgepositive_;
	int judgedim_;
	int judgetwoFaces_;
	int judgeBFSimilarity_;
	IDPhotoInfo_t info_;


private://美化时使用的参数
	POINT aptFA[88];
	int LOpenLevel[1];
	POINT Leyeanum[4];
	int ROpenLevel[1];
	POINT Reyeanum[4];
	int MOpenLevel[1];
	POINT Mouseanum[4];
	FACEAREA face[1];
	POINT LEye[1];
	POINT REye[1];
private://句柄
	HANDLE_OrganEx  organEx_;
	HANDLE_SmartSkin ss_;
	HANDLE_FACEMASK facemask_;

	HANDLE_DT hdt ;
	HANDLE_FPGE  hfpge ;
	HANDLE_FA FA;
	
private://人脸检测及其特征点定位
	stDTResult   *pResult ;
	INT32   nDetectFaceNum;
	FPGE_FACEINFO  sfi;
	int anConfidence[FPGE_FEATURE_KIND_MAX];
	int nPitch;
	int nYaw;
	int nRoll;
	int pnCenterX;
	int pnCenterY;
	int pnCenterZ ;
	int pnGazeLR;
	int pnGazeUD;
	int pnConfidenceGaze;

	int anConfidenceDetail[FPGEPS_FEATURE_NUM];
	int pnLeftEyeOpenLevel;
	int pnRightEyeOpenLevel;
	int pnMouthOpenLevel;
	int pnLeftEyeOpenLevelConfidence;
	int pnRightEyeOpenLevelConfidence;
	int pnMouthOpenLevelConfidence;

private://rgb转灰度
	void ImgRGB2GRAY(unsigned char* src,int width,int height, unsigned char * dst);
    
    /******************************************************************************/
    //以下为结婚照
public:
    /*
     *  FaceLocMrg
     *  _src为原图图像，_width为原图宽，_height为原图高
     *  正常返回人脸数2
     */
    int  JY_FaceLocMrg(unsigned char *_src,int _width,int _height);
    
    /*
     *  获取剪切区域
     *  此函数会获取3个区域：rectangleMrg为两人合并框，rectLeftPerson为左边人框，rectRightPerson为右边人框
     */
    void JY_AreaMrg();
    /*
     *  SetImg
     *  _src为从原图上裁剪出来的rectangleMrg区域，_width为rectangleMrg宽，_height为rectangleMrg高
     */
    int  JY_SetImgMrg(unsigned char *_src,int _width,int _height);
    /*
     *  环境判断
     *  对 judgedim_，judgetwoFaces_，judgeBFSimilarity_，judgeHeightDifference_和judgeDistanceDifference_共5个环境条件作出判断（0-100）
     */
    void JY_Judge_EnvMrg();
    /*
     *  获取mask区域
     *  _dst的尺寸为rectangleMrg
     */
    void JY_SegmentMrg(unsigned char *_dst);
    
    /*
     *  美颜-左边人
     *  此函数执行完之后，psrcLeftPerson_里是左边人美颜之后的图像
     */
    void JY_CosmetologyLeft(double _leye,double _reye,double _mouse,double _white,double _skin,double _coseye);
    
    /*
     *  美颜-右边人
     *  此函数执行完之后，psrcRightPerson_里是左边人美颜之后的图像
     */
    void JY_CosmetologyRight(double _leye,double _reye,double _mouse,double _white,double _skin,double _coseye);
    
    /*
     *  美颜-合并
     *  此函数执行完之后，psrc_里是两人合并之后的图像（无论是美化了哪个人，都是从psrc_里取两人合并的图像）
     */
    void JY_CosmetologyMrgTwo();
    
    /*
     * 最终调整输出区域
     */
    void JY_AdjustAreaMrg(
                          unsigned char	const	*mask,							//(I) forground/background mask
                          const	int		masktopX,
                          const	int     masktopY);
private:
    void ResetMemory();
public:
    int rectangleMrg[4];  //两个人合并框;
    int rectLeftPerson[4];  //左边人框
    int rectRightPerson[4]; //右边人框
    POINT aptFeatMrg[FPGE_FEATURE_KIND_MAX*2];
    POINT aptFeatureDetailMrg[FPGEPS_FEATURE_NUM*2];
    unsigned char *srcLeftPerson_;//左边人原图像
    unsigned char *dstLeftPerson_; //左边人mask
    unsigned char *psrcLeftPerson_; //左边人美颜
    unsigned char *srcRightPerson_;//右边人原图像
    unsigned char *dstRightPerson_; //右边人mask
    unsigned char *psrcRightPerson_; //右边人美颜
    int judgeHeightDifference_;  //身高差判断
    int judgeDistanceDifference_; //距离判断
private:
    int widthL;  //左边人图像宽度
    int heightL; //左边人图像高度
    int widthR;  //右边人图像宽度
    int heightR; //右边人图像高度
private://美化时使用的参数
    POINT aptFAMrg[88*2];
    int LOpenLevelMrg[1*2];
    POINT LeyeanumMrg[4*2];
    int ROpenLevelMrg[1*2];
    POINT ReyeanumMrg[4*2];
    int MOpenLevelMrg[1*2];
    POINT MouseanumMrg[4*2];
    FACEAREA faceMrg[1*2];
    POINT LEyeMrg[1*2];
    POINT REyeMrg[1*2];
    int pnLeftEyeOpenLevelMrg[2];
    int pnRightEyeOpenLevelMrg[2];
    int pnMouthOpenLevelMrg[2];

};
#endif
