//
//  SJPayTypeCell.h
//  ShiJia
//
//  Created by 峰 on 2016/12/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJPayTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (assign, nonatomic) BOOL isCheck;

@end
