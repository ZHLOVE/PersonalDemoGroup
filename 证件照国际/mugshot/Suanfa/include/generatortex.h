#ifndef TEX_GENERATOR_H_
#define TEX_GENERATOR_H_
#include "JY_Head.h"
/**
 * @param src       bgr����
 * @param width     �̶�Ϊ240
 * @param height    �̶�Ϊ240
 * @param map       int���� ��СΪ240*240
 */
void genTex(unsigned char const *src,int width,int height,int *result);

#endif  // TEX_GENERATOR_H_
