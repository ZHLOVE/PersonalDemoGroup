//
//  HiTVConstants.h
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

#define WIDESCREEN ( fabs( ( double )[ [UIScreen mainScreen ]bounds ].size.height-( double )568 ) < DBL_EPSILON )

/**
 *  常量管理
 */
@interface HiTVConstants : NSObject

+ (NSString*)HiTVConstantsShowMainViewController;

+ (NSString*)HiTVConstantsShowViewControllerNotificationName;
+ (NSString*)HiTVConstantsPresentViewControllerNotificationName;
+ (NSString*)HiTVConstantsShowViewControllerNotificationController;
+ (NSString*)HiTVConstantsShowViewControllerNotificationControllerAnimated;

+ (NSString*)HiTVConstantsShowSuspendingIconNotificationName;

+ (NSString*)HiTVConstantsPlayVideoNotificationName;
+ (NSString*)HiTVConstantsPlayVideoNotificationSourceIndex;
+ (NSString*)HiTVConstantsAllowRecordVideoNotificationName;

+ (NSString*)HiTVConstantsAllowReceiveMsgNotificationName;


+ (NSString*)HiTVConstantsPlayNotificationName;
+ (NSString*)HiTVConstantsPlayNotificationVideo;
+ (NSString*)HiTVConstantsPlayNotificationVideoList;

+ (NSString*)weekDayName:(NSInteger)weekday;

+ (UIColor*)titleColorForDefaultText;
+ (UIColor*)titleColorForSelectedText;
+ (UIColor*)titleColorForSelectedTVText;

+ (UIColor*)titleColor;

+ (NSString*)cacheFolder;

+ (NSString*)disconnectBoxText;

//add by jianghailaing
+ (NSString*)HiTVConstantsPlayFromPushNotificationName;
//获取中文首字母
+(NSString *)CHTOEN:(NSString *)word;

+ (NSString *)phonetic:(NSString *)cityName withLength:(int)length;

+ (UIImage *)thumbnailFromVideoUrl:(NSString *)videoUrl;

@end

#define EMPTY_TABLE_HEADER                                                                                      \
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section                        \
{                                                                                                               \
return nil;                                                                                          \
}                                                                                                               \
\
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {                     \
return 0;                                                                                                   \
}





