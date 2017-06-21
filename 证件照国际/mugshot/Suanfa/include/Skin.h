#include "SS_ImageForm.h"
#include "SS_Edge.h"

//#include<android/log.h>
#include "JY_Head.h"
#include <iostream>
#include <time.h>
using namespace std;
//����ṹ������
typedef struct tagParameter
{
	// /* �ⲿ���� */
	unsigned char *Lab_l ;		/* �����L��ʵ���� */
	unsigned char **Lab_a ;		/* ʵ���ҵ�ת���� */
	unsigned char **Lab_b ;		/* �̣��Σ�Ή�Q�Ʃ`�֥� */
	double *dSkinW ;				/* �ĸ�˹�˲����������� */
}*Parameter;
//������ȡ������������
typedef struct tagfaceareamask
{
	unsigned char *out_c ;	
	unsigned char *tmp_edge ;	
}*Facemask;

#define LAB_TBL_DIM 256
#define LAB_L_SHIFT   0	/* ��ƫ������ü���Ϊ��ı���������Χ�ڵ���Сֵ */
#define LAB_A_SHIFT 140	/* ��ƫ������ü���Ϊ��ı���������Χ�ڵ���Сֵ */
#define LAB_B_SHIFT 100	/*��ƫ������ü���Ϊ��ı���������Χ�ڵ���Сֵ */

#define PNM_CBRT(x) (OV_POW((x), (double)(1.0/3.0)))

#define SS_MINFACE 70
#define SS_LIMITED_MINFACE 50		/* ��ע�����ڵĴ�С����EdgeMask������С�ߴ����Ƶ���У�� */

#define  SIGMA_FACE 50 /* ��˹�˲���ϵ���ֵ������ */
#define REDUCE_PER 2 /* �ڲ�����sС��                   */
#define  EROSION_LOOP 1

#ifndef M_PI
#ifdef	PI
#define M_PI 	PI
#else
#define M_PI 3.14159265358979323846
#endif /* M_PI */
#endif
/* ���� */

#define GAMMA_INIT 2	/* ��ʼֵ٤�� */

#define EROSION_MIN_NUM 1 /* ƽ������������ */
#define EROSION_MAX_NUM 2 /* ƽ������������ */

#define EROSION_FACE 5

#define GAUSSIAN_MAX 8.0  /* ����˹�˲����� */
#define GAUSSIAN_MIN 2.0  /* ��С��˹�˲����� */

#define CURVE 200     /* ֵ����*/
#define ADD_PARAM 1.0 /* ��͸�����ۺ�ʵ�� */

#define NOHUE -1

#define X0 0.982
#define Y0 1.000
#define Z0 1.183

#define PARAM_LOWER 0.0
#define PARAM_UPPER 5.0

#define SS_MASKAREA 0.25
#define SS_GRADWIDTH 1.75

#define CUT_NUM 1 /* ��ɫ������ȡ���� */

#define STD_CLIP_L 5.0 /*����ֵ������ */
#define STD_CLIP_A 2.0
#define STD_CLIP_B 2.0

#define SAMPLE_CUT_SIZE 4 /* ȡ������С����*/

#define SS_EVALCENT (-1.0 / 3.0)


#define OVAL(x, y, a0, b0)	(((x)*(x))/((a0)*(a0))+((y)*(y))/((b0)*(b0)))

int InitLabTBL(Parameter parameter);
void CheckFacePoint(int width, int height,POINT *pt);
 double ss_normal( double x, double mu, double sigma );

 void ToneCurve(unsigned char *skin0_g,	int width,	SS_MASKRECT maskrt,int curve);
 double CalcGaussianSigma(FACEAREA *faceCorner,long faceNum,int width,int height,double base);
 void FreeSkinTBL(Parameter parameter);

 int InitSkinTBL(Parameter parameter);
 int Gaussian(unsigned char *org_c,int width,int height,unsigned char *skin_g,
	double sigma,SS_MASKRECT *maskrt,int faceNum,Parameter parameter);
int  FaceMaskSoftSkin(unsigned char *in_c,int width,int height,unsigned char *skin_g,RAWIMAGE *pEdgeMask,Facemask fackm,double sigma,	SS_MASKRECT *maskrt,int faceNum,Parameter parameter);
 int  FaceMaskSkin(unsigned char *in_c,int width,int height,unsigned char *tmp_edge,unsigned char *out_c,unsigned char*imageSmartSkin,double param);
 int SoftSkin(unsigned char *in_c,int width,int height,unsigned char *skin_g,RAWIMAGE *pEdgeMask,unsigned char *out_c,double param,double sigma,	SS_MASKRECT *maskrt,int faceNum,Parameter parameter);
void ReduceRect(FACEAREA *frect,FACEAREA *frect0,int faceNum,int per);

 void FreeLabTBL(Parameter parameter);
 int InitLabTBL(Parameter parameter);
 int ConvRGB2LAB(unsigned char *org0_p,int width, int height,unsigned char *lab0_p,Parameter parameter);
 int GetGradateArea( int width, int height, int l_eye_x, int l_eye_y, int r_eye_x, int r_eye_y,double ga_width,double ga_height,double ga_rage,	int nLUToval[],SS_MASKRECT *maskrt,unsigned char *image) ;
 void CutSampleRect(int *cut_w,int *cut_h,int *cutx,int *cuty,FACEAREA frect);


 int StatImage(unsigned char *lab_p,int cols, int rows,IMG8_RGB statzero,	
	double stndwidth, 	
	LAB_DATA *statcent,LAB_DATA *statstnd	
	,
	int LeiX);


 int EvalDist(unsigned char *in_p,int cols,int rows,LAB_DATA statcent,LAB_DATA weight,SS_MASKRECT maskrt,unsigned char *mask_g,unsigned char *dist_g);

 int CalcErosionNum(FACEAREA faceCorner,	int width,	int height);

 int ReviseSkin(unsigned char *skin_g,int width,int height,SS_MASKRECT maskrt,int num);


 void AddMask(unsigned char *all_skin_g,FACEAREA facert,	SS_MASKRECT maskrt,	unsigned char *mask_g,	int width,	unsigned char *skin_g);


 int ExtSkin(unsigned char *lab_p,int cols,int rows,FACEAREA *facerect,SS_MASKRECT *maskrt,int fnum,POINT *LEye,POINT *REye, int LeiX,unsigned char *all_skin_g);


 int ExtSkinAll(unsigned char *org_p,	int width, int height,FACEAREA frect[],int fnum,POINT *LEye,POINT *REye,SS_MASKRECT maskrt[],int LeiX,unsigned char *skin_g,Parameter parameter);







