#include <iostream>
#include "Common.h"
#include "CCL.h"
#include "JY_Head.h"
using namespace std;

typedef struct tagFaceFreckle
{
	unsigned char *FreckleRemImg;
	int *nTopY;
	int *nButY; 
	int *nTopX;
	int *nButX;
}*PaFaceFreckle;
struct BLOB_List_tag
{
	int  nLeft;
	int  nRight;
	int  nTop;
	int  nBottom;
	int  nPixNum;

	BOOL  bFlagUsed ;
	int   nValSum;
	int   nHighPixNum;

};
typedef  struct  BLOB_List_tag   BLOB_List;



int Free_Image_Byte(unsigned char* arrImg,int iHeight, int iWidth)
{
	free(arrImg);
	return 0;
}
unsigned char* Allocate_Image_Byte(int iHeight, int iWidth,int deps)
{
	unsigned char* arrImg = NULL;

	arrImg = (unsigned char*) malloc(iHeight *iWidth*deps* sizeof(unsigned char));

	memset(arrImg ,0,iHeight* iWidth*deps*sizeof (unsigned char));/* initialize */

	return arrImg;
}
float* Allocate_Image_Float(int iHeight, int iWidth,int deps)
{
	float* arrImg = NULL;

	arrImg = (float*) malloc(iHeight *iWidth*deps* sizeof(float));

	memset(arrImg ,0,iHeight* iWidth*deps*sizeof (float));/* initialize */

	return arrImg;
}
int Free_Image_Float(float* arrImg,int iHeight, int iWidth)
{
	free(arrImg);
	return 0;
}
void ImgRGB2GRAY(unsigned char* arrRGBImg,int iHeight, int iWidth,int nStep, unsigned char* arrGrayImg)
{
	int i,j,R,G,B;
	int Rw = 299;
	int Gw = 587;
	int Bw = 114;
	for ( i =0 ;i<iHeight; i++)
	{
		for (j =0;j<iWidth;j++)
		{
			B = arrRGBImg[i*nStep+j*3];
			G = arrRGBImg[i*nStep+j*3+1];
			R = arrRGBImg[i*nStep+j*3+2];
			arrGrayImg[i*iWidth + j] =(R*Rw + G*Gw + B*Bw + 500)/1000;
		}
	}
}

//smooth by sigma=1 gaussian filter;
//3x3 filter
void ImgSmoothGaussian(BYTE *pGrayImg, int iHeight, int  iWidth,BYTE *pGraySmoothImg)
{
	const int Gauw[] = {22, 104, 22, 104, 496, 104, 22, 104, 22};  //sum of weight is 1000;
	//const int GauHalfW = 1;
	int  x, y, idx;
	int  wsum;
	for  (y = 0; y<iHeight; y++) {
		idx = y*iWidth;
		pGraySmoothImg[idx] = pGrayImg[idx];
		idx = idx + iWidth-1;
		pGraySmoothImg[idx] = pGrayImg[idx];
	}
	idx = (iHeight-1)*iWidth ;
	for  (x = 0; x<iWidth; x++) {
		pGraySmoothImg[x] = pGrayImg[x];
		pGraySmoothImg[idx+x] = pGrayImg[idx+x];
	}

	for  (y = 1; y<iHeight-1; y++) {
		idx = y*iWidth + 1;
		for  (x= 1; x<iWidth-1; x++, idx++) {
			wsum = pGrayImg[idx-iWidth-1]*Gauw[0] + pGrayImg[idx-iWidth]*Gauw[1] + pGrayImg[idx-iWidth+1]*Gauw[2] +
				pGrayImg[idx-1]*Gauw[3] + pGrayImg[idx]*Gauw[4] + pGrayImg[idx+1]*Gauw[5] +
				pGrayImg[idx+iWidth-1]*Gauw[6] + pGrayImg[idx+iWidth]*Gauw[7] + pGrayImg[idx+iWidth+1]*Gauw[8];
			pGraySmoothImg[idx] = (BYTE)((wsum + 500)/1000);
		}
	}
}


