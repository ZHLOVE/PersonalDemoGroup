//
//  CustomView.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/1/18.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "CustomView.h"
#import "WatchFocusVideoProgramEntity.h"
#import "VideoSource.h"
#import "TVProgram.h"
#import "CornerEntity.h"

@interface CustomView()

@property (strong, nonatomic) IBOutlet UIImageView *t_leftImg;
@property (strong, nonatomic) IBOutlet UIImageView *t_rightImg;
@property (strong, nonatomic) IBOutlet UIImageView *b_leftImg;
@property (strong, nonatomic) IBOutlet UIImageView *b_rightImg;

@end
@implementation CustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)useViewCorners:(id)model{
    self.t_leftImg.image = nil;
    self.t_rightImg.image = nil;
    self.b_leftImg.image = nil;
    self.b_rightImg.image = nil;

    WatchFocusVideoProgramEntity *entity = model;
    if ([entity.class isSubclassOfClass:[WatchFocusVideoProgramEntity class]]) {
        
    }
    else if ([entity.class isSubclassOfClass:[VideoSource class]]){
        VideoSource *videoSource = (VideoSource *)entity;
        for (CornerEntity *cornerEntity in videoSource.cornerArray) {
            if (cornerEntity.position.intValue == 1) {
                [self.t_leftImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
                
            }
            else if (cornerEntity.position.intValue == 2) {
                [self.b_leftImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
                
            }
            else if (cornerEntity.position.intValue == 3) {
                [self.t_rightImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
                
            }
           else if (cornerEntity.position.intValue == 4) {
                [self.b_rightImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
                
            }
        }
    }
    else if ([entity.class isSubclassOfClass:[TVProgram class]]){
        TVProgram *videoSource = (TVProgram *)entity;
        for (CornerEntity *cornerEntity in videoSource.cornerArray) {
            if (cornerEntity.position.intValue == 1) {
                [self.t_leftImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
                
            }
            else if (cornerEntity.position.intValue == 2) {
                [self.b_leftImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
                
            }
            else if (cornerEntity.position.intValue == 3) {
                [self.t_rightImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
                
            }
            else if (cornerEntity.position.intValue == 4) {
                [self.b_rightImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
                
            }
        }
    }
    else if ([entity.class isSubclassOfClass:[NSArray class]]){
        for (CornerEntity *cornerEntity in model) {
            if (cornerEntity.position.intValue == 1) {
                [self.t_leftImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];

            }
            else if (cornerEntity.position.intValue == 2) {
                [self.b_leftImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];

            }
            else if (cornerEntity.position.intValue == 3) {
                [self.t_rightImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];

            }
            else if (cornerEntity.position.intValue == 4) {
                [self.b_rightImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];

            }
        }


    }
}
-(void)setSizeToWidth:(float)sizeToWidth{
    _sizeToWidth = sizeToWidth;
    _t_leftImg.frame = CGRectMake(0, 0, self.sizeToWidth, self.sizeToWidth);
    _t_rightImg.frame = CGRectMake(self.frame.size.width-self.sizeToWidth, 0, self.sizeToWidth, self.sizeToWidth);
    _b_leftImg.frame = CGRectMake(0, self.frame.size.height-self.sizeToWidth, self.sizeToWidth, self.sizeToWidth);
    _b_rightImg.frame = CGRectMake(self.frame.size.width-self.sizeToWidth, self.frame.size.height-self.sizeToWidth, self.sizeToWidth, self.sizeToWidth);

}
-(UIImageView *)t_leftImg{
    if (!_t_leftImg) {
        _t_leftImg = [UIImageView new];
        _t_leftImg.backgroundColor = [UIColor clearColor];
        _t_leftImg.frame = CGRectMake(0, 0, self.sizeToWidth, self.sizeToWidth);
        [self addSubview:_t_leftImg];
    }
    return _t_leftImg;
}
-(UIImageView *)t_rightImg{
    if (!_t_rightImg) {
        _t_rightImg = [UIImageView new];
        _t_rightImg.backgroundColor = [UIColor clearColor];
        _t_rightImg.frame = CGRectMake(self.frame.size.width-self.sizeToWidth, 0, self.sizeToWidth, self.sizeToWidth);
        [self addSubview:_t_rightImg];
    }
    return _t_rightImg;
}
-(UIImageView *)b_leftImg{
    if (!_b_leftImg) {
        _b_leftImg = [UIImageView new];
        _b_leftImg.backgroundColor = [UIColor clearColor];
        _b_leftImg.frame = CGRectMake(0, self.frame.size.height-self.sizeToWidth, self.sizeToWidth, self.sizeToWidth);
        [self addSubview:_b_leftImg];
    }
    return _b_leftImg;
}
-(UIImageView *)b_rightImg{
    if (!_b_rightImg) {
        _b_rightImg = [UIImageView new];
        _b_rightImg.backgroundColor = [UIColor clearColor];
        _b_rightImg.frame = CGRectMake(self.frame.size.width-self.sizeToWidth, self.frame.size.height-self.sizeToWidth, self.sizeToWidth, self.sizeToWidth);
        [self addSubview:_b_rightImg];
    }
    return _b_rightImg;
}

@end
