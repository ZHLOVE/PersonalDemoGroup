//
//  WatchListCollectionViewCell.m
//  HiTV
//
//  Created by lanbo zhang on 8/3/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "WatchListCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "HiTVGlobals.h"

@implementation WatchListCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.thumbnailImageView.image = nil;
}

- (void)setEntity:(WatchListEntity *)entity {
    _entity = entity;
    
    self.reasonLabel.text = entity.reason;
    self.nameLabel.text = entity.programSeriesName;
    
    //self.durationLabel.text = entity.duration;
}

- (void)updateServerTime:(NSTimeInterval)serverTime {
    
}

- (NSString*)p_currentUID {
    //    return @"10000378";
    //return @"10000115";
    return [HiTVGlobals sharedInstance].uid;
}

- (IBAction)buttonTapped:(id)sender {
    if (self.playBlock) {
       // self.playBlock();
    }
}

@end
