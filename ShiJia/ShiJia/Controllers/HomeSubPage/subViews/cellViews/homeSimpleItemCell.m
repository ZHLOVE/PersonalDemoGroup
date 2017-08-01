//
//  homeSimpleItemCell.m
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "homeSimpleItemCell.h"
#import "UIImageView+WebCache.h"
@interface homeSimpleItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;

#define itemImageWidth 35.
#define topSpace 15.
#define bottomSpace 13.

@end

@implementation homeSimpleItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubviewsLayoutConstraints];
}
-(void)addSubviewsLayoutConstraints{
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SJRealValue_W(itemImageWidth),SJRealValue_W(itemImageWidth)));
        make.top.mas_equalTo(self).offset(SJRealValue_W(topSpace));
        make.centerX.mas_equalTo(self);
    }];

    [self.itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-SJRealValue_W(bottomSpace));
    }];
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{

    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return reSizeImage;
    
}

-(void)setCellModel:(contents *)cellModel{
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:cellModel.resourceUrl]];
    //UIImage *tempimage = [UIImage imageWithData:data];
//    self.itemImageView.image = [self reSizeImage:tempimage toSize:CGSizeMake(20, 20)];
    //self.itemImageView.image = [self scaleImage:tempimage toScale:1];
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.resourceUrl] placeholderImage:nil];
    self.itemNameLabel.text = cellModel.title;
}

@end
