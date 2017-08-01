//
//  RecordView.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/24.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "RecordView.h"

@implementation RecordView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.videoName.textColor = [UIColor lightGrayColor];
    self.videoName.font = [UIFont systemFontOfSize:12];
    [self.videoLogo setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.videoLogo.contentMode =  UIViewContentModeScaleAspectFill;
    self.videoLogo.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.videoLogo.clipsToBounds  = YES;
}
- (void)layoutSubviews
{
    [super layoutSubviews];    
}
@end
