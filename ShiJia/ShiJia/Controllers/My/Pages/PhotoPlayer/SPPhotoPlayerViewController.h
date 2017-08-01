//
//  TWPhotoPickerController.h
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPPhotoPlayerView.h"
//#import "MusicBaseViewController.h"

@class SPPhotoPlayerView;


@interface SPPhotoPlayerViewController : BaseViewController<SPPhotoPlayerViewDelegate>
{
    
}
@property (strong, nonatomic) NSMutableArray *assets;

@property (nonatomic, copy) void(^cropBlock)(UIImage *image);
@property (nonatomic, strong) SPPhotoPlayerView *photoPlayerView;
@end
