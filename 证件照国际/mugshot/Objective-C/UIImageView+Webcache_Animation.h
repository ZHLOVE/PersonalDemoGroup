//
//  UIImageView+Webcache_Animation.h
//  duolaimeifa
//
//  Created by dexter on 14/11/9.
//  Copyright (c) 2014年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Webcache_Animation)
-(void) setImageWithURL:(NSURL *)url
            placeholder:(UIImage *)placeholder
        placeholder_err:(UIImage *)placeholder_err
               animated:(BOOL)animated;
@end
