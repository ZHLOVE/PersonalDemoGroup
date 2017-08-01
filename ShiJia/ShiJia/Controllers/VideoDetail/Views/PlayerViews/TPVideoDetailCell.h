//
//  TPVideoDetailCell.h
//  ShiJia
//
//  Created by yy on 16/6/24.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPVideoDetailCellStyle){
    TPVideoDetailCellStyleNormal,
    TPVideoDetailCellStylePlaying,
    TPVideoDetailCellStyleHasPlayed,
    TPVideoDetailCellStyleCannotPlay
};

extern NSString * const kTPVideoDetailCellIdentifier;

@interface TPVideoDetailCell : UICollectionViewCell

@property (nonatomic, assign) TPVideoDetailCellStyle style;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, weak) IBOutlet UIImageView *cornerImg;
@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, strong) id model;

@end
