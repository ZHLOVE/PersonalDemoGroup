//
//  SJMyPhotoCollectionCell.h
//  ShiJia
//
//  Created by 峰 on 16/8/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJMyPhotoCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel;
-(void)setCellWithDict:(NSDictionary *)modelDict;
@end