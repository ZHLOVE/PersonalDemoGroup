//
//  SJLocailFileScreen.m
//  ShiJia
//
//  Created by 峰 on 16/7/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLocailFileScreen.h"
#import "UpYun.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SJLocailFileResponseModel.h"
#import "HiTVWebServer.h"
#import "TogetherManager.h"
#import "ScreenDeviceInfo.h"
#import "UIImage+Orientation.h"

//视频存储路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

@interface SJLocailFileScreen ()

@property (nonatomic, strong) UpYun *upYunClass;
@end

@implementation SJLocailFileScreen


+(void)SJ_locailFileScreen:(ALAsset *)params
               andFileType:(int)type
                     Block:(void(^)(id result,NSError *error,CGFloat percent))block {

    //同网异网
    if ([[TogetherManager sharedInstance].connectedDevice.state isEqualToString:TOGETHER_SAME_NET]) {

        [[HiTVWebServer sharedInstance]start];
        NSString *tempUrlString =[[params valueForProperty:ALAssetPropertyAssetURL] description];
        [[HiTVWebServer sharedInstance] webURLForLocalUrl:tempUrlString];

        [HiTVWebServer sharedInstance].block = ^(NSString* urlString) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setValue:@(200) forKey:@"code"];
            [dict setValue:@"shijia" forKey:@"sign"];
            [dict setValue:@"成功" forKey:@"message"];
            [dict setValue:urlString forKey:@"url"];
            SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:dict];
            block(model,nil,100);
        };

    }else{
        if (type==0) {
            CGImageRef imageRef = params.defaultRepresentation.fullScreenImage;
            UIImage *image = [UIImage imageWithCGImage:imageRef
                                                 scale:params.defaultRepresentation.scale
                                           orientation:(UIImageOrientation)params.defaultRepresentation.orientation];

            NSData *date =  UIImageJPEGRepresentation(image, 0.2);

            [UPYUNConfig sharedInstance].DEFAULT_BUCKET = UPaiYunKey1;
            [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = UPaiYunKey2;
            [UPYUNConfig sharedInstance].FormAPIDomain = BIMS_CLOUD_ALBUMS_UPLOAD_URL;
            UpYun *uy = [[UpYun alloc] init];
            uy.successBlocker = ^(NSURLResponse *response, id responseData) {

                SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
                model.url = [NSString stringWithFormat:@"%@%@!ysten",CLOUD_SERVER,model.url];
                block(model,nil,1);

            };
            uy.failBlocker = ^(NSError * error) {

                block(nil,error,0);
            };
            uy.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {

                block(nil,nil,percent);
            };
            [uy uploadFile: date
                   saveKey:[[SJLocailFileScreen new]getSaveKeyWith:@"jpg" ]];
        }else{

            NSURL *PATHURL= [params valueForProperty:ALAssetPropertyAssetURL];
            if ([params defaultRepresentation].size>(1024*1024*10)) {
                NSString *domain = @"com.MyCompany.MyApplication.ErrorDomain";
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:@"当前文件大于10M" };
                NSError *error = [NSError errorWithDomain:domain
                                                     code:-101
                                                 userInfo:userInfo];
                block(nil,error,0);


            }else{

                NSFileManager * fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:KVideoUrlPath]) {
                    [fileManager createDirectoryAtPath:KVideoUrlPath
                           withIntermediateDirectories:YES
                                            attributes:nil
                                                 error:nil];
                }
                ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if (PATHURL) {
                        [assetLibrary assetForURL:PATHURL resultBlock:^(ALAsset *asset) {
                            ALAssetRepresentation *rep = [asset defaultRepresentation];
                            NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:@"IOS"];
                            const char *cvideoPath = [videoPath UTF8String];
                            FILE *file = fopen(cvideoPath, "a+");
                            if (file) {
                                const int bufferSize = 1*1024*1024;
                                // 初始化一个1M的buffer
                                Byte *buffer = (Byte*)malloc(bufferSize);
                                NSUInteger read = 0, offset = 0;
                                NSError* err = nil;
                                if (rep.size != 0)
                                {
                                    do {
                                        read = [rep getBytes:buffer
                                                  fromOffset:offset
                                                      length:bufferSize
                                                       error:&err];
                                        //!!!:
                                        fwrite(buffer, sizeof(char), read, file);
                                        offset += read;
                                    } while (read != 0 && !err);//没到结尾，没出错，ok继续
                                }
                                // 释放缓冲区，关闭文件
                                free(buffer);
                                buffer = NULL;
                                fclose(file);
                                file = NULL;

                                dispatch_async(dispatch_get_main_queue(), ^{

                                    NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:@"IOS"];
                                    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = UPaiYunKey1;
                                    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = UPaiYunKey2;
                                    [UPYUNConfig sharedInstance].FormAPIDomain = BIMS_CLOUD_ALBUMS_UPLOAD_URL;
                                    UpYun *uy = [[UpYun alloc] init];
                                    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
                                        SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
                                        //                                    model.url = [model.url stringByAppendingString:CLOUD_SERVER];
                                        model.url = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
                                        block (model,nil,0);

                                        [[SJLocailFileScreen new] cleanSaveAction];

                                    };
                                    uy.failBlocker = ^(NSError * error) {
                                        block(nil,error,0);
                                    };
                                    uy.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {

                                        block(nil,nil,percent);
                                    };
                                    uy.uploadMethod = UPFormUpload;
                                    [uy uploadFile:videoPath saveKey:[[SJLocailFileScreen new]getSaveKeyWith:@"vedio" ]];
                                });
                            }
                        } failureBlock:^(NSError *error){

                        }];
                    }
                });
            }
        }
    }

}
//上传资源到又拍云  0 图片 ----- 1 来自系统相册视频   -----2 来自程序沙盒

