//
//  SJVideoPlayerScreenView.h
//  ShiJia
//
//  Created by yy on 16/8/4.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJVideoPlayerScreenView : UIView
@property (nonatomic, assign) BOOL tvPlay;
@property (nonatomic, copy) void(^remoteButtonClickBlock)();

@end