int ImageCumHist(int* arrHist,float HTh,float LTh, int* pHTh, int* pLTh)
{
    
	int i,nSum;
	float arrCum[256];
    
	nSum = 0;
    
	for (i=0; i<256; i++)
	{
		nSum += arrHist[i];
	}
    
	arrCum[0] = arrHist[0]/(float)nSum;
    
	for (i=1;i<256;i++)
	{
		arrCum[i] = arrHist[i]/(float)nSum + arrCum[i-1];
	}
    
	for (i=0; i<256; i++)
	{
		if (arrCum[i]>LTh)
		{
			*pLTh = i;
			break;
		}
	}
	for (i=0; i<256; i++)
	{
		if (arrCum[i]>HTh)
		{
			*pHTh = i;
			break;
		}
	}
    
	return 0;
}

int ImageHist(unsigned char* arrImage, int iHeight, int iWidth, int nBin,int* arrHist)
{
	int i, total;
	total = iHeight*iWidth;

	for (i=0; i<nBin; i++)
	{
		arrHist[i] =0;
	}
	for (i=0; i<total; i++)
	{
		arrHist[arrImage[i]]++;
	}

	return 0;
}

int ImgGradient(unsigned char* arrImage, int iHeight, int iWidth,unsigned char* nGradient)
{
	int i,j;
	float* pGradXimg = NULL;
	float* pGradYimg = NULL;
	int  idx;
	float  fGradX, fGradY, fMag;
    
	pGradXimg = Allocate_Image_Float(iHeight,iWidth,1);
    
	/*���x�����ݶ�*/
	for (i=0; i<iHeight; i++)
	{
		for (j=1; j<iWidth-1; j++)
		{
			pGradXimg[i*iWidth + j] = (arrImage[i*iWidth + j+1] - arrImage[i*iWidth + j-1])/2.0f;
		}
	}
	for (i=0; i<iHeight; i++)
	{
		pGradXimg[i*iWidth] = arrImage[i*iWidth + 1] - arrImage[i*iWidth];
		pGradXimg[i*iWidth + iWidth-1] = arrImage[i*iWidth + iWidth-1] - arrImage[i*iWidth + iWidth-2];
	}/* end of x�����ݶ� */
    
	pGradYimg = Allocate_Image_Float(iHeight,iWidth,1);
	/*���y�����ݶ�*/
	for (i=1; i<iHeight-1; i++)
	{
		for (j=0; j<iWidth; j++)
		{
			pGradYimg[i*iWidth + j] = (arrImage[(i+1)*iWidth + j] - arrImage[(i-1)*iWidth + j])/2.0f;
		}
	}
	for (j=0; j<iWidth; j++)
	{
		pGradYimg[j] = arrImage[iWidth + j] - arrImage[j];
		pGradYimg[(iHeight-1)*iWidth + j] = arrImage[(iHeight-1)*iWidth + j]-arrImage[(iHeight-2)*iWidth + j];
	}/* end of y�����ݶ� */
    
	/*�ݶ�*/
    idx = 0;
	for (i=0; i<iHeight; i++)
	{
		for (j=0; j<iWidth; j++, idx++)
		{
			fGradX = pGradXimg[idx];
			fGradY = pGradYimg[idx];
			fMag = sqrt(fGradX*fGradX + fGradY*fGradY);
			if  (fMag > 255)
				nGradient[idx] = 255;
			else
				nGradient[idx] = (int)(fMag + 0.5f);
		}
	}
    
	Free_Image_Float(pGradXimg,iHeight,iWidth);
	Free_Image_Float(pGradYimg,iHeight,iWidth);
    
	return 0;
}

