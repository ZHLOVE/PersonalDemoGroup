//
//  UIImageView+Webcache_Animation.m
//  duolaimeifa
//
//  Created by dexter on 14/11/9.
//  Copyright (c) 2014年 leqi. All rights reserved.
//

#import "UIImageView+Webcache_Animation.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Webcache_Animation)

-(void) setImageWithURL:(NSURL *)url
            placeholder:(UIImage *)placeholder
        placeholder_err:(UIImage *)placeholder_err
               animated:(BOOL)animated {
    //空图片bug
    if (url == nil) {
        self.image = placeholder_err;
        return;
    }
    
    __weak id weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (image == nil) {
                           image = placeholder_err;
                       }
                       if (image && cacheType == SDImageCacheTypeNone && animated) {
                           if (placeholder == nil) {
                               [weakSelf setAlpha:0];
                               [UIView animateWithDuration:0.35f
                                                animations:^{
                                                    [weakSelf setAlpha:1];
                                                }];
                               
                           } else {
                               [UIView transitionWithView:weakSelf
                                                 duration:0.35f
                                                  options:UIViewAnimationOptionTransitionCrossDissolve
                                               animations:^{
                                                   [weakSelf setImage:image];
                                               }
                                               completion:nil];
                           }
                       }
                   }
     ];
}

@end
