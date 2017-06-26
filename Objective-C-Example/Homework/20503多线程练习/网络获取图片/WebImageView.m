//
//  WebImageView.m
//  网络获取图片
//
//  Created by student on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "WebImageView.h"

@implementation WebImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (error == nil) {
            self.image = [UIImage imageWithData:data];
        }
    }
    return self;
}

@end