-(void)upLocalFile:(id)params
              type:(int)fileType
             Block:(void(^)(id result,NSError *error,CGFloat percent))HandlerCallBack{


    self.upYunClass.successBlocker = ^(NSURLResponse *response, id responseData) {

        SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
        model.url = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
        if (fileType==0) {
            model.thumUrl = [NSString stringWithFormat:@"%@!/both/123x80",model.url];
        }
        HandlerCallBack(model,nil,1.00);

    };
    self.upYunClass.failBlocker = ^(NSError * error) {

        HandlerCallBack(nil,error,0);
    };
    self.upYunClass.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {

        HandlerCallBack(nil,nil,percent);
    };


    switch (fileType) {
        case 0:
            [self.upYunClass uploadFile:params saveKey:[self getSaveKeyWith:@"jpg"]];
            break;
        case 1:{

            NSURL *PATHURL= [params valueForProperty:ALAssetPropertyAssetURL];
            if ([params defaultRepresentation].size>(1024*1024*10)) {
                NSString *domain = @"com.MyCompany.MyApplication.ErrorDomain";
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:@"当前文件大于10M" };
                NSError *error = [NSError errorWithDomain:domain
                                                     code:-101
                                                 userInfo:userInfo];
                HandlerCallBack(nil,error,0);


            }else{

                NSFileManager * fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:KVideoUrlPath]) {
                    [fileManager createDirectoryAtPath:KVideoUrlPath
                           withIntermediateDirectories:YES
                                            attributes:nil
                                                 error:nil];
                }
                ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if (PATHURL) {
                        [assetLibrary assetForURL:PATHURL resultBlock:^(ALAsset *asset) {
                            ALAssetRepresentation *rep = [asset defaultRepresentation];
                            NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:@"IOS"];
                            const char *cvideoPath = [videoPath UTF8String];
                            FILE *file = fopen(cvideoPath, "a+");
                            if (file) {
                                const int bufferSize = 1*1024*1024;
                                // 初始化一个1M的buffer
                                Byte *buffer = (Byte*)malloc(bufferSize);
                                NSUInteger read = 0, offset = 0;
                                NSError* err = nil;
                                if (rep.size != 0)
                                {
                                    do {
                                        read = [rep getBytes:buffer
                                                  fromOffset:offset
                                                      length:bufferSize
                                                       error:&err];
                                        //!!!:
                                        fwrite(buffer, sizeof(char), read, file);
                                        offset += read;
                                    } while (read != 0 && !err);//没到结尾，没出错，ok继续
                                }
                                // 释放缓冲区，关闭文件
                                free(buffer);
                                buffer = NULL;
                                fclose(file);
                                file = NULL;

                                dispatch_async(dispatch_get_main_queue(), ^{

                                    NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:@"IOS"];
                                    
                                    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = UPaiYunKey1;
                                    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = UPaiYunKey2;
                                    [UPYUNConfig sharedInstance].FormAPIDomain = BIMS_CLOUD_ALBUMS_UPLOAD_URL;
                                    
                                    UpYun *uy = [[UpYun alloc] init];
                                    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
                                        SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
                                        model.url = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
                                        HandlerCallBack (model,nil,0);

                                        [[SJLocailFileScreen new] cleanSaveAction];

                                    };
                                    uy.failBlocker = ^(NSError * error) {
                                        HandlerCallBack(nil,error,0);
                                    };
                                    uy.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {

                                        HandlerCallBack(nil,nil,percent);
                                    };
                                    uy.uploadMethod = UPFormUpload;
                                    [uy uploadFile:videoPath saveKey:[[SJLocailFileScreen new]getSaveKeyWith:@"mp4" ]];
                                });
                            }
                        } failureBlock:^(NSError *error){

                        }];
                    }
                });
            }
        }

            break;


        case 2:{
            [self.upYunClass uploadFile:params saveKey:[[SJLocailFileScreen new]getSaveKeyWith:@"mp4" ]];
        }


            break;
        default:
            break;
    }


}


