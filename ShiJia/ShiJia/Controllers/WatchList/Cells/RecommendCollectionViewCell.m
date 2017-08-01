//
//  WatchListCollectionViewCell.m
//  HiTV
//
//  Created by lanbo zhang on 8/1/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "RecommendCollectionViewCell.h"
#import "BaseAFHTTPManager.h"
#import "HiTVGlobals.h"
#import <YYKit/YYLabel.h>

@interface RecommendCollectionViewCell (){
    CAGradientLayer *headerLayer;
}
@property (weak, nonatomic) IBOutlet UIImageView *adImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet YYLabel *descLabel;


@end
@implementation RecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topView.backgroundColor = RGB(0, 0, 0, 0);
    //self.descLabel.textVerticalAlignment = YYTextVerticalAlignmentBottom;
    self.descLabel.hidden = YES;
    _descLabel = [[YYLabel alloc]init];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.font = [UIFont systemFontOfSize:12];
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.numberOfLines = 0;
    _descLabel.textVerticalAlignment = YYTextVerticalAlignmentBottom;
    [self addSubview:_descLabel];
    
    [self insertTransparentGradient];
}
- (void)setEntity:(WatchListEntity *)entity {
    [super setEntity:entity];
    self.descLabel.text = entity.reason;

    if (entity.reason.length == 0) {
         self.descLabel.text = entity.programSeriesDesc;

    }
    if (entity.verticalPosterAddr.length == 0) {
//        [self.imageView setImageWithURL:[NSURL URLWithString:entity.posterAddr]];
        [self.imageView setImageWithURL:[NSURL URLWithString:entity.posterAddr] placeholder:[UIImage imageNamed:@"loadingImage"]];

    }
    else{
        [self.imageView setImageWithURL:[NSURL URLWithString:entity.verticalPosterAddr] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    }
    if ([entity.contentType isEqualToString:@"ad"]) {
        self.topView.hidden = YES;
        self.titleLabel.hidden = YES;
        self.descLabel.hidden = YES;
        self.adImg.hidden = NO;
        if (entity.verticalPosterAddr.length == 0) {
            [self.adImg setImageWithURL:[NSURL URLWithString:entity.posterAddr]];
            
        }
        else{
            [self.adImg setImageWithURL:[NSURL URLWithString:entity.verticalPosterAddr] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        }
    }
    else{
        self.topView.hidden = NO;
        self.titleLabel.hidden = NO;
        self.descLabel.hidden = NO;
        self.adImg.hidden = YES;
    }

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    headerLayer.frame = self.topView.bounds;
    self.descLabel.frame = CGRectMake(5, self.frame.size.height-75, self.frame.size.width-10, 40);
}
- (void) insertTransparentGradient {
    UIColor *colorOne = RGB(0, 0, 0, 0);;
    UIColor *colorTwo = RGB(0, 0, 0, 1);;
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.topView.bounds;
    
    //[self.layer insertSublayer:headerLayer atIndex:0];
    
    [self.topView.layer addSublayer:headerLayer];
}
@end
