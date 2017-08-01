//
//  SJAlbumToolViewModel.m
//  ShiJia
//
//  Created by 峰 on 16/9/5.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJAlbumToolViewModel.h"
#import "ScreenManager.h"
#import "SJLocailFileScreen.h"
#import "SJLocailFileResponseModel.h"
#import "TPIMContentModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TPDownloadVideoManager.h"
#import "SJVedioNetWork.h"
#import "HiTVWebServer.h"



@interface SJAlbumToolViewModel ()
@property (nonatomic, strong) ScreenManager   *screenManager;
@property (nonatomic, strong) SDWebImageManager *manager;
@property (nonatomic, strong) TPDownloadVideoManager *tpDownVideomanager;
@property (nonatomic, strong) SJLocailFileScreen *upFileManager;
@end

@implementation SJAlbumToolViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _downSubject = [[RACSubject alloc]init];
        _manager = [SDWebImageManager sharedManager];
        _tpDownVideomanager = [[TPDownloadVideoManager alloc]init];
        _screenManager =[ScreenManager sharedInstance];
        _upFileManager = [SJLocailFileScreen new];
    }
    return self;
}


-(RACSignal *)localSourceScreenToTV:(NSString *)asset andSourceType:(Media_TYPE )type{
    __weak __typeof(self)weakSelf = self;
	   return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

           __strong __typeof(weakSelf)strongSelf = weakSelf;

           [[strongSelf screenManager] reset];
           TPIMContentModel *xmppModel =[TPIMContentModel new];
           xmppModel.playerType = type==0?@"photo": @"video";
           xmppModel.action = @"play";//rotateL rotateR
           xmppModel.url = [NSString stringWithFormat:@"%@",asset];


           self.screenManager.remoteLoacalFileBlock = ^(BOOL isSuccess){
               if (isSuccess) {
                   [subscriber sendCompleted];
               }else{
                   NSString *domain = @"Domain";
                   NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:@"投屏失败" };
                   NSError *error = [NSError errorWithDomain:domain
                                                        code:-100
                                                    userInfo:userInfo];
                   [subscriber sendError:error];
               }
           };
           // 投屏回执
           [strongSelf screenManager].screenManagerBlock = ^(BOOL isSuccess,NSString *time){
               if (isSuccess) {
                   [subscriber sendCompleted];
               }else{
                   [subscriber sendError:SJERROR(@"失败")];
               }

           };
           [strongSelf.screenManager remoteLoacalFileWith:xmppModel andType:type==0?2:1];

           return [RACDisposable disposableWithBlock:^{
               //销毁信号-----
           }];
       }];
}





-(RACSignal *)cloudSourceScreenToTV:(CloudPhotoModel *)model andSourceType:(Media_TYPE )type{

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[self screenManager] reset];
        //        WEAKSELF

        TPIMContentModel *xmppModel =[TPIMContentModel new];
        xmppModel.playerType = type==0?@"photo": @"video";
        xmppModel.action = @"play";
        xmppModel.url = [NSString stringWithFormat:@"%@",model.resourceUrl];

        [self.screenManager remoteLoacalFileWith:xmppModel andType:type==0?2:1];
        [self screenManager].remoteLoacalFileBlock = ^(BOOL isSuccess){
            if (isSuccess) {
                [subscriber sendCompleted];
            }else{
                NSString *domain = @"Domain";
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:@"投屏失败" };
                NSError *error = [NSError errorWithDomain:domain
                                                     code:-100
                                                 userInfo:userInfo];
                [subscriber sendError:error];
            }
        };

        [self screenManager].screenManagerBlock = ^(BOOL isSuccess,NSString *time){
            if (isSuccess) {
                //                   [subscriber sendCompleted];
            }else{

            }

        };
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];

}

// 从URL 获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {

    UIImage * result;

    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];

    result = [UIImage imageWithData:data];

    return result;

}

- (void)saveImageToPhotos:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        [_downSubject sendError:SJERROR(msg)];
    }else{
        [_downSubject sendNext:msg];

    }
}

-(void)downLoadCloudSource:(CloudPhotoModel *)model andSourceType:(Media_TYPE )type{

    if (type==Media_Photo) {


        [_manager downloadImageWithURL:[NSURL URLWithString:model.resourceUrl]
                               options:0
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  if (self.downprecent) {

                                      NSInteger a = receivedSize/expectedSize;
                                      _downprecent(a);
                                  }
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                 if (finished) {
                                     [self saveImageToPhotos:image];
                                 }
                             }];
    }else{

        [self downLoadVideo:[NSURL URLWithString:model.resourceUrl]];
    }


}


-(void)downLoadVideo:(NSURL *)sourceUrl{

    _tpDownVideomanager = [[TPDownloadVideoManager alloc] init];
    [_tpDownVideomanager downloadMp4FileWithURL:sourceUrl success:^(NSURL *videoPath) {

        if (videoPath != nil) {


            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

            [library writeVideoAtPathToSavedPhotosAlbum:videoPath
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            [_downSubject sendNext:@"保存成功"];
                                        }];
        }
        else{
            [_downSubject sendError:SJERROR(@"保存失败")];
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [_downSubject sendError:SJERROR(@"保存失败")];
    }];


}

