#ifndef JUDGECHARACTER_H
#define JUDGECHARACTER_H

#ifdef __cplusplus
extern "C" {
#endif

////眼睛是否为水平
////flag 0---100  0眼睛歪掉  100眼睛水平
//void JudgePositive(unsigned char *_src,int _width,int _height,POINT _ft[],int *_flag);

//照片昏暗
//flag 0---100  0昏暗  100照片明亮
void JudgeDim(unsigned char *_src,int _width,int _height,POINT _ft[],int *_flag);

////阴阳脸
////flag 0---100  0肯定是阴阳脸   100没有阴阳脸
//void JudgeTwoFaces(unsigned char *_src,int _width,int _height,POINT _ft[],int *_flag);
//
////衣服和背景颜色相似
////flag  0--100 0衣服和背景相似，100衣服和背景不相似
//void JudgeBFSimilarity(unsigned char *_src,int _width,int _height,POINT _ft[],int *_flag);
//
//
////结婚照服装背景判断:左边的人，只判断左边背景；右边的人，只判断右边背景
//void JudgeBFSimilarityLeft(unsigned char *_src,int _width,int _height,POINT _ft[],int *_flag);
//void JudgeBFSimilarityRight(unsigned char *_src,int _width,int _height,POINT _ft[],int *_flag);
//
////结婚照身高差判断
////flag  0身高差太大，不合格   100无身高差
//void JudgeHeightDifference(POINT _ft1[],POINT _ft2[],int *_flag);
//
////结婚照左右距离差判断
////flag  0 距离太远，不合格    100距离合适
//void JudgeDistanceDifference(POINT _ft1[],POINT _ft2[],int *_flag);

#ifdef __cplusplus
}
#endif

#endif