int ImgBinay(unsigned char* arrImg,int iHeight, int iWidth, float hTh, float lTh, unsigned char* arrBinayImg)
{
	int i=0; int j=0; int ppos=0;
    
	for (i=0,ppos =0; i<iHeight; i++)//get the binaryzation
	{
		for (j=0; j<iWidth; j++,ppos++)
            
		{
			if ( arrImg[ppos] <= hTh && arrImg[ppos] >= lTh)
			{
				arrBinayImg[ppos] = 255;
			}
			else
			{
				arrBinayImg[ppos] = 0;
			}
            
		}
	}/* end of image binaryzation*/
	return 0;
    
};


void ImgGradient_X_Y(unsigned char* arrImage, int iHeight, int iWidth,
					unsigned char* nGradient, float *pGradXimg,  float  *pGradYimg)
{
	int i,j;
 	int  idx;
	float  fGradX, fGradY, fMag;

	//���x�����ݶ�
	for (i=0; i<iHeight; i++)
	{
		for (j=1; j<iWidth-1; j++)
		{
			pGradXimg[i*iWidth + j] = (arrImage[i*iWidth + j+1] - arrImage[i*iWidth + j-1])/2.0f;
		}
	}
	for (i=0; i<iHeight; i++)
	{
		pGradXimg[i*iWidth] = arrImage[i*iWidth + 1] - arrImage[i*iWidth];
		pGradXimg[i*iWidth + iWidth-1] = arrImage[i*iWidth + iWidth-1] - arrImage[i*iWidth + iWidth-2];
	}// end of x�����ݶ�

 	//���y�����ݶ�
	for (i=1; i<iHeight-1; i++)
	{
		for (j=0; j<iWidth; j++)
		{
			pGradYimg[i*iWidth + j] = (arrImage[(i+1)*iWidth + j] - arrImage[(i-1)*iWidth + j])/2;
		}
	}
	for (j=0; j<iWidth; j++)
	{
		pGradYimg[j] = arrImage[iWidth + j] - arrImage[j];
		pGradYimg[(iHeight-1)*iWidth + j] = arrImage[(iHeight-1)*iWidth + j]-arrImage[(iHeight-2)*iWidth + j];
	}// end of y�����ݶ�

	//����ݶ�
	idx = 0;
	for (i=0; i<iHeight; i++){
		for (j=0; j<iWidth; j++, idx++)
		{
			fGradX = pGradXimg[idx];
			fGradY = pGradYimg[idx];
			fMag = sqrt(fGradX*fGradX + fGradY*fGradY);
			if  (fMag > 255)
				nGradient[idx] = 255;
			else
				nGradient[idx] = (int)(fMag + 0.5f);
		}
	}
}

#define NOEDGE 0
#define POSSIBLE_EDGE 128
#define EDGE 255

