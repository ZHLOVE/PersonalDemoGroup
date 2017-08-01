//
//  PopoverViewTableViewCell.h
//  TakeoutUserApp
//
//  Created by iss on 14-9-10.
//  Copyright (c) 2014年 YouYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverViewTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *checkImgView;
@property (nonatomic, retain) IBOutlet UIImageView *lineImgView;

@end
