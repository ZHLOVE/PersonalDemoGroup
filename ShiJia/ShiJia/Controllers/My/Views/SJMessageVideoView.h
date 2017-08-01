//
//  SJMessageVideoView.h
//  ShiJia
//
//  Created by yy on 16/6/23.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kSJMessageVideoViewHeight;

@interface SJMessageVideoView : UIView

@property (nonatomic, copy) NSString *programName;
@property (nonatomic, copy) NSString *director;
@property (nonatomic, copy) NSString *actor;
@property (nonatomic, copy) NSString *posterImgUrl;
@property (nonatomic, readonly) RACSignal *playSignal;

@end
