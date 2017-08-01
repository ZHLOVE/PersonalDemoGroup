//  Created by 峰 on 16/7/22.
//  Copyright © 2016年 mhh. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WatchListEntity.h"

@protocol guestDelegate;


typedef void(^NavigationButtonClick)(UIButton *sender);

@interface SJGuestYouLikeViewController : UIViewController

@property (nonatomic, copy)   NavigationButtonClick clickBlock;
@property (nonatomic, weak)   id<guestDelegate> deleage;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *modelsArray;
@property (nonatomic, assign) BOOL currentScreenisFull;
@end

@protocol guestDelegate <NSObject>

-(void)chooseOneWatchEntityFromGuestList:(WatchListEntity *)model;

@end
