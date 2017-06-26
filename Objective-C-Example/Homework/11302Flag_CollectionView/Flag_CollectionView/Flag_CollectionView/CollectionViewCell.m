//
//  CollectionViewCell.m
//  Flag_CollectionView
//
//  Created by student on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)setFlag:(FlagData *)flag{
    _flag = flag;
    self.imageView.image = [UIImage imageNamed:self.flag.imageName];
    self.label.text = self.flag.name;
    
}

@end