void non_max_supp(unsigned char *mag, float *gradx, float *grady, int nrows, int ncols,
    unsigned char *result)
{
    int rowcount, colcount,count;
    unsigned char *magrowptr,*magptr;
    float *gxrowptr,*gxptr;
    float *gyrowptr,*gyptr;
    unsigned char m00;
	float gx,gy;
    float mag1,mag2;
    unsigned char *resultrowptr, *resultptr;


	/****************************************************************************
	* Zero the edges of the result image.Ŀ����ʹ�ĸ���Ե����ֵΪ0��
	****************************************************************************/
	resultrowptr = result;
	resultptr = result + ncols*(nrows-1);
    for (count=0; count<ncols; resultptr++,resultrowptr++,count++)
	{
        *resultrowptr = *resultptr = (unsigned char) 0;
    }
	resultptr = result;
	resultrowptr = result+ncols-1;
    for(count=0; count<nrows;
	count++,resultptr+=ncols,resultrowptr+=ncols)
	{
        *resultptr = *resultrowptr = (unsigned char) 0;
    }

	/****************************************************************************
	* Suppress non-maximum points.
	****************************************************************************/
	int direction;
	double gangle;

	for  ( rowcount = 1 ; rowcount < nrows -1 ;   rowcount++)
	{
		magrowptr = mag + rowcount*ncols +1;
		gxrowptr = gradx + rowcount*ncols +1;
		gyrowptr = grady + rowcount*ncols +1;
		resultrowptr = result + rowcount*ncols + 1;

		magptr = magrowptr;
		gxptr = gxrowptr;
		gyptr = gyrowptr;
		resultptr = resultrowptr;
		for  ( colcount = 1 ; colcount < ncols -1 ;
		colcount++,magptr++,gxptr++,gyptr++,resultptr++)
		{
			gx = *gxptr;
			gy = *gyptr;
			m00 = *magptr;
			if  (((gy<=0) && (gx>-gy)) ||
				((gy>=0)  && (gx<-gy)))
				direction = 1 ;
			else if  (((gx>0)  && (-gy>=gx)) ||
				((gx<0)  &&  (-gy<=gx)))
				direction = 2 ;
			else if  (((gx<=0) && (gx>gy)) ||
				((gx>=0) && (gx<gy)))
				direction = 3 ;
			else if  (((gy<0) && (gx<=gy)) ||
				((gy>0) && (gx>=gy)))
				direction = 4 ;
			else
			{
				*resultptr = (unsigned char) NOEDGE;
				continue;
			}

			switch  ( direction )
			{
			case 1 :
				gangle = fabs(gy/gx);
				mag1 = (*(magptr+1))*(1-gangle) + (*(magptr+1-ncols))*gangle;
				mag2 = (*(magptr-1))*(1-gangle) + (*(magptr-1+ncols))*gangle;
				break;
			case 2 :
				gangle = fabs(gx/gy);
				mag1 = (*(magptr-ncols))*(1-gangle) + (*(magptr-ncols+1))*gangle;
				mag2 = (*(magptr+ncols))*(1-gangle) + (*(magptr-1+ncols))*gangle;
				break;
			case 3 :
				gangle = fabs(gx/gy);
				mag1 = (*(magptr-ncols))*(1-gangle) + (*(magptr-ncols-1))*gangle;
				mag2 = (*(magptr+ncols))*(1-gangle) + (*(magptr+ncols+1))*gangle;
				break;
			case 4 :
				gangle = fabs(gy/gx);
				mag1 = (*(magptr-1))*(1-gangle) + (*(magptr-1-ncols))*gangle;
				mag2 = (*(magptr+1))*(1-gangle) + (*(magptr+1+ncols))*gangle;
				break;
			}
			if  ((m00>=mag1) && (m00>=mag2))
			{
				*resultptr = (unsigned char) POSSIBLE_EDGE;
			}
			else
			{
				*resultptr = (unsigned char) NOEDGE;
			}

		}
	}
}
/*******************************************************************************
* PROCEDURE: follow_edges
* PURPOSE: This procedure edges is a recursive routine that traces edgs along
* all paths whose magnitude values remain above some specifyable lower
* threshhold.
*******************************************************************************/
void follow_edges(unsigned char *edgemapptr, int cols)
{
   //short *tempmagptr;
   unsigned char *tempmapptr;
   int i;
   int x[8] = {1,1,0,-1,-1,-1,0,1},
       y[8] = {0,1,1,1,0,-1,-1,-1};

   for(i=0;i<8;i++){
      tempmapptr = edgemapptr - y[i]*cols + x[i];

      if(*tempmapptr == POSSIBLE_EDGE) //&& (*tempmagptr > lowval)
	  {
         *tempmapptr = (unsigned char) EDGE;
         follow_edges(tempmapptr, cols); //tempmagptr, lowval,
      }
   }
}

