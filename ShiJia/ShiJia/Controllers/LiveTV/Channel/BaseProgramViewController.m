//
//  BaseProgramViewController.m
//  HiTV
//
//  Created by 蒋海量 on 15/1/23.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "BaseProgramViewController.h"
#import "TVProgram.h"

@interface BaseProgramViewController ()
@property (nonatomic) BOOL playDidFailed;
@property (nonatomic) BOOL playDidFinished;
@end

@implementation BaseProgramViewController

- (void)dealloc{
    //[self p_removeVideo];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    if (![self.navigationController.viewControllers containsObject:self] && _videoPlayerViewController) {
//        [self p_removeVideo];
//    }else if([self.navigationController.viewControllers containsObject:self] && self.navigationController.topViewController != self && [_videoPlayerViewController isPlaying]){
//        _videoPlayerViewController.PAUSE_REASON_ViewDisappeared = YES;
//        [_videoPlayerViewController pause];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
//    if (_videoPlayerViewController && self.playDidFailed) {
//        [_videoPlayerViewController pause];
//        
//        [self p_showPlayError];
//    }
//    
//    if([self.navigationController.viewControllers containsObject:self] && self.navigationController.topViewController == self){
//        if (self.playDidFinished) {
//            self.playDidFinished = NO;
//            [self p_removeVideo];
//        }else if(_videoPlayerViewController.PAUSE_REASON_ViewDisappeared){
//            [_videoPlayerViewController play];
//        }
//    }
}

- (void)viewWillLayoutSubviews{
    self.detailCategoryController.view.frame = self.detailContainerView.bounds;
//    if (_videoPlayerViewController && !_videoPlayerViewController.fullScreenModeToggled) {
//        _videoPlayerViewController.view.frame = self.videoContainerView.bounds;
//    }
}

- (void)setDetailCategoryController:(UIViewController *)detailCategoryController{
    _detailCategoryController = detailCategoryController;
    _detailCategoryController.view.backgroundColor = [UIColor clearColor];
    [self.detailContainerView addSubview:detailCategoryController.view];
    [self.view setNeedsLayout];
}

//- (VideoPlayerKit*)videoPlayerViewController{
//    if (_videoPlayerViewController == nil) {
//        _videoPlayerViewController = [VideoPlayerKit videoPlayerWithContainingViewController:self];
//        _videoPlayerViewController.delegate = self;
//        _videoPlayerViewController.allowPortraitFullscreen = NO;
//        //_videoPlayerViewController.view.frame = CGRectMake(0, 0, 320, 180);
//        _videoPlayerViewController.showStaticEndTime = YES;
//        [self.videoContainerView addSubview:self.videoPlayerViewController.view];
//    }
//    return _videoPlayerViewController;
//}
//
#pragma mark - GODETAIL 频道
- (void)playVideo:(NSString*)url andTitle:(NSString*)title andTVProgram:(TVProgram*)tvProgram isStreaming:(BOOL)isStreaming{
   
//    //判断小窗口是否存在（注：由于百度播放器为单例，如果不先关闭小窗口直接播放，会产生崩溃）
//    if ([TPXmppRoomManager defaultManager].showMinimumVideoView) {
//        
//        //存在：关闭小窗口
//        [[TPXmppRoomManager defaultManager] closeMinimumChatRoom:^{
//            
//        }];
//    }
//    NSString* newURL = url;
//    if ([url hasSuffix:@".ts"]) {
//        newURL = [newURL stringByReplacingOccurrencesOfString:@"hot.media.ysten.com" withString:@"phone.media.ysten.com"];
//        newURL = [newURL stringByReplacingOccurrencesOfString:@".ts" withString:@".mp4"];
//        
//    }
//    self.videoPlayerViewController.tvProgram = tvProgram;
//    [self.videoPlayerViewController
//     playVideoWithTitle:tvProgram.programName
//     URL:[NSURL URLWithString:newURL]
//     isStreaming:isStreaming];
//    self.videoPlayerViewController.videoPlayerView.detailLabel.text = title;
//    [self.videoPlayerViewController launchFullScreen];
}

//- (BOOL)hasVideoPlayer{
//    return _videoPlayerViewController != nil;
//}
//
//- (void)p_removeVideo{
//}
//#pragma mark - delegate
//
//- (void)playFinished{
//    self.playDidFinished = YES;
//    [_videoPlayerViewController stop];
//    [_videoPlayerViewController.view removeFromSuperview];
//    _videoPlayerViewController = nil;
//}
//
//
//- (void)playFailed{
//    self.playDidFailed = YES;
//    [_videoPlayerViewController pause];
//    [self p_showPlayError];
//}

#pragma mark - private

- (void)p_showPlayError{
    self.playDidFailed = NO;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"播放失败，请检查网络后重试"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}
@end
