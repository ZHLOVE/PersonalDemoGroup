//
//  homeComplicateItemCell.m
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "homeComplicateItemCell.h"
#import "CustomView.h"
#import "CornerEntity.h"
#import "FLAnimatedGif.h"
#import "FLAnimatedImageView.h"
#import "UIImage+GIF.h"

#define itemImageHeight 95.
#define nameLabelHeight 15.
#define descLabelHeight 12.
#define cornerViewWidth 30.


@interface homeComplicateItemCell ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView  *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel      *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel      *descriptionLabel;
@property (nonatomic, strong) CustomView            *cornerView;

@end

@implementation homeComplicateItemCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self addSubviewsLayoutConstraints];
    _cornerView =[[CustomView alloc]initWithFrame:_itemImageView.frame];
    _cornerView.sizeToWidth = cornerViewWidth;
    [self addSubview:_cornerView];
}

-(void)addSubviewsLayoutConstraints{

    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(0);
        make.height.mas_equalTo(AutoSize_H_IP6(itemImageHeight));
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(nameLabelHeight);
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.itemImageView.mas_bottom).offset(10);
    }];

    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(descLabelHeight);
    }];
}


-(void)setCellModel:(contents *)cellModel{

    if ([cellModel.resourceType isEqualToString:@"pic"]) {

        self.itemImageView.layer.masksToBounds = YES;
        [self.itemImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.itemImageView.contentMode =  UIViewContentModeScaleAspectFill;
        self.itemImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.itemImageView.clipsToBounds  = YES;

        [_itemImageView setImageWithURL:[NSURL URLWithString:cellModel.resourceUrl] placeholderImage:[UIImage imageNamed:@"third"]];

    }
    if ([cellModel.resourceType isEqualToString:@"gif"]) {
        _itemImageView.image = [UIImage imageNamed:@"third"];
        [self loadAnimatedImageWithURL:[NSURL URLWithString:cellModel.resourceUrl]
                            completion:^(FLAnimatedGif *animatedImage) {
                                _itemImageView.animatedImage = animatedImage;
                            }];
    }

    self.nameLabel.text = cellModel.title;
    self.descriptionLabel.text = cellModel.subTitle;

    if (cellModel.cornerImg.length>0) {
        CornerEntity *entity = [CornerEntity new];
        entity.cornerImg = cellModel.cornerImg;
        entity.position = cellModel.position;

        [_cornerView useViewCorners:entity];
    }
}
- (void)loadAnimatedImageWithURL:(NSURL *const)url completion:(void (^)(FLAnimatedGif *animatedImage))completion
{
    NSString *const filename = url.lastPathComponent;
    NSString *const diskPath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];

    NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:diskPath];
    FLAnimatedGif * __block animatedImage = [[FLAnimatedGif alloc] initWithAnimatedGIFData:animatedImageData];

    if (animatedImage) {
        if (completion) {
            completion(animatedImage);
        }
    } else {
        [[[NSURLSession sharedSession] dataTaskWithURL:url
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         animatedImageData = data;
                                         animatedImage = [[FLAnimatedGif alloc] initWithAnimatedGIFData:animatedImageData];
                                         if (animatedImage) {
                                             if (completion) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     completion(animatedImage);
                                                     
                                                 });
                                             }
                                             [data writeToFile:diskPath atomically:YES];
                                             
                                         }
                                     }] resume];
    }
}

@end