/*******************************************************************************
* PROCEDURE: apply_hysteresis
* PURPOSE: This routine finds edges that are above some high threshhold or
* are connected to a high pixel by a path of pixels greater than a low
* threshold.
*******************************************************************************/
void apply_hysteresis(unsigned char *mag, unsigned char *nms, int rows, int cols,
	int  highthreshold, double ThresholdRatio, unsigned char *edge)
{
   int r, c, pos;  //numedges,
   double  lowthreshold;  //maximum_mag,


   lowthreshold = (int)(ThresholdRatio * highthreshold + 0.5);


   /****************************************************************************
   * Compute the high threshold value as the (100 * thigh) percentage point
   * in the magnitude of the gradient histogram of all the pixels that passes
   * non-maximal suppression. Then calculate the low threshold as a fraction
   * of the computed high threshold value. John Canny said in his paper
   * "A Computational Approach to Edge Detection" that "The ratio of the
   * high to low threshold in the implementation is in the range two or three
   * to one." That means that in terms of this implementation, we should
   * choose tlow ~= 0.5 or 0.33333.
   ****************************************************************************/
   for(r=0,pos=0;r<rows;r++)
   {
      for(c=0;c<cols;c++,pos++)
	  {
		if((nms[pos] == POSSIBLE_EDGE) && (mag[pos]>lowthreshold))
			edge[pos] = POSSIBLE_EDGE;
		else
			edge[pos] = NOEDGE;
      }
   }

   for(r=0,pos=0;r<rows;r++,pos+=cols)
   {
      edge[pos] = NOEDGE;
      edge[pos+cols-1] = NOEDGE;
   }
   pos = (rows-1) * cols;
   for(c=0;c<cols;c++,pos++)
   {
      edge[c] = NOEDGE;
      edge[pos] = NOEDGE;
   }


   /****************************************************************************
   * This loop looks for pixels above the highthreshold to locate edges and
   * then calls follow_edges to continue the edge.
   ****************************************************************************/
   for(r=0,pos=0;r<rows;r++)
   {
	   for(c=0;c<cols;c++,pos++)
	   {
		   if((edge[pos] == POSSIBLE_EDGE) && (mag[pos] >= highthreshold))
		   {
			   edge[pos] = EDGE;
			   follow_edges((edge+pos), cols);
		   }
	   }
   }

   /****************************************************************************
   * Set all the remaining possible edges to non-edges.
   ****************************************************************************/
   for(r=0,pos=0;r<rows;r++)
   {
      for(c=0;c<cols;c++,pos++) if(edge[pos] != EDGE) edge[pos] = NOEDGE;
   }
}





////////////////////////////////////////////////////////////////////////////////////////////////


//To evaluate whether or not a point P is inside of the polygon using irradiation method and cross point counter
//TRUE --- inside, FALSE----outside
BOOL Reinsidepolygon(POINT *polygon,int N,POINT p)
{
    int counter = 0;
    int i;
    double xinters;
    POINT p1,p2;

    p1 = polygon[0];
    for (i=1;i<N;i++) {
        p2 = polygon[i % N];
        if (p.y > MIN(p1.y,p2.y)) {
            if (p.y <= MAX(p1.y,p2.y)) {
                if (p.x <= MAX(p1.x,p2.x)) {
                    if (p1.y != p2.y) {
                        xinters = (p.y-p1.y)*(p2.x-p1.x)/(p2.y-p1.y)+p1.x;
                        if (p1.x == p2.x || p.x <= xinters)
                            counter++;
					}
				}
			}
		}
		p1 = p2;
	}

    if (counter % 2 == 0)
        return(FALSE);
    else
        return(TRUE);
}



BOOL infacearea(POINT *p88pt, const int *pptidx, const int ptno, POINT p)
{
    //int counter = 0;
    int i;
	POINT  *pPTlist;
	BOOL  retcode;
	pPTlist = (POINT*)malloc(sizeof(POINT)*ptno);
	for (i = 0; i<ptno; i++) {
		pPTlist[i].x = p88pt[pptidx[i]].x;
		pPTlist[i].y = p88pt[pptidx[i]].y;
	}
	retcode = Reinsidepolygon(pPTlist,  ptno, p);

	free(pPTlist);

	return retcode;
}

////////////////////////////////////////////////////////////////////////////////////////////////



