//
//  HiTVDateView.h
//  HiTV
//
//  created by iSwift on 3/26/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiTVDateView : UIView

/**
 *  日期显示
 */
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)setSelected:(BOOL)selected;

@end
