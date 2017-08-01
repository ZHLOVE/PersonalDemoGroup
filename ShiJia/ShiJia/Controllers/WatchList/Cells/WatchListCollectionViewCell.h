//
//  WatchListCollectionViewCell.h
//  HiTV
//
//  Created by lanbo zhang on 8/3/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchListEntity.h"
@protocol WatchListCollectionViewCellDelegate
-(void)refrashWatchList;

@end
@interface WatchListCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) id<WatchListCollectionViewCellDelegate>m_delegate;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (copy, nonatomic) dispatch_block_t playBlock;

@property (copy, nonatomic) NSString* currentUserID;

@property (nonatomic, strong) WatchListEntity* entity;

- (void)updateServerTime:(NSTimeInterval)serverTime;

@end
