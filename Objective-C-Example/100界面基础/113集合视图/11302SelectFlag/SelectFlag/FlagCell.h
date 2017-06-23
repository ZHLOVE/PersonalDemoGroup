//
//  FlagCell.h
//  SelectFlag
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlagModel.h"

@interface FlagCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *countryFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;

@property (nonatomic,strong) FlagModel *flag;

@end
