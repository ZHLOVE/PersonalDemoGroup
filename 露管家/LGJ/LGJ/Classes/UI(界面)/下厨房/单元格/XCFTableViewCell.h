//
//  XCFTableViewCell.h
//  LGJ
//
//  Created by student on 16/5/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCFTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *imgView;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *descLabel;
@property (strong, nonatomic)  NSString *urlStr;

@end