void SS_MYErosionImage
(
	unsigned char *in_g,
	int width,
	int height,
	unsigned char *out_g
	)
{
    int x, y;

	int nmax;
	unsigned char *out;

	memset(out_g, 0, width*height);

	for(y = 1; y < height-1 ; y++) {
		out = out_g + (y * width);
		for(x = 1; x < width-1; x++) {

			nmax = *(in_g + ((y - 1) * width + x - 1));
			nmax = MAX(*(in_g + ((y - 1) * width + x)), nmax);
			nmax = MAX(*(in_g + ((y - 1) * width + x + 1)), nmax);
			nmax = MAX(*(in_g + (y * width + x - 1)), nmax);
			nmax = MAX(*(in_g + (y * width + x)), nmax);
			nmax = MAX(*(in_g + (y * width + x + 1)), nmax);
			nmax = MAX(*(in_g + ((y + 1) * width + x - 1)), nmax);
			nmax = MAX(*(in_g + ((y + 1) * width + x)), nmax);
			nmax = MAX(*(in_g + ((y + 1) * width + x + 1)), nmax);

			*(out+x) = (unsigned char)nmax;
		}
	}
}


void EnlargeFaceFreckleArea(int  imgWidth, int imgHeight,  FACEAREA *Face,
							int  *pFaceTopX, int *pFaceTopY, int  *pFaceHeight, int *pFaceWidth,
							int  *pElgTopX,  int *pElgTopY,	 int *pElgButX,  int  *pElgButY
)
{
	int LTX,  LTY, RBX,	 RBY;
	int FLTX = Face->ptLeftTop.x;			int FLTY = Face->ptLeftTop.y;
	int FLBX = Face->ptLeftBottom.x;		int FLBY = Face->ptLeftBottom.y;
	int FRTX = Face->ptRightTop.x;			int FRTY = Face->ptRightTop.y;
	int FRBX = Face->ptRightBottom.x;		int FRBY = Face->ptRightBottom.y;


	 LTX = MIN(FLTX, MIN(FLBX, MIN(FRTX, FRBX)));
	 LTY = MIN(FLTY, MIN(FLBY, MIN(FRTY, FRBY)));
	 RBX = MAX(FLTX, MAX(FLBX, MAX(FRTX, FRBX)));
	 RBY = MAX(FLTY, MAX(FLBY, MAX(FRTY, FRBY)));
	 LTX = MIN(imgWidth-1, MAX(0,  LTX));
	 LTY = MIN(imgHeight-1, MAX(0,  LTY));
	 RBX = MAX(0, MIN(imgWidth-1,  RBX));
	 RBY = MAX(0, MIN(imgHeight-1,  RBY));

	//face de-rotation necessary???

	*pFaceHeight=RBY - LTY;
	if (*pFaceHeight<0) {
		*pFaceHeight = -*pFaceHeight;
	}
	*pFaceWidth=RBX - LTX;
	if (*pFaceWidth<0) {
		*pFaceWidth =  -*pFaceWidth;
	}
	*pFaceTopX=LTX;
	*pFaceTopY=LTY;


	*pElgTopY = MAX(0, *pFaceTopY - *pFaceHeight/4);/* �Խ�ȡ�ľ����������򣬸߶Ƚ���3/2��������, width 6/5*/

	*pElgButY = MIN(imgHeight, *pFaceTopY + 5*(*pFaceHeight)/4);

	*pElgTopX = MAX(0, *pFaceTopX - *pFaceWidth/10);

	*pElgButX = MIN(imgWidth, *pFaceTopX + 11*(*pFaceWidth)/10);

	/* ends of  �Խ�ȡ�ľ����������򣬽���2��������*/
}
void    CCL_FindOuterRect(POINT		*p88pt,
						  const int	*pptidx,
						  const int	ptno,
						  POINT        offpt,
						  RECT      *rc)
{
	int   left, top, right, bottom;
	int	  i;
	left = 10000000; top = 10000000; right = -1; bottom = -1;
	for  (i=0; i<ptno; i++) {
		if  (p88pt[pptidx[i]].x + offpt.x<left)
			left = p88pt[pptidx[i]].x + offpt.x;
		if  (p88pt[pptidx[i]].x + offpt.x>right)
			right = p88pt[pptidx[i]].x + offpt.x;
		if  (p88pt[pptidx[i]].y + offpt.y<top)
			top = p88pt[pptidx[i]].y + offpt.y;
		if  (p88pt[pptidx[i]].y + offpt.y>bottom)
			bottom = p88pt[pptidx[i]].y + offpt.y;
	}
	rc->left = left;
	rc->top = top;
	rc->right = right;
	rc->bottom = bottom;
}

