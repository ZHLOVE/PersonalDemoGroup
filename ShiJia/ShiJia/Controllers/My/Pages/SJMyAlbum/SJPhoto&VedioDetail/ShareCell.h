//
//  ShareCell.h
//  ShiJia
//
//  Created by 峰 on 2017/2/24.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView  *iconImage;
@property (weak, nonatomic) IBOutlet UILabel      *title;

@property (nonatomic, strong) NSDictionary *cellmodelDict;


@end
