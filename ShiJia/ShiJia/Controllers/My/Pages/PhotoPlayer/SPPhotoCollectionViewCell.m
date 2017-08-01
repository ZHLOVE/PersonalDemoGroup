//
//  TWPhotoCollectionViewCell.m
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import "SPPhotoCollectionViewCell.h"

@implementation SPPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
        [self.contentView addSubview:self.imageView];
        // add by Allen
        self.selcetImage = [UIImageView new];
        [self.contentView addSubview:self.selcetImage];
        [self.selcetImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    self.selcetImage.image =  selected?[UIImage imageNamed:@"contact_list_checked"]:nil;
//    self.imageView.layer.borderWidth = selected ? 2 : 0;
}

@end