#pragma mark - 按照又拍云生成的key
- (NSString * )getSaveKeyWith:(NSString *)suffix {

    return [NSString stringWithFormat:@"/%@.%@", [self getDateString], suffix];

}

- (NSString *)getDateString {
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}

#pragma  mark - 清除沙盒中的视频文件
-(void)cleanSaveAction{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:KVideoUrlPath error:&error];
}

//需要优化
-(void)UpLocalVideoALAsset:(ALAsset *)params
                     Block:(void(^)(id result,NSError *error,CGFloat percent))block {

    NSURL *PATHURL= [params valueForProperty:ALAssetPropertyAssetURL];
    if ([params defaultRepresentation].size>(1024*1024*10)) {
        NSString *domain = @"com.MyCompany.MyApplication.ErrorDomain";
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:@"当前文件大于10M" };
        NSError *error = [NSError errorWithDomain:domain
                                             code:-101
                                         userInfo:userInfo];
        block(nil,error,0);


    }else{

        NSFileManager * fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:KVideoUrlPath]) {
            [fileManager createDirectoryAtPath:KVideoUrlPath
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (PATHURL) {
                [assetLibrary assetForURL:PATHURL resultBlock:^(ALAsset *asset) {
                    ALAssetRepresentation *rep = [asset defaultRepresentation];
                    NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:@"IOS"];
                    const char *cvideoPath = [videoPath UTF8String];
                    FILE *file = fopen(cvideoPath, "a+");
                    if (file) {
                        const int bufferSize = 1*1024*1024;
                        // 初始化一个1M的buffer
                        Byte *buffer = (Byte*)malloc(bufferSize);
                        NSUInteger read = 0, offset = 0;
                        NSError* err = nil;
                        if (rep.size != 0)
                        {
                            do {
                                read = [rep getBytes:buffer
                                          fromOffset:offset
                                              length:bufferSize
                                               error:&err];
                                //!!!:
                                fwrite(buffer, sizeof(char), read, file);
                                offset += read;
                            } while (read != 0 && !err);//没到结尾，没出错，ok继续
                        }
                        // 释放缓冲区，关闭文件
                        free(buffer);
                        buffer = NULL;
                        fclose(file);
                        file = NULL;

                        dispatch_async(dispatch_get_main_queue(), ^{

                            NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:@"IOS"];
                            [UPYUNConfig sharedInstance].DEFAULT_BUCKET = UPaiYunKey1;
                            [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = UPaiYunKey2;
                            [UPYUNConfig sharedInstance].FormAPIDomain = BIMS_CLOUD_ALBUMS_UPLOAD_URL;
                            UpYun *uy = [[UpYun alloc] init];
                            uy.successBlocker = ^(NSURLResponse *response, id responseData) {
                                SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
                                model.url = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
                                block (model,nil,0);

                                [[SJLocailFileScreen new] cleanSaveAction];

                            };
                            uy.failBlocker = ^(NSError * error) {
                                block(nil,error,0);
                            };
                            uy.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {

                                block(nil,nil,percent);
                            };
                            uy.uploadMethod = UPFormUpload;
                            [uy uploadFile:videoPath saveKey:[[SJLocailFileScreen new]getSaveKeyWith:@"mp4" ]];
                        });
                    }
                } failureBlock:^(NSError *error){

                }];
            }
        });
    }


}

