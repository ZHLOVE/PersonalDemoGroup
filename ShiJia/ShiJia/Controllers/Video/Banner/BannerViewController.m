//
//  BannerViewController.m
//  HiTV
//
//  created by iSwift on 3/7/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "BannerViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "SJVideoDetailViewController.h"

NSString * const kBannerViewControllerPushDetailNotification = @"BannerViewControllerPushDetailNotification";
NSString * const kBannerViewControllerSelectedVideoKey = @"BannerViewControllerSelectedVideoKey";

@interface BannerViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation BannerViewController
-(void)viewDidLoad{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W, BannerHeight)];
        [self.view addSubview:_imageView];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.imageView.layer.cornerRadius = 4;
    //self.imageView.layer.masksToBounds = YES;

    
    if (self.imageView.image == nil) {
        [self.imageView setImageWithURL:[NSURL URLWithString:self.video.imageUrl]];
    }
}
#pragma mark - GODETAIL 点播滚动图
- (IBAction)buttonTapped:(id)sender {
    //[self showMoiveDetailOrList:self.video.action withVideoID:self.video.videoID];
    VideoSummary *entity = self.video;
    [[NSNotificationCenter defaultCenter] postNotificationName:kBannerViewControllerPushDetailNotification object:self userInfo:@{kBannerViewControllerSelectedVideoKey:entity}];
}

- (void)setVideo:(VideoSummary *)video{
    _video = video;
    
    // not showing title
//    self.titleLabel.text = video.name;
    [self.imageView setImageWithURL:[NSURL URLWithString:video.imageUrl]];
}
@end
