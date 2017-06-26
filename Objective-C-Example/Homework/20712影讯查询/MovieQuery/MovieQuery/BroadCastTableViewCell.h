//
//  BroadCastTableViewCell.h
//  MovieQuery
//
//  Created by student on 16/4/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Movie.h"
@interface BroadCastTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hallLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,weak) Movie *movieHell;
@end
