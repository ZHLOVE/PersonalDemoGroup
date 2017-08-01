//
//  TPDownloadVideoManager.m
//  HiTV
//
//  Created by yy on 15/10/28.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPDownloadVideoManager.h"
#import "MLDataCache.h"
#import "MLDataResponseSerializer.h"
#import "TPFileOperation.h"

#define kTPDownloadVideoManagerErrorDomain @"TPDownloadVideoManagerErrorDomain"

static dispatch_queue_t cachedata_concurrent_queue() {
    static dispatch_queue_t ml_cachedata_concurrent_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ml_cachedata_concurrent_queue = dispatch_queue_create("com.molon.ml_cache_data_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return ml_cachedata_concurrent_queue;
}

typedef NS_OPTIONS(NSUInteger, TPDownloadVideoManagerState) {
    TPDownloadVideoManagerStateNone = 0,
    TPDownloadVideoManagerStateNormal,
    TPDownloadVideoManagerStateDownloading,
};

@interface TPDownloadVideoManager ()

@property (nonatomic, strong) AFHTTPRequestOperation *af_dataRequestOperation;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSURL *filePath;

@end

@implementation TPDownloadVideoManager

#pragma mark - download
- (void)downloadMp4FileWithURL:(NSURL *)URL success:(void (^)(NSURL* videoPath))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [self setVideoWithURLRequest:request success:success failure:failure];
}

#pragma mark - cancel
- (void)cancelVideoRequestOperation
{
    [self.af_dataRequestOperation cancel];
    self.af_dataRequestOperation = nil;
}


- (void)setVideoWithURLRequest:(NSURLRequest *)urlRequest success:(void (^)(NSURL* videoPath))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    self.videoURL = [urlRequest URL];
    
    
    self.filePath = nil;
    [self cancelVideoRequestOperation];
    
    if ([self.videoURL isFileURL]) {
        if (success) {
            success(self.videoURL);
        } else if (self.videoURL) {
            self.filePath = self.videoURL;
        }
        return;
    }
    
    if (nil==self.videoURL) {
        if (success) {
            success(self.videoURL);
        }
        return;
    }
    
    NSURL *filePath = [self cachedFilePathForRequest:urlRequest];
    if (filePath) {
        if (success) {
            success(filePath);
        } else {
            self.filePath = filePath;
        }
        self.af_dataRequestOperation = nil;
    } else {
        //        self.VideoState = MLPlayVideoButtonStateDownloading;
        
        //DLOG(@"下载视频%@",[urlRequest URL]);
        __weak __typeof(self)weakSelf = self;
        self.af_dataRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        self.af_dataRequestOperation.responseSerializer = [MLDataResponseSerializer shareInstance];
        
        [self.af_dataRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if ([[urlRequest URL] isEqual:[operation.request URL]]) {
                //写入文件
                [strongSelf writeDataToDocument:responseObject success:^(NSURL *filePath) {
                    if (success) {
                        
                        success(filePath);
                    } else if (filePath) {
                        strongSelf.filePath = filePath;
                    }
                    
                } failure:^{
                    NSError *error = [NSError errorWithDomain:kTPDownloadVideoManagerErrorDomain code:101 userInfo:@{NSLocalizedDescriptionKey:@"写入视频缓存文件失败"}];
                    if (failure) {
                        failure(urlRequest, operation.response, error);
                    }
                }];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([[urlRequest URL] isEqual:[operation.request URL]]) {
                if (failure) {
                    failure(urlRequest, operation.response, error);
                }
            }
        }];
        
        [[MLDataResponseSerializer sharedDataRequestOperationQueue] addOperation:self.af_dataRequestOperation];
    }
}

#pragma mark -
- (void)writeDataToDocument:(NSData *)data success:(void(^)(NSURL *filePath))success failure:(void(^)())failure
{
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *fileName = [NSString stringWithFormat:@"%@_movie.mp4",[formatter stringFromDate:date]];
//    
//    NSString *filePath  = [self filePathWithName:fileName];
    NSString *filePath  = [TPFileOperation getShortVideoPathWithURL:self.videoURL];
    if (filePath) {
        dispatch_async(cachedata_concurrent_queue(), ^{
            
            //下面这玩意是线程安全的，不用害怕
            if(![[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil]){
                //DLOG(@"建立文件缓存:%@失败",filePath);
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure();
                    });
                }
            }else{
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success([NSURL fileURLWithPath:filePath]);
                    });
                }
            }
        });
    }
}

- (NSURL*)cachedFilePathForRequest:(NSURLRequest *)request
{
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    
    //直接从文件夹里找
    NSString *filePath = [TPFileOperation getShortVideoPathWithURL:request.URL];
    if ([[NSFileManager defaultManager] isReadableFileAtPath:filePath]) {
        return [NSURL fileURLWithPath:filePath];
    }
    
    return nil;
}

@end
