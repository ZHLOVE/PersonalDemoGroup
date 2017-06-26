//
//  TableViewCell.h
//  11215
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"


@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *text;

@property(nonatomic,weak) NewsModel *news;

@end
