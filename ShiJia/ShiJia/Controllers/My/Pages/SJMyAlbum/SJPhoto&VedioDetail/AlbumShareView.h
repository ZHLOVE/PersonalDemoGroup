//
//  AlbumShareView.h
//  ShiJia
//
//  Created by 峰 on 16/9/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoShareDelegate.h"

@interface AlbumShareView : UIView

@property (nonatomic, weak) id<PhotoShareDelegate>photoShareDelegate;

- (void)AlbumShareShowInView:(UIView *)superView;

- (void)hiddleFromSuperView;

@property (nonatomic, strong) NSString *titleString;

@end
