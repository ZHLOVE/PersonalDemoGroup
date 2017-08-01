//
//  CircularlyCell.m
//  ShiJia
//
//  Created by 峰 on 2017/3/6.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "CircularlyCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

@interface CircularlyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;


@end

@implementation CircularlyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCurrentContents:(contents *)currentContents{
    _currentContents = currentContents;
    if ([currentContents.resourceType isEqualToString:@"pic"]) {
        [self.cellImageView setImageWithURL:[NSURL URLWithString:currentContents.resourceUrl] placeholder:[UIImage imageNamed:@"bannerdefault"]];
    }
    if ([currentContents.resourceType isEqualToString:@"gif"]) {
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            __block NSData *data=nil;
            dispatch_sync(concurrentQueue, ^{
                /* Download the image here */
                data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:currentContents.resourceUrl]];
            });
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.cellImageView.image = [UIImage sd_animatedGIFWithData:data];
            });
        });

    }


}

@end
