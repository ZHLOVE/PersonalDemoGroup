//
//  SplashViewModel.m
//  ShiJia
//
//  Created by 峰 on 2017/3/15.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SplashViewModel.h"
#import "UIImageView+WebCache.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageDownloaderOperation.h>
#import <SDWebImage/SDWebImageManager.h>

@interface SplashViewModel ()


@end


@implementation SplashViewModel

- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.downLoadSuccess =  [[NSUserDefaults standardUserDefaults] objectForKey:kDownSuccess];
        [self getCacheLaunchADImage];

    }
    return self;
}


-(void)setSourceURL:(NSString *)sourceURL{
 [self performSelectorInBackground:@selector(downLoadCacheData:) withObject:sourceURL];
}

-(void)setAdmodel:(launchAdModel *)admodel{
    _admodel = admodel;
    [[NSUserDefaults standardUserDefaults] setObject:admodel forKey:kCacheObject];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  @brief 获取当前缓存中 AD 广告
 */
-(void)getCacheLaunchADImage{


    NSDictionary *dict =[[NSUserDefaults standardUserDefaults]objectForKey:kCacheObject];
    self.cacheModel =[launchAdModel mj_objectWithKeyValues:dict];
    if (_cacheModel) {
        self.CacheData = [[NSUserDefaults standardUserDefaults] objectForKey:kCacheData];
        if (!_downLoadSuccess) {
       [self performSelectorInBackground:@selector(downLoadCacheData:) withObject:self.cacheModel.resourceUrl];
        }
    }
}
/**
 *  @brief 下载图片
 *
 *  @param url
 */
//-(void)downLoadCacheImageWithURL:(NSString *)url{
//        dispatch_queue_t concurrentQueue =
//        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(concurrentQueue, ^{
//            __block NSData *data=nil;
//            dispatch_sync(concurrentQueue, ^{
//                data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
//                [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCacheData];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            });
//        });
//
//}

-(void)downLoadCacheData:(NSString *)url{

    NSString *urlStr =[NSString stringWithFormat:@"%@", url];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
            if (data.length>0) {
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCacheData];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kDownSuccess];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kDownSuccess];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kDownSuccess];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    [downLoadTask resume];

}



@end
