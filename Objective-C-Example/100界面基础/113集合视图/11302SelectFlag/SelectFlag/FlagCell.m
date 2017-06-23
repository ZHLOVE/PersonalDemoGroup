//
//  FlagCell.m
//  SelectFlag
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "FlagCell.h"

@implementation FlagCell

- (void)setFlag:(FlagModel *)flag
{
    _flag = flag;
    
    self.countryFlagImageView.image = [UIImage imageNamed:flag.imageName];
    self.countryNameLabel.text = flag.name;
}
@end
