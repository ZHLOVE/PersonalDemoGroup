//
//  SJAlbumToolViewController.h
//  ShiJia
//
//  Created by 峰 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SJAlbumModel.h"


typedef void(^ScreenHandleBlock)(BOOL result, NSString *urlString);

@interface SJAlbumToolViewController : UIViewController

@property (nonatomic, strong) UINavigationController *superNavgation;

@property (nonatomic, copy) ScreenHandleBlock screenHandleBlock;
//本地资源
-(void)setLocalModel:(ALAsset *)localModel;
//云资源
-(void)setCloudModel:(CloudPhotoModel *)Model;
//资源类型 图片 视频
@property (nonatomic, assign) Media_TYPE mediatype;

@end
