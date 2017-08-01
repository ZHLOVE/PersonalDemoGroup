//
//  HiTVConstants.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "HiTVConstants.h"

@implementation HiTVConstants

+ (NSString*)HiTVConstantsShowMainViewController{
    return @"HiTVConstantsShowMainViewController";
}

+ (NSString*)HiTVConstantsShowViewControllerNotificationName{
    return @"HiTVConstantsShowViewControllerNotificationName";
}

+ (NSString*)HiTVConstantsPresentViewControllerNotificationName{
    return @"HiTVConstantsPresentViewControllerNotificationName";
}


+ (NSString*)HiTVConstantsShowViewControllerNotificationController{
    return @"HiTVConstantsShowViewControllerNotificationController";
}

+ (NSString*)HiTVConstantsShowViewControllerNotificationControllerAnimated{
    return @"HiTVConstantsShowViewControllerNotificationControllerAnimated";
}

+ (NSString*)HiTVConstantsShowSuspendingIconNotificationName{
    return @"HiTVConstantsShowSuspendingIconNotificationName";
}


+ (NSString*)HiTVConstantsAllowRecordVideoNotificationName{
    return @"HiTVConstantsAllowRecordVideoNotificationName";
}

+ (NSString*)HiTVConstantsAllowReceiveMsgNotificationName{
    return @"HiTVConstantsAllowReceiveMsgNotificationName";
}



+ (NSString*)HiTVConstantsPlayVideoNotificationName{
    return @"HiTVConstantsPlayVideoNotificationName";
}

+ (NSString*)HiTVConstantsPlayVideoNotificationSourceIndex{
    return @"HiTVConstantsPlayVideoNotificationSourceIndex";
}

+ (NSString*)HiTVConstantsPlayNotificationName{
    return @"HiTVConstantsPlayNotificationName";
}
+ (NSString*)HiTVConstantsPlayNotificationVideo{
    return @"HiTVConstantsPlayNotificationVideo";
}
+ (NSString*)HiTVConstantsPlayNotificationVideoList{
    return @"HiTVConstantsPlayNotificationVideoList";
}
+ (NSString*)HiTVConstantsPlayFromPushNotificationName{
    return @"HiTVConstantsPlayFromPushNotificationName";
}



+ (NSString*)weekDayName:(NSInteger)weekday{
    return @[@"周日", @"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"今天"][weekday - 1];
}


+ (NSString*)disconnectBoxText
{
    return @"请确认已连接电视";
}

+ (UIColor*)titleColorForDefaultText{
    return [UIColor colorWithRed:0xA5/255.0f
                           green:0xB3/255.0f
                            blue:0xDA/255.0f
                           alpha:1];
    
//        return [UIColor colorWithRed:255.0f/255.0f
//                               green:255.0f/255.0f
//                                blue:255.0f/255.0f
//                               alpha:1];

}

+ (UIColor*)titleColorForSelectedText{
//    return [UIColor colorWithRed:0
//                           green:172.0f/255.0f
//                            blue:35.0f/255.0f
//                           alpha:1];
    
    return [UIColor colorWithRed:0xF4/255.0f
                           green:0xFB/255.0f
                            blue:0xFF/255.0f
                           alpha:1];
}

+ (UIColor*)titleColorForSelectedTVText{
    return [UIColor colorWithRed:1.0f/255.0f
                           green:0x84/255.0f
                            blue:0xd2/255.0f
                           alpha:1];
}

+ (UIColor*)titleColor{
//    return [UIColor colorWithRed:56.0f/255.0f
//                           green:56.0f/255.0f
//                            blue:56.0f/255.0f
//                           alpha:1];
    return [UIColor colorWithRed:0xA5/255.0f
                           green:0xB3/255.0f
                            blue:0xDA/255.0f
                           alpha:1];

}

+ (NSString*)cacheFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    NSFileManager* filemanager = [[NSFileManager alloc] init];
    if (![filemanager fileExistsAtPath:applicationSupportDirectory]) {
        [filemanager createDirectoryAtPath:applicationSupportDirectory
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    }
    return applicationSupportDirectory;
}

//获取中文首字母
+(NSString *)CHTOEN:(NSString *)word{
    
    NSMutableString *source = [word mutableCopy];
    
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSString *city = [source stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return city;
}
//获取中文首字母
+ (NSString *)phonetic:(NSString *)cityName withLength:(int)length{
    
    NSMutableString *source = [cityName mutableCopy];
    
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSString *city = [source stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (length<=cityName.length) {
        city = [city substringToIndex:length];
    }
    city = [city uppercaseStringWithLocale:[NSLocale currentLocale]];
    
    return city;
}

+ (UIImage *)thumbnailFromVideoUrl:(NSString *)videoUrl
{
    if (videoUrl.length == 0) {
        return nil;
    }
    
    NSURL *sourceURL = [NSURL URLWithString:videoUrl];
//    AVAsset *asset = [AVAsset assetWithURL:sourceURL];
//    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
//    CMTime time = CMTimeMake(1, 1);
//    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
//    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    return thumbnail;
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:sourceURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 1;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        DDLogError(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

@end
