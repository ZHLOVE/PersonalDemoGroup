//
//  T.h
//  PlutoLand
//
//  Created by J.Horn on 7/16/10.
//  Copyright 2010 Baidu.com. All rights reserved.
//

/*
 an global helper class, all the methods inside should be class method.
 */


#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, showVCType){
    showVCType_push = 1,
    showVCType_present,
    showVCType_page
};





@interface UIHelper : NSObject 

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIButton*)createBtnfromSize:(CGSize)aSize
                          image:(UIImage*)img
                   highlightImg:(UIImage*)himg
                    selectedImg:(UIImage*)selimg
                         target:(id)target
                       selector:(SEL)selector;

+ (UIButton*)createBtnfromPoint:(CGPoint)point
                          image:(UIImage*)img
                   highlightImg:(UIImage*)himg
                    selectedImg:(UIImage*)selimg
                         target:(id)target
                       selector:(SEL)selector;

+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img target:(id)target selector:(SEL)selector; 

+ (UIButton*)createBtnfromPoint:(CGPoint)point image:(UIImage*)img highlightImg:(UIImage*)himg target:(id)target selector:(SEL)selector; 

+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr target:(id)target selector:(SEL)selector; 

+ (UIButton*)createBtnfromPoint:(CGPoint)point imageStr:(NSString*)imgstr highlightImgStr:(NSString*)himgstr target:(id)target selector:(SEL)selector; 

+ (UILabel*)createTitleLabel:(NSString *)aTitle;

+ (UIButton *)createRightButtonWithTitle:(NSString *)aTitle;


+ (UIViewController *)getCurrentVCByWindow:(UIWindow *)window;

#pragma mark - add by xiaochengfei
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id)delegate
            cancelBtnTitle:(NSString *)cancel
            otherBtnTitles:(NSString *)others,...;


//+ (CGSize)stringSizeWithText:(NSString *)text Font:(UIFont *)font constrainedToSize:(CGSize)size attributes:(NSDictionary *)attDic;

+ (UIImage*)image:(UIImage*)image fitInSize:(CGSize)size;
+ (UIImage*)image:(UIImage*)image centerInSize:(CGSize)size;
+ (UIImage*)image:(UIImage*)image fillInSize:(CGSize)size;
+ (UIImage*)image:(UIImage*)image fitToWidth:(CGFloat)width;
+ (UIImage*)image:(UIImage*)image fitToHeight:(CGFloat)height;

//图片叠加
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 atPosition:(CGRect)frame;

//压缩图片
+ (UIImage *)scaleFromImage: (UIImage *) image toSize: (CGSize) size;

//等比率缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(CGFloat)scaleSize;

+ (UIImage *)stretchImage:(UIImage *)image
                capInsets:(UIEdgeInsets)capInsets
             resizingMode:(UIImageResizingMode)resizingMode;

/*** 适配API ***/
+ (CGFloat)adapterOriginX:(CGFloat)x withWidth:(CGFloat)width;//根据标准320，计算大屏(375,414)对应的比例
+ (CGFloat)adapterOriginXwithWidth:(CGFloat)width;//居中时,adapterOriginX:方法就不适用了，需要根据本身宽度重新计算
+ (CGSize )getAutoSize:(CGSize )size;
+ (CGRect )getAutoRect:(CGRect )rect;

+ (BOOL)isImageLink:(NSString *)urlStr;

+ (void)change:(UIView*)view originY:(CGFloat)originY;
+ (void)change:(UIView *)view height:(CGFloat)height;
+ (void)change:(UIView *)view originX:(CGFloat)originX;
+ (void)change:(UIView *)view width:(CGFloat)width;
+ (void)change:(UIView *)view centerX:(CGFloat)centerX;
+ (void)change:(UIView *)view centerY:(CGFloat)centerY;
+ (void)change:(UIScrollView *)scrollView insets:(UIEdgeInsets)insets;

//capture
+ (UIImage *)capture:(UIView*)view;
+ (UIInterfaceOrientation)currentOrientation;

@end