-(RACSignal *)changeThePhotoOrotate:(NSString *)string andPhotoModel:(NSString *)model{


    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[self screenManager] reset];

        TPIMContentModel *xmppModel =[TPIMContentModel new];
        xmppModel.playerType = @"photo";
        xmppModel.action = string;
        xmppModel.url = model;

        [self.screenManager remoteLoacalFileWith:xmppModel andType:2];
        [self screenManager].remoteLoacalFileBlock = ^(BOOL isSuccess){
            if (isSuccess) {
                [subscriber sendCompleted];
            }else{
                NSString *domain = @"Domain";
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:@"旋转失败" };
                NSError *error = [NSError errorWithDomain:domain
                                                     code:-100
                                                 userInfo:userInfo];
                [subscriber sendError:error];
            }
        };

        [self screenManager].screenManagerBlock = ^(BOOL isSuccess,NSString *time){
            if (isSuccess) {
                //                   [subscriber sendCompleted];
            }else{

            }

        };
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
}


#pragma mark 本地资源
//获取对应的URL（视频为缩略图的URL）
-(RACSignal *)UpLoadLocalSourceModel:(ALAsset *)model andMediaType:(Media_TYPE )mediaType {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        UIImage *image=[UIImage new];
        if (mediaType==0) {

            CGImageRef imageRef = model.defaultRepresentation.fullScreenImage;
            image = [UIImage imageWithCGImage:imageRef
                                        scale:model.defaultRepresentation.scale
                                  orientation:(UIImageOrientation)model.defaultRepresentation.orientation];
        }else{
            image = [UIImage imageWithCGImage:[model thumbnail]];

        }
        [_upFileManager upLocalFile:image type:0 Block:^(id result, NSError *error, CGFloat percent) {
            if (result) {
                if (mediaType==0) {


                    [subscriber sendNext:result];
                }else{
                    SJLocailFileResponseModel *resultModel =(SJLocailFileResponseModel *)result;

                    [_upFileManager UpLocalVideoALAsset:model Block:^(id result, NSError *error, CGFloat percent) {

                        if (result) {
                            SJLocailFileResponseModel *result2 =(SJLocailFileResponseModel *)result;
                            result2.thumUrl = resultModel.url;
                            [subscriber sendNext:result2];
                        }
                        if (error) {
                            [subscriber sendError:error];
                        }

                    }];

                }


            }
            if (error) {
                [subscriber sendError:error];
            }
        }];

        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];

    }];
}


-(void)upLoadLocalVideoToUCloud:(ALAsset *)alasset{


}


-(RACSignal *)shortVideoToH5:(SJ30SVedioRequestModel *)Params {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [SJVedioNetWork SJ_VedioCutManange:Params Block:^(id result, NSString *error) {

            if (error) {
                [subscriber sendError:SJERROR(@"分享失败")];
            }else{
                if ([result[@"code"] isEqualToString:@"0"]) {



                    SJ30SVedioModel *model = [SJ30SVedioModel mj_objectWithKeyValues:result[@"data"]];
                    model.modeltype = Params.videoType;
                    if ([Params.videoType isEqualToString:@"photo"]) {
                        model.title = ImageShareTitle;
                        model.content = [NSString stringWithFormat:@"%@给你分享的一张图片，打开看看吧。", [HiTVGlobals sharedInstance].nickName];
                    }else{
                        model.title = VideoShareTitle;
                        model.content = [NSString stringWithFormat:@"%@给你分享的一段视频，打开看看吧。", [HiTVGlobals sharedInstance].nickName];
                    }

                    [subscriber sendNext:model];
                }else{
                    //                    [subscriber sendError:SJERROR(result[@"message"])];
                    [subscriber sendError:SJERROR(@"分享失败")];
                }
            }
        }];


        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
}
-(RACSignal *)SMSShareLoaclSourceGenerationH5WebURL:(SMSLocalRequestParams *)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [SJVedioNetWork ShareSMSLocalSource:params
                                      Block:^(SMSResponseModel *model, NSString *error) {
                                          if (error) {
                                                  [subscriber sendError:SJERROR(@"分享失败")];
                                          }else{
                                              if ([model.resultCode isEqualToString:@"000"]) {
                                                  [subscriber sendNext:model];
                                              }else{
                                                  [subscriber sendError:SJERROR(model.resultMessage)];
                                              }
                                          }
                                      }];

        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];

}

//-(void)test{
//
//   [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        DDLogInfo(@"第一步");
//        [subscriber sendNext:@"adadada"];
//        [subscriber sendCompleted];
//        return nil;
//    }] then:^RACSignal *{
//        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            DDLogInfo(@"第二步");
//            [subscriber sendCompleted];
//            return nil;
//        }];
//    }] then:^RACSignal *{
//        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            DDLogInfo(@"第三步");
//            return nil;
//        }];
//    }] subscribeCompleted:^{
//        DDLogInfo(@"完成");
//    }];
//
//}

//-(RACSignal *)localAssetScreenToTV:(ALAsset *)alasset togetherWithTV:(BOOL)isTogether {
//
//    if (isTogether) {
//
//        [[HiTVWebServer sharedInstance]start];
//        NSString *tempUrlString =[[alasset valueForProperty:ALAssetPropertyAssetURL] description];
//        [[HiTVWebServer sharedInstance] webURLForLocalUrl:tempUrlString];
//
//        [HiTVWebServer sharedInstance].block = ^(NSString* urlString) {
//            NSMutableDictionary *dict = [NSMutableDictionary new];
//            [dict setValue:@(200) forKey:@"code"];
//            [dict setValue:@"shijia" forKey:@"sign"];
//            [dict setValue:@"成功" forKey:@"message"];
//            [dict setValue:urlString forKey:@"url"];
//            SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:dict];
////            block(model,nil,100);
//        };
//    }else{
//
//
//
//    }
//}
@end
