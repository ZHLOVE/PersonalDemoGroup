//conv2.h
#define  conv2     JY_00000
//edgeEnhance.h
#define  JY_EdgeEnhance     JY_00001
//EyeRep.h
#define  EyeRep     JY_00002
//FreckRe.h
#define  Allocate_Image_Byte     JY_00003
#define  Allocate_Image_Float     JY_00004
#define  Free_Image_Float     JY_00006
#define  ImgRGB2GRAY     JY_00007
#define  ImgSmoothGaussian     JY_00008
#define  ImageCumHist     JY_00009
#define  ImageHist     JY_00010
#define  ImgGradient    JY_00011
#define  ImgBinay    JY_00012
#define  ImgGradient_X_Y      JY_00013
#define  non_max_supp     JY_00014
#define  follow_edges     JY_00015
#define  apply_hysteresis     JY_00016
#define  Reinsidepolygon     JY_00017
#define  infacearea     JY_00018
#define  SS_MYErosionImage    JY_00019
#define  EnlargeFaceFreckleArea    JY_00020
#define  CCL_FindOuterRect    JY_00021
#define  CCL_Evaluate2RectOverlap     JY_00022
#define  CCL_RemoveBlobInArea     JY_00023
//generator.h
#define  computeNodeFeatures    JY_00024
#define  computeEdgeFeatures    JY_00025
#define  dist    JY_00026
#define  chisquared    JY_00027
//generatortex.h
#define  genTex     JY_00028
//HairCut.h
#define  detectHair     JY_00029
//Image.h
#define  ImgFree     JY_00030
#define  ImgRotate     JY_00031
#define  ImgBilinearReduce     JY_00032
#define  ImgConvertBMPtoRAW    JY_00033
#define  ImgResizeBound     JY_00034
#define  ImgClip     JY_00035
#define  ImgFastClip     JY_00036
#define  ImgFastClipToGray     JY_00037
#define  ImgConvertBGRtoGRAY    JY_00038
#define  ImgGammaCorrectGS     JY_00039
#define  ImgCalcAverageGS     JY_00040
//JY_CosmeticEye.h
#define  JY_CosmeticEye_CreateHandle     JY_00041
#define  JY_CosmeticEye_Change     JY_00042
#define  JY_CosmeticEye__DeteleHandle     JY_00043
//JY_FACE_EnhanceNoseT.h
#define JY_NoseIns_CreateNoseInsHandle      JY_00044
#define JY_NoseIns_EnhanceNoseT     JY_00045
#define JY_NoseIns_DeteleNoseInsHandle     JY_00046
//JY_FaceFreckleRemovSDK.h
#define JY_FaceFreckleRem_CreateFaceFreckleRemHandle      JY_00047
#define JY_FaceFreckle      JY_00048
#define JY_DeteleFaceFRECKHandle     JY_00049
#define JY_FaceFreckleRem     JY_00050
#define JY_FaceFreckleRem_DeteleFaceFreckleRemHandle     JY_00051
//JY_FaceLift.h
#define  JY_FaceLift_CreateHandle     JY_00052
#define  JY_FaceLift     JY_00053
#define  JY_FaceLift_DeteleHandle     JY_00054
//JY_Filter.h
#define   SetBright    JY_00055
#define   SetHueAndSaturation    JY_00056
//#define   SetHueAndSaturation    JY_00057
#define   JY_Filter   JY_00058
#define   curve    JY_00059
//JY_FUN.h
#define  JY_FUN					JY_000600
#define  JY_Inin				JY_000601
#define  JY_SetPhotoParam		JY_000602
#define  JY_FaceLoc				JY_000603
#define  JY_Area				JY_000604
#define  JY_SetImg				JY_000605
#define  JY_Judge_Env			JY_000606
#define  JY_Segment				JY_000607
#define  JY_Cosmetology			JY_000608
#define  JY_IsShoulderOK		JY_000609
#define  JY_AdjustArea			JY_000610
#define  JY_GetDstArea			JY_000611
#define  JY_Free				JY_000612
#define  JY_FaceLocMrg			JY_000613
#define  JY_AreaMrg				JY_000614
#define  JY_SetImgMrg			JY_000615
#define  JY_Judge_EnvMrg		JY_000616
#define  JY_SegmentMrg			JY_000617
#define  JY_CosmetologyLeft		JY_000618
#define  JY_CosmetologyRight	JY_000619
#define  JY_CosmetologyMrgTwo	JY_000620
#define  JY_AdjustAreaMrg		JY_000621
//JY_Nose.h
#define JY_Nose_handle      JY_00076
#define JY_Nose_Cos      JY_00077
#define JY_NOse_Free      JY_00078
//JY_OrganExaggerateSDK.h
#define   JY_OrganExaggerate_CreateOrganExHandle    JY_00079
#define   JY_OrganExaggerate_ONEChange    JY_00080
#define   JY_OrganExaggerate_DeteleOrganExHandle   JY_00081
//JY_Regiongrow.h
#define   JY_Hair_Handle     JY_00082
#define   JY_SegmentArea    JY_00083
#define   JY_IncreaseArea    JY_00084
#define   JY_DeleArea    JY_00085
#define   JY_HairCos    JY_00086
#define   JY_HairHighIncrease    JY_00087
#define   JY_HairHighDelete   JY_00088
#define   JY_FreeHandle   JY_00089
//JY_SmartSkinSDK.h
#define JY_SmartSkin_CreateSmartSkinWhHandle      JY_00090
#define  JY_SkinMask     JY_00091
#define  JY_DeteleFACEMASK     JY_00092
#define  JY_Skin     JY_00093
#define  JY_WhiteningSkin     JY_00094
#define  JY_SmartSkin_DeteleSmartSkinHandle     JY_00095
//JY_Smile.h
#define  JY_Smile     JY_00096
//JY_Whtooth.h
#define  JY_WHTOOTH_CreateHandle     JY_00097
#define  JY_WHTOOTH     JY_00098
#define  JY_WHTOOTH__DeteleHandle    JY_00099
//KeepCap.h
#define  initRealtimeContext      JY_00100
#define  getRealtimeContextSize     JY_00101
#define  freeRealtimeContext     JY_00102
#define  getFaceAttributes     JY_00103
//#define  getFaceAttributes     JY_00104
#define  getNumberOfFaces     JY_00105
//Skin.h
#define CheckFacePoint      JY_00106
#define ss_normal     JY_00107
#define ToneCurve    JY_00108
#define CalcGaussianSigma    JY_00109
#define FreeSkinTBL      JY_00110
#define InitSkinTBL      JY_00111
#define Gaussian      JY_00112
#define FaceMaskSoftSkin      JY_00113
#define FaceMaskSkin      JY_00114
#define SoftSkin     JY_00115
#define ReduceRect     JY_00116
#define FreeLabTBL     JY_00117
#define InitLabTBL     JY_00118
#define ConvRGB2LAB     JY_00119
#define GetGradateArea    JY_00120
#define CutSampleRect    JY_00121
#define StatImage    JY_00122
#define EvalDist    JY_00123
#define CalcErosionNum    JY_00124
#define ReviseSkin   JY_00125
#define AddMask    JY_00126
#define ExtSkin    JY_00127
#define ExtSkinAll    JY_00128
//SLIC.h
#define SLIC      JY_00129
#define DoSuperpixelSegmentation_ForGivenSuperpixelSize      JY_00130
#define DoSuperpixelSegmentation_ForGivenNumberOfSuperpixels     JY_00131
#define DoSupervoxelSegmentation      JY_00132
#define DrawContoursAroundSegments      JY_00133
//SS_Edge.h
#define MakeEdgeMask      JY_00134
//SS_ImageForm.h
#define AllocIMG8_RGB      JY_00135
#define FreeIMG8_RGB      JY_00136
//#define FreeIMG8_RGB      JY_00137
#define GetBGR_888      JY_00138
#define  ReduceImage8     JY_00139
#define  ReduceImageGray     JY_00140
#define  ExpandSkin8_GRAY     JY_00141
#define  ExpandSkin8_RGB     JY_00142
#define  ExpandSkin8_RGBx4     JY_00143
#define  DbgImgOutRawRGB     JY_00144
#define  DbgImgOutRawBGR     JY_00145
#define  DbgImgOutRawGray     JY_00146
#define  SS_ErosionImage     JY_00147
#define  SS_BlurImage     JY_00148
#define  SS_DilationImage     JY_00149
//JY_Certificate.h
#define  JY_Certificate     JY_00150
#define  JY_CertiArea       JY_00151
#define  JY_CertiGetAlpha    JY_00152
#define  JY_CertiDstArea     JY_00153
//matting.h
#define Matting      JY_00161
#define setSrc     JY_00162
#define setTrimap      JY_00163
#define solveAlpha     JY_00164
#define       JY_00165
#define       JY_00166
#define       JY_00167
#define       JY_00168
#define       JY_00169
#define       JY_00170
#define       JY_00171
#define       JY_00172
#define       JY_00173
#define       JY_00174
#define       JY_00175
#define       JY_00176
#define       JY_00177
#define       JY_00178
#define       JY_00179
#define       JY_00180
#define       JY_00181
#define       JY_00182
#define       JY_00183
#define       JY_00184
#define       JY_00185
#define       JY_00186
#define       JY_00187
#define       JY_00188
#define       JY_00189
#define       JY_00190
#define       JY_00191
#define       JY_00192
#define       JY_00193
#define       JY_00194
#define       JY_00195
#define       JY_00196
#define       JY_00197
#define       JY_00198
#define       JY_00199
