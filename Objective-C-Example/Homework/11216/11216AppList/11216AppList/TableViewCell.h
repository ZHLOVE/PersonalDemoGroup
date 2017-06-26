//
//  TableViewCell.h
//  11215
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppsModel.h"


@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *uiImageView;
@property (weak, nonatomic) IBOutlet UILabel *softName;
@property (weak, nonatomic) IBOutlet UILabel *fortune;
@property (weak, nonatomic) IBOutlet UITextView *edition;

@property(nonatomic,weak) AppsModel *App;

@end
