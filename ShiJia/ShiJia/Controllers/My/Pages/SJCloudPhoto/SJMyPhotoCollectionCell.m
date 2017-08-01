//
//  SJMyPhotoCollectionCell.m
//  ShiJia
//
//  Created by 峰 on 16/8/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMyPhotoCollectionCell.h"
#define kMyCellSpace 30

@interface SJMyPhotoCollectionCell()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) CGRect cellFrame;
@property (nonatomic, assign) CGFloat NameWidth;
@property (nonatomic, assign) CGFloat ImageWidth;

@end

@implementation SJMyPhotoCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cellFrame = self.frame;
        self.ImageWidth = self.frame.size.width-2*kMyCellSpace;
        self.NameWidth = self.frame.size.width;
        
        [self.contentView addSubview:self.backImageView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
}
-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        _backImageView.layer.borderWidth = 2;
        _backImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _backImageView.frame = CGRectMake(kMyCellSpace, kMyCellSpace, self.ImageWidth, self.ImageWidth);
        _backImageView.transform=CGAffineTransformMakeRotation(M_PI/30);
        _backImageView.layer.allowsEdgeAntialiasing = true;
        _backImageView.layer.shouldRasterize = YES;
//        CGContextSetAllowsAntialiasing(theContext, true);
//        CGContextSetShouldAntialias(theContext, true);
    }
    
    return _backImageView;
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.frame = CGRectMake(kMyCellSpace, kMyCellSpace, self.ImageWidth, self.ImageWidth);
        _imageView.layer.borderWidth = 2;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }

    return _imageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.frame = CGRectMake(0, kMyCellSpace+self.ImageWidth, self.NameWidth,self.frame.size.height-kMyCellSpace-self.ImageWidth);
        [_nameLabel setTextColor:[UIColor lightGrayColor]];
        _nameLabel.textAlignment = 1;
    }
    return _nameLabel;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
}
-(void)setCellWithDict:(NSDictionary *)modelDict{
    self.nameLabel.text = [modelDict objectForKey:@"photoName"];
    self.backImageView.image = (UIImage *)[modelDict objectForKey:@"photoImage"];
    self.imageView.image = (UIImage *)[modelDict objectForKey:@"photoImage"];
}
@end
