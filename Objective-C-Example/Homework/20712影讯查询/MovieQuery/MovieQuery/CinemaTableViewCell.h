//
//  CinemaTableViewCell.h
//  MovieQuery
//
//  Created by 马千里 on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cinema.h"

@interface CinemaTableViewCell : UITableViewCell
@property (nonatomic,weak) NSString *uid;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *telephone;

@property(nonatomic,weak) Cinema *cinema;

@end
