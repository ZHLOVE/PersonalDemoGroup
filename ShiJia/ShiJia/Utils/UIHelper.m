//
//  T.m
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "UIHelper.h"
#import "UIColor-Expanded.h"
#import "UINavigationController+TopVC.h"
//#import <REFrostedViewController/REFrostedViewController.h>


@implementation UIHelper

+ (UIButton*)createBtnfromPoint:(CGPoint)point
                       imageStr:(NSString*)imgstr
                         target:(id)target
                       selector:(SEL)selector
{
	UIImage* img = [UIImage imageNamed:imgstr];
	return [self createBtnfromPoint:point image:img target:target selector:selector];
}

+ (UIButton*)createBtnfromPoint:(CGPoint)point
                       imageStr:(NSString*)imgstr
                highlightImgStr:(NSString*)himgstr
                         target:(id)target
                       selector:(SEL)selector
{
	UIImage* img = [UIImage imageNamed:imgstr];
	UIImage* imgHighlight = [UIImage imageNamed:himgstr];
	return [self createBtnfromPoint:point image:img highlightImg:imgHighlight target:target selector:selector];
}

+ (UIButton*)createBtnfromPoint:(CGPoint)point
                          image:(UIImage*)img
                         target:(id)target
                       selector:(SEL)selector
{
	UIButton *abtn = [[UIButton alloc] initWithFrame:CGRectMake(point.x,point.y ,img.size.width,img.size.height)];
	abtn.backgroundColor = [UIColor clearColor];
	[abtn setBackgroundImage:img forState:UIControlStateNormal];
	[abtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return abtn;	
}

+ (UIButton*)createBtnfromSize:(CGSize)aSize
                         image:(UIImage*)img
                  highlightImg:(UIImage*)himg
                   selectedImg:(UIImage*)selimg
                        target:(id)target
                      selector:(SEL)selector
{
    UIButton *abtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, aSize.width, aSize.height)];
	abtn.backgroundColor = [UIColor clearColor];
	[abtn setImage:img forState:UIControlStateNormal];
	[abtn setImage:himg forState:UIControlStateHighlighted];
    [abtn setBackgroundImage:selimg
                    forState:UIControlStateSelected];
	[abtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    abtn.accessibilityLabel = @"返回";
    abtn.accessibilityTraits = UIAccessibilityTraitNone;
	return abtn;
}

+ (UIButton*)createBtnfromPoint:(CGPoint)point
                          image:(UIImage*)img
                   highlightImg:(UIImage*)himg
                    selectedImg:(UIImage*)selimg
                         target:(id)target
                       selector:(SEL)selector
{
	UIButton *abtn = [[UIButton alloc] initWithFrame:CGRectMake(point.x,point.y ,img.size.width,img.size.height)];
	abtn.backgroundColor = [UIColor clearColor];
	[abtn setBackgroundImage:img forState:UIControlStateNormal];
	[abtn setBackgroundImage:himg forState:UIControlStateHighlighted];
    [abtn setBackgroundImage:selimg
                    forState:UIControlStateSelected];
	[abtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return abtn;	
}

+ (UIButton*)createBtnfromPoint:(CGPoint)point
                          image:(UIImage*)img
                   highlightImg:(UIImage*)himg
                         target:(id)target
                       selector:(SEL)selector
{
	UIButton *abtn = [[UIButton alloc] initWithFrame:CGRectMake(point.x,point.y ,img.size.width,img.size.height)];
	abtn.backgroundColor = [UIColor clearColor];
	[abtn setBackgroundImage:img forState:UIControlStateNormal];
	[abtn setBackgroundImage:himg forState:UIControlStateHighlighted];

	[abtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return abtn;	
}

+ (UILabel *)createTitleLabel:(NSString *)aTitle
{
    CGSize aSize = [aTitle sizeWithFont:kBoldFontSizeLarge1 constrainedToSize:CGSizeMake(200, 44)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, aSize.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = kFontSizeLarge1;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = aTitle;

    return label;
}

+ (UIButton *)createRightButtonWithTitle:(NSString *)aTitle
{
    CGSize sz = [aTitle sizeWithFont:kFontSizeMedium constrainedToSize:CGSizeMake(100, 44)];
//    CGRect rect = [aTitle boundingRectWithSize:CGSizeMake(100, 44)
//                                       options:NSStringDrawingUsesLineFragmentOrigin
//                                    attributes:@{ NSFontAttributeName: kFontSizeMedium}
//                                       context:nil];
//    CGSize sz = rect.size;
    
    UIButton *abtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20 + sz.width, 44)];
    [abtn setTitleColor:kFontColorDarkGray forState:UIControlStateNormal];
    abtn.titleLabel.font = kFontSizeMedium;
    [abtn setTitle:aTitle forState:UIControlStateNormal];

	return abtn;

}


#pragma mark - show new vc logic

/**
 *  get current top vc on window
 */
+ (UIViewController *)getCurrentVCByWindow:(UIWindow *)window
{
    UIViewController *currentVC;
    
//    if ([NSStringFromClass([window.rootViewController class]) isEqualToString:@"REFrostedViewController"]) {
//        REFrostedViewController *root = (REFrostedViewController *)window.rootViewController;
//        currentVC = [UIHelper getTopVCFromRoot:root.contentViewController];
//    }else{
        currentVC = [UIHelper getTopVCFromRoot:window.rootViewController];
//    }
    return currentVC;
}

+ (UIViewController *)getTopVCFromRoot:(id)vc
{
    UIViewController *topVC;
    if ([vc isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)vc;
        if ([nav.viewControllers count]) {
            topVC = [nav getTopVC];
        }
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.viewControllers count]) {
            if ([[tab.viewControllers objectAtIndex:tab.selectedIndex]isKindOfClass:[UIViewController class]]) {
                topVC = (UIViewController *)[tab.viewControllers objectAtIndex:tab.selectedIndex];
            }else if ([[tab.viewControllers objectAtIndex:tab.selectedIndex]isKindOfClass:[UINavigationController class]]){
                UINavigationController *nav = (UINavigationController *)[tab.viewControllers objectAtIndex:tab.selectedIndex];
                if ([nav.viewControllers count]) {
                    topVC = [nav getTopVC];
                }
            }
        }
    }else if ([vc isKindOfClass:[UIViewController class]]) {
        topVC = (UIViewController *)vc;
    }
    return topVC;
}


