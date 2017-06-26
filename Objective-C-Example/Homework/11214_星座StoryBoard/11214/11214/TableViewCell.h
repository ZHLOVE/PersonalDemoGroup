//
//  TableViewCell.h
//  11214
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constellation.h"

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *Fortune;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UITextView *Text;


@property(nonatomic,weak) Constellation *constellation;

@end
