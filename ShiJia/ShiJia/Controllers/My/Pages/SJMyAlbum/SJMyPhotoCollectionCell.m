//
//  SJMyPhotoCollectionCell.m
//  ShiJia
//
//  Created by 峰 on 16/8/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMyPhotoCollectionCell.h"
#import "UIImageView+WebCache.h"
#define kMyCellSpace 10

@interface SJMyPhotoCollectionCell()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) CGRect cellFrame;
@property (nonatomic, assign) CGFloat ImageWidth;

@end

@implementation SJMyPhotoCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cellFrame = self.frame;
        self.ImageWidth = 108;
        
        
        [self.contentView addSubview:self.backImageView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
}
-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        _backImageView.layer.borderWidth = 3;
        _backImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _backImageView.frame = CGRectMake((_cellFrame.size.width-self.ImageWidth)/2, (_cellFrame.size.height-self.ImageWidth)/2, self.ImageWidth, self.ImageWidth);
        _backImageView.transform=CGAffineTransformMakeRotation(M_PI/30);
        _backImageView.layer.allowsEdgeAntialiasing = true;
        _backImageView.layer.shouldRasterize = YES;
    }
    
    return _backImageView;
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.frame = CGRectMake((_cellFrame.size.width-self.ImageWidth)/2, (_cellFrame.size.height-self.ImageWidth)/2, self.ImageWidth, self.ImageWidth);
        _imageView.layer.borderWidth = 3;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }
    
    return _imageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        
        _nameLabel.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y+self.ImageWidth+10, self.ImageWidth,_cellFrame.size.height-self.imageView.frame.origin.y-self.ImageWidth);
        [_nameLabel setTextColor:[UIColor lightGrayColor]];
        _nameLabel.textAlignment = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _nameLabel;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
}
-(void)setCellWithDict:(CloudAlbumModel *)model{
    
    if ([model.name containsString:@"(用户已退圈)"]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@家的相册",model.uid];
    }else{
   
        self.nameLabel.text = model.name;
    }
    if (model.code.length==0) {
        self.backImageView.image = model.imageV;
        self.imageView.image = model.imageV;
    }else{
        NSString *imageUrlString = [NSString stringWithFormat:@"%@%@",model.coverUrl,@"!/fw/100/fh/100"];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"xiangce_default"]];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"xiangce_default"]];
    }

    CGFloat border = 1;
    CGRect imageRect = CGRectMake(0, 0, _backImageView.image.size.width, _backImageView.image.size.height);
    UIGraphicsBeginImageContext(imageRect.size);
    [_backImageView.image drawInRect:CGRectMake(border,border,_backImageView.image.size.width-border*2,_backImageView.image.size.height-border*2)];
    UIImage* newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backImageView.image = newImg;
}
@end
