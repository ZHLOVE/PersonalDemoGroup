#ifndef CONV2_H
#define CONV2_H
#include "JY_Head.h"
#include <vector>


#include <cmath>
#include <iostream>
#include <stdlib.h>
#include <string.h>
void conv2(double  *x,double *y,int N1,int M1,int N2,int M2,double *z);


void img2col_mirrorpad(
	const double* data_im, const int height, const int width,   //(I) input image (double) parameters
	const int kernel_h, const int kernel_w,						//(I) kernel parameters
	const int pad_h, const int pad_w,							//(I) pad parameters
	const int stride_h, const int stride_w,						//(I) stride parameters (sampling intervals in X, Y direction)
	double* data_col											//(O) output columns
	) ;


void img2col_dense_part(
	const double* data_im, const int height, const int width,   //(I) input image (double) parameters
	const int	starty,	const int endy,							//(I) only y considered now [starty, endy]
	const int	kernel_h, const int kernel_w,					//(I) kernel parameters
	const int	pad_h, const int pad_w,							//(I) pad parameters
	double*		data_col										//(O) output columns
	) ;

#endif