BOOL   CCL_Evaluate2RectOverlap(RECT  rect1,  RECT rect2)
{
	int olarealx = MAX(rect1.left, rect2.left);
	int olarealy = MAX(rect1.top, rect2.top);
	int olarearx = MIN(rect1.right, rect2.right);
	int olareary = MIN(rect1.bottom, rect2.bottom);
	if  ((olarealx >= olarearx ) || (olarealy >= olareary))  //not overlapping at all
 		return FALSE;
 	else
		return TRUE;
}

void	CCL_RemoveBlobInArea(
					   BYTE			*pBlobImg,
					   INT32		nWidth,
					   INT32		nHeight,
					   POINT		*p88pt,
					   const int	*pptidx1,
					   const int	ptno1,
					   POINT        offpt1,
					   const int	*pptidx2,
					   const int	ptno2,
					   POINT        offpt2,
					   const int	*pptidx3,
					   const int	ptno3,
					   POINT        offpt3
					   )
{

	int i, idx;
	BYTE *pBinary;
	KCCL stCCL;
 	int x,y;
	//bool  blobOK;
	int   blobID;
	RECT  rc1, rc2, rc3, blobrc;
	CCL_FindOuterRect(p88pt, pptidx1, ptno1, offpt1, &rc1);
	CCL_FindOuterRect(p88pt, pptidx2, ptno2, offpt2, &rc2);
	CCL_FindOuterRect(p88pt, pptidx3, ptno3, offpt3, &rc3);
	KCCL_init(&stCCL);
	pBinary = (BYTE *) malloc(nWidth*nHeight*sizeof(BYTE));

	for (idx = 0; idx<nWidth*nHeight; idx++)
	{
		if  (pBlobImg[idx] > 0)
			pBinary[idx] = 1;
		else
			pBinary[idx] = 0;
	}

	KCCL_SetMask(&stCCL, pBinary, nWidth, nHeight);
	KCCL_Process(&stCCL, 0);//the size threshold of blob is 0 ;// all blobs r

	if  ( stCCL.m_ObjectNumber == 0) {
		KCCL_free(&stCCL);
		free(pBinary);
		return;
	}
	for  (i = 0 ; i<stCCL.m_ObjectNumber; i++) {
		blobID = ((KBox*)vector_at(&(stCCL.m_Components), i))->ID;
		//blobOK = TRUE;
		//idx = 0;
		blobrc.left = ((KBox*)vector_at(&(stCCL.m_Components), i))->topLeft.x;
		blobrc.top = nHeight -1 - ((KBox*)vector_at(&(stCCL.m_Components), i))->bottomRight.y;  //Note!!!!!!!!!!!
		blobrc.right = ((KBox*)vector_at(&(stCCL.m_Components), i))->bottomRight.x;
		blobrc.bottom = nHeight -1 -((KBox*)vector_at(&(stCCL.m_Components), i))->topLeft.y;


		if  (CCL_Evaluate2RectOverlap(blobrc,  rc1) || CCL_Evaluate2RectOverlap(blobrc,  rc2) || CCL_Evaluate2RectOverlap(blobrc,  rc3)) {
			//remove the blob
			idx = 0;
			for  (y=0; y<nHeight; y++) {
				for (x=0; x<nWidth; x++, idx++) {
					if (stCCL.m_MaskArray[idx] == blobID) {
						pBlobImg[idx] = 0;
					}
				}
			}
		}
	}

	KCCL_free(&stCCL);
	free(pBinary);
}