//============6.4===========================================================//

//1.上传相册图片
//2.上传相册视频 小于10M
//3.上传参数为NSData

- (instancetype)init
{
    self = [super init];
    if (self) {
        [UPYUNConfig sharedInstance].DEFAULT_BUCKET   = UPaiYunKey1;
        [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = UPaiYunKey2;
        [UPYUNConfig sharedInstance].FormAPIDomain = BIMS_CLOUD_ALBUMS_UPLOAD_URL;
        self.upYunClass = [[UpYun alloc] init];
    }
    return self;
}

-(void)SJFileUpLoadToUCloud_VideoSourceType:(ALAsset *)videoasset
                                  WithBlock:(void(^)(id result,NSError *error,CGFloat percent))block{
    self.upYunClass.successBlocker = ^(NSURLResponse *response, id responseData) {

        SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
        model.url = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
        model.thumUrl = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
        block(model,nil,1.00);
    };
    self.upYunClass.failBlocker = ^(NSError * error) {
        block(nil,error,0);
    };
    self.upYunClass.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {

        block(nil,nil,percent);
    };
    //!!!:因为规定了大于10M的视频不得上传故选择 此方式将video 转成NSData
    //!!!:若视频较大可采用下面方式
    ALAssetRepresentation *rep = [videoasset defaultRepresentation];
    Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
    [self.upYunClass uploadFile:data saveKey:[[SJLocailFileScreen new]getSaveKeyWith:@"mp4" ]];

}

-(void)SJFileUpLoadToUCloud_PhotoSourceType:(ALAsset *)photoasset
                                  WithBlock:(void(^)(id result,NSError *error,CGFloat percent))block{
    CGImageRef imageRef = photoasset.defaultRepresentation.fullScreenImage;
    UIImage *image = [UIImage imageWithCGImage:imageRef
                                         scale:photoasset.defaultRepresentation.scale
                                   orientation:(UIImageOrientation)photoasset.defaultRepresentation.orientation];
    self.upYunClass.successBlocker = ^(NSURLResponse *response, id responseData) {

        SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
        model.url = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
        model.thumUrl = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
        block(model,nil,1.00);
    };
    self.upYunClass.failBlocker = ^(NSError * error) {
        block(nil,error,0);
    };
    self.upYunClass.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {

        block(nil,nil,percent);

    };
    [self.upYunClass uploadFile:[image imageRotate:image rotation:UIImageOrientationUp] saveKey:[self getSaveKeyWith:@"jpg"]];
}
/**
 *  传入参数 为 NSData
 *
 *  @param data
 */
-(void)SJFileUpSandboxToUCloud_PhotoSourceType:(NSData *)data
                                     WithBlock:(void(^)(id result,NSError *error,CGFloat percent))block{
    self.upYunClass.successBlocker = ^(NSURLResponse *response, id responseData) {

        SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
        model.url = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
        model.thumUrl = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
        block(model,nil,1.00);

    };
    self.upYunClass.failBlocker = ^(NSError * error) {
        block(nil,error,0);
    };
    self.upYunClass.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {

        block(nil,nil,percent);
    };
    [self.upYunClass uploadFile:data saveKey:[[SJLocailFileScreen new]getSaveKeyWith:@"mp4" ]];
}


/**
 * 视频较大时候采用该方式转成NSData
 */
+ (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset
{
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!handle) {
        return NO;
    }
    static const NSUInteger BufferSize = 1024*1024;
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    
    do {
        @try {
            bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:nil];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        } @catch (NSException *exception) {
            free(buffer);
            
            return NO;
        }
    } while (bytesRead > 0);
    
    free(buffer);
    return YES;
}



@end
