//
//  HiTVDateView.m
//  HiTV
//
//  created by iSwift on 3/26/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "HiTVDateView.h"

@implementation HiTVDateView
//modify by jianghailiang
- (void)setSelected:(BOOL)selected{
    if (!selected) {
        //self.dateLabel.textColor = [HiTVConstants titleColorForDefaultText];
        self.dateLabel.textColor = [UIColor lightGrayColor];
        
    }else{
        //self.dateLabel.textColor = [HiTVConstants titleColorForSelectedTVText];
        self.dateLabel.textColor = kColorBlueTheme;
    }
    self.weekdayLabel.textColor = self.dateLabel.textColor;
}

@end
