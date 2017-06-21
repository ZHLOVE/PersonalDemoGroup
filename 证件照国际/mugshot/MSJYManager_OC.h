//
//  MSJYShell.h
//  mugshot
//
//  Created by Venpoo on 15/9/6.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAMPicContext.h"
#import "CAMBuffer.h"

@interface MSJYManager_OC : NSObject
+ (id)sharedInstance;

-(void)chuShiHua;
-(void)sheZhiCanShuWidth:(NSNumber*)idphotow
                  Height:(NSNumber*)idphotoh
                     RX1:(NSNumber*)ratiox1
                     RX2:(NSNumber*)ratiox2
                     RY1:(NSNumber*)ratioy1
                     RY2:(NSNumber*)ratioy2
                    new1:(NSNumber*)new1
                    new2:(NSNumber*)new2
                    new3:(NSNumber*)new3
                    new4:(NSNumber*)new4
                    new5:(NSNumber*)new5
                    new6:(NSNumber*)new6;
-(CAMPicContext *)renLianShu:(UIImage*)image;
-(void)jiSuanKuang;
-(void)sheZhiTuPian:(UIImage*)extImage;
-(void)daFeng;
-(UIImage*)shengChengMask;
-(UIImage*)meiYan:(double)_leye :(double)_reye :(double)_mouse :(double)_white :(double)_skin :(double)_coseye;
-(void)jiSuanKuangAgain:(UIImage*)maskImg;
-(NSArray*)zuiZhongKuang;
-(void)shiFang;

-(CGSize)getOriArea;

@end

