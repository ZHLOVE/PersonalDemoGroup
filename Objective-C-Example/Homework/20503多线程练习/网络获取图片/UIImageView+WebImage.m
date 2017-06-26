//
//  UIImageView+WebImage.m
//  网络获取图片
//
//  Created by student on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "UIImageView+WebImage.h"

@implementation UIImageView (WebImage)

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error;
        NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if(error == nil)
        {
            self.image = [UIImage imageWithData:data];
        }
    }
    return self;
}

@end
