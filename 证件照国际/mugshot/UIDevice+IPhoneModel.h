//
//  UIDevice+IPhoneModel.h
//  mugshot
//
//  Created by Venpoo on 15/9/27.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(char, iPhoneModel){//0~3
    iPhone4,//320*480
    iPhone5,//320*568
    iPhone6,//375*667
    iPhone6Plus,//414*736
    UnKnown
};

@interface UIDevice (IPhoneModel)

/**
 *  return current running iPhone model
 *
 *  @return iPhone model
 */
+ (iPhoneModel)iPhonesModel;

@end
