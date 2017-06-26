//
//  ViewController.m
//  MoviePlayer
//
//  Created by student on 16/4/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

// 练习:
// 制作一个媒体文件列表页
// 1. 显示打包中的媒体文件(avi,mkv,mov,m4v,mp4,3gp)
// 2. 显示沙盒中的媒体文件(NSFileManager 遍历沙盒目录下的文件)
// 3. 点击列表中视频弹出播放器播放
#import "ViewController.h"

#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()

@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *mList = [NSMutableArray array];
    // 得到bundle下所有3gp文件路径
    NSArray *arr1 = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"3gp" subdirectory:nil];
    NSArray *arr2 = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"m4v" subdirectory:nil];
    NSArray *arr3 = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"mov" subdirectory:nil];
    
    [mList addObjectsFromArray:arr1];
    [mList addObjectsFromArray:arr2];
    [mList addObjectsFromArray:arr3];
    
    //[[NSBundle mainBundle] pathsForResourcesOfType:@"3gp" inDirectory:nil];
    NSLog(@"%@",mList);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed:(UIButton *)sender {
    //打包中的文件 沙盒中的 网络上的
    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"Movie" withExtension:@"m4v"];
    //创建播放视图控制器
    self.moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:fileUrl];
    //1 弹出方式
    //样式
    self.moviePlayerVC.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    //缩放模式
    self.moviePlayerVC.moviePlayer.scalingMode = MPMovieScalingModeFill;
    //弹出
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerVC];
    // 2. 嵌入当前页面
    //    self.moviePlayerVC.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;// 嵌入Style
    //    self.moviePlayerVC.moviePlayer.scalingMode = MPMovieScalingModeNone;
    //    self.moviePlayerVC.view.frame = CGRectMake(0, 100, 320, 200);
    //    [self.view addSubview:self.moviePlayerVC.view];
    
    // 监听播放器(播放完成)的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDone) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // 播放
    [self.moviePlayerVC.moviePlayer play];
    
    
}

- (void)playDone
{
    NSLog(@"播放完毕了,关闭播放器");
    
    [self dismissMoviePlayerViewControllerAnimated];
}
















@end