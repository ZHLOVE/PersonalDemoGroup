//
//  VideoHomeCollectionViewCell.h
//  ShiJia
//
//  Created by 蒋海量 on 16/7/22.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const cVideoHomeCollectionViewCellID;

@interface VideoHomeCollectionViewCell : UICollectionViewCell
@property(weak,nonatomic) IBOutlet UIImageView *imgView;
@property(weak,nonatomic) IBOutlet UILabel *titleLab;

@end
