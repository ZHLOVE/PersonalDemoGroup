//
//  SearchListCell.h
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchEntity.h"

extern NSString* const cSearchListCellID;
extern const CGFloat cSearchListCellHeight;
extern const CGFloat cSearchTipsCellHeight ;

/**
 *  显示单个视频信息
 */
@interface SearchListCell : UITableViewCell

/**
 *  要现实的视频
 */
@property (strong, nonatomic) SearchEntity* video;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftLayout;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;

@property (strong, nonatomic) NSString* keyword;

@end