#pragma mark - add by xiaochengfei

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id)delegate
            cancelBtnTitle:(NSString *)cancel
            otherBtnTitles:(NSString *)others,...
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title?:kIOS8_OR_LATER?@"":nil
                                                   message:message
                                                  delegate:delegate
                                         cancelButtonTitle:cancel
                                         otherButtonTitles:others, nil];
    [alert show];
}

// 函数包涵warning并且未使用
#if 0
+ (CGSize)stringSizeWithText:(NSString *)text
                        Font:(UIFont *)font
           constrainedToSize:(CGSize)size
                  attributes:(NSDictionary *)attDic
{
    if (!text) {
        text = @"";
    }
    if (!attDic) {
        attDic = @{};
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:attDic];
    if (font) {
        [dic setObject:font forKey:NSFontAttributeName];
    }
    
    CGSize sizeWithFont;
    if (kIOS7_OR_LATER) {
        sizeWithFont = [text boundingRectWithSize:size
                                          options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                       attributes:dic
                                          context:NULL].size;
    }else{
        sizeWithFont = [text sizeWithFont:font
                        constrainedToSize:size
                            lineBreakMode:NSLineBreakByWordWrapping];
    }
    return sizeWithFont;
}
#endif


#pragma mark - Image Resize
+ (UIImage *)image:(UIImage *)image
        drawInRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)image:(UIImage *)image
         fitInSize:(CGSize)size
{
    CGFloat scale;
    CGSize newSize = image.size;
    if (newSize.height != 0) {
        scale = size.height / newSize.height;
        newSize.height *= scale;
        newSize.width *= scale;
    } else {
        return nil;
    }
    if (newSize.width != 0) {
        scale = size.width / newSize.width;
        newSize.height *= scale;
        newSize.width *= scale;
    } else {
        return nil;
    }
    CGFloat x = (size.width - newSize.width) / 2.0f;
    CGFloat y = (size.height - newSize.height) / 2.0f;
    return [UIHelper image:image drawInRect:CGRectMake(x, y, newSize.width, newSize.height)];
}

+ (UIImage *)image:(UIImage *)image
      centerInSize:(CGSize)size
{
    CGSize newSize = image.size;
    CGFloat x = (size.width - newSize.width)/2.0f;
    CGFloat y = (size.height - newSize.height)/2.0f;
    return [UIHelper image:image drawInRect:CGRectMake(x, y, newSize.width, newSize.height)];
}

