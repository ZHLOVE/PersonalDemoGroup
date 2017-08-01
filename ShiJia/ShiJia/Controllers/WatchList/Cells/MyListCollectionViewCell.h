//
//  WatchListCollectionViewCell.h
//  HiTV
//
//  Created by lanbo zhang on 8/1/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchListEntity.h"
#import "WatchListCollectionViewCell.h"
@protocol MyListCollectionViewCellDelegate
- (void)refrashMyList;
@end
@interface MyListCollectionViewCell : WatchListCollectionViewCell
@property (nonatomic,assign) id <MyListCollectionViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *smallThumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *liveLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;

@property (weak, nonatomic) IBOutlet UIButton  *deleteBgBtn;
@property (weak, nonatomic) IBOutlet UIButton  *deleteBtn;

@end
