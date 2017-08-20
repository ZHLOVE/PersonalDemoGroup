//
//  ImageViewController.m
//  Blink
//
//  Created by MBP on 2016/12/29.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ImageViewController.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface ImageViewController ()

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImageView *photoImageView;


@end

@implementation ImageViewController


- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.photoImageView];

}


- (UIImageView *)photoImageView{
    if (_photoImageView == nil) {
        _photoImageView = [[UIImageView alloc]initWithImage:_image];
        _photoImageView.frame = self.view.frame;
        _photoImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _photoImageView;
}

@end