+ (UIImage *)image:(UIImage *)image
        fillInSize:(CGSize)size
{
    CGSize newSize = image.size;
    CGFloat scaleX = 0;
    CGFloat scaleY = 0;
    if (newSize.width != 0) {
        scaleX = size.width/newSize.width;
    } else {
        return nil;
    }
    if (newSize.height != 0) {
        scaleY = size.height/newSize.height;
    } else {
        return nil;
    }
    CGFloat scale = MAX(scaleX, scaleY);
    newSize.width *= scale;
    newSize.height *= scale;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake((size.width-newSize.width)/2.0,
                                 0,
                                 newSize.width,
                                 newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)image:(UIImage *)image
        fitToWidth:(CGFloat)width
{
    CGSize newSize = image.size;
    CGFloat scale;
    if (newSize.width != 0) {
        scale = width/newSize.width;
    } else {
        return nil;
    }
    return [UIHelper image:image drawInRect:CGRectMake(0, 0, width, newSize.height*scale)];
}

+ (UIImage *)image:(UIImage *)image
       fitToHeight:(CGFloat)height
{
    CGSize newSize = image.size;
    CGFloat scale;
    if (newSize.height != 0) {
        scale = height/newSize.height;
    } else {
        return nil;
    }
    return [UIHelper image:image drawInRect:CGRectMake(0, 0, newSize.width*scale, height)];
}

+ (UIImage *)addImage:(UIImage *)image1
              toImage:(UIImage *)image2
           atPosition:(CGRect)frame
{
    UIGraphicsBeginImageContext(image2.size);
    
    // Draw image1
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    // Draw image2
    [image1 drawInRect:frame];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (UIImage *) scaleFromImage: (UIImage *) image
                      toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)scaleImage:(UIImage *)image
                toScale:(CGFloat)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

+ (UIImage *)stretchImage:(UIImage *)image
                capInsets:(UIEdgeInsets)capInsets
             resizingMode:(UIImageResizingMode)resizingMode
{
    UIImage *resultImage = nil;
    double systemVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    if (systemVersion <5.0) {
        resultImage = [image stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.right];
    }else if (systemVersion<6.0){
        resultImage = [image resizableImageWithCapInsets:capInsets];
    }else{
        resultImage = [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
    }
    return resultImage;
}

+ (CGFloat)adapterOriginX:(CGFloat)x
                withWidth:(CGFloat)width
{
    CGFloat centerOriginX = x + width/2;//从中点计算，等比缩放OriginX，才是准确的
    return centerOriginX*kScreenWidthScaleSize - width/2;
}

+ (CGFloat)adapterOriginXwithWidth:(CGFloat)width
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return screenWidth/2 - width/2;
}

//等比缩放CGSize
+ (CGSize )getAutoSize:(CGSize )size
{
    CGSize sizeAuto;
    CGFloat autoSizeScaleWith = size.width*kScreenWidthScaleSizeByIphone6;
    CGFloat autoSizeScaleHeight = size.height*kScreenWidthScaleSizeByIphone6;
    sizeAuto.width = autoSizeScaleWith;
    sizeAuto.height = autoSizeScaleHeight;
    //    CGFloat autoSizeScaleX = (autoSizeScaleWith-width)/2.0+x;
    return sizeAuto;
}

//等比缩放CGPoint
+ (CGPoint )getAutoPoint:(CGPoint )origin
{
    CGPoint originAuto;
    originAuto.x = origin.x*kScreenWidthScaleSizeByIphone6;
    originAuto.y = origin.y*kScreenWidthScaleSizeByIphone6;
    return originAuto;
}

//等比缩放CGSize,调整originX ，originy
+ (CGRect )getAutoRect:(CGRect )rect
{
    CGRect rectAuto;
    CGSize sizeAuto = [UIHelper getAutoSize:rect.size];
    CGPoint originAuto = [UIHelper getAutoPoint:rect.origin];
    rectAuto.origin = originAuto;
    rectAuto.size = sizeAuto;
    return rectAuto;
}

+ (BOOL)isImageLink:(NSString *)urlStr
{
    if (!urlStr) {
        return NO;
    }
    if ([urlStr length] > 5) {
        if ([[urlStr lowercaseString] rangeOfString:@".jpg"].location != NSNotFound ||
            [[urlStr lowercaseString] rangeOfString:@".jpeg"].location != NSNotFound||
            [[urlStr lowercaseString] rangeOfString:@".png"].location != NSNotFound ||
            [[urlStr lowercaseString] rangeOfString:@".gif"].location != NSNotFound ||
            [[urlStr lowercaseString] rangeOfString:@".tiff"].location != NSNotFound||
            [[urlStr lowercaseString] rangeOfString:@".webp"].location != NSNotFound
            ) {
            return YES;
        }
    }
    return NO;
}

+ (void)change:(UIView *)view
       originY:(CGFloat)originY
{
    CGRect frame = view.frame;
    frame.origin.y = originY;
    view.frame = frame;
}

+ (void)change:(UIView *)view
       originX:(CGFloat)originX
{
    CGRect frame = view.frame;
    frame.origin.x = originX;
    view.frame = frame;
}

+ (void)change:(UIView *)view
       centerX:(CGFloat)centerX
{
    CGPoint center = view.center;
    center.x = centerX;
    view.center = center;
}

+ (void)change:(UIView *)view
       centerY:(CGFloat)centerY
{
    CGPoint center = view.center;
    center.y = centerY;
    view.center = center;
}

+ (void)change:(UIView *)view
        height:(CGFloat)height
{
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}
+ (void)change:(UIView *)view
         width:(CGFloat)width
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}
+ (void)change:(UIScrollView *)scrollView
        insets:(UIEdgeInsets)insets
{
    scrollView.scrollIndicatorInsets = insets;
    scrollView.contentInset = insets;
}

+(UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIInterfaceOrientation)currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}



@end

#pragma clang diagnostic pop
