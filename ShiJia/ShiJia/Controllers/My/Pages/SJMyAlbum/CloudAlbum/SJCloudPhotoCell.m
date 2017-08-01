//
//  SJCloudPhotoCell.m
//  ShiJia
//
//  Created by 峰 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJCloudPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "SJAlbumNetWork.h"
@interface SJCloudPhotoCell()

@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;
@property (weak, nonatomic) IBOutlet UILabel     *ownerName;
@property (weak, nonatomic) IBOutlet UILabel     *sourceType;
@property (weak, nonatomic) IBOutlet UILabel     *time;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIButton    *vedioTime;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressHUd;

@end

@implementation SJCloudPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCellContentWithModel:(CloudPhotoModel *)Model {
    self.sourceType.text = [self sourceType:Model.source];
    self.progressHUd.hidden = NO;
    [self.progressHUd startAnimating];
    self.time.text = Model.createTime;
    [self.time setAdjustsFontSizeToFitWidth:YES];
    if ([Model.resourceType isEqualToString:@"VIDEO"]) {
        self.vedioTime.hidden = NO;
        [self.vedioTime setTitle:[NSString stringWithFormat:@"%@",[Utils secondsString:Model.resourceLength]]
                        forState:UIControlStateNormal];
        WEAKSELF
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:Model.thumbnailUrl]
                           placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                                      [weakSelf.progressHUd stopAnimating];
                                  }];
    }else{
        self.vedioTime.hidden = YES;
        NSString *newThumb = [NSString stringWithFormat:@"%@!/both/125x80",Model.resourceUrl];
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:newThumb]
                           placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
        WEAKSELF
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:newThumb]
                           placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      [weakSelf.progressHUd stopAnimating];
                                  }];


    }
    self.ownerName.text = Model.uploadNickName;
    [self.ownerImageView sd_setImageWithURL:[NSURL URLWithString:Model.faceImg]
                           placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.ownerImageView.layer.masksToBounds = YES;
}

#pragma mark 来源转换
-(NSString *)sourceType:(NSString *)string{

    if ([string isEqualToString:@"WECHAT"]) {
        return @"来自微信上传";
    }
    if ([string isEqualToString:@"TV"]) {
        return @"来自电视上传";
    }
    if([string isEqualToString:@"APP"]){
        return @"来自手机上传";
    }else
        return @"未知来源";
}

#pragma mark时间转换 刚刚 昨天....
//- (NSString *)timeInfoWithDateString:(NSString *)dateString{
//
//    NSDate *date = [NSDate dateWithString:dateString format:@"yyyy-MM-dd HH:mm:ss"];
//
//    NSDate *curDate = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//    NSInteger interval = [zone secondsFromGMTForDate: curDate];
//    NSDate *localeDate = [curDate  dateByAddingTimeInterval: interval];
//
//
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy"];
//    NSInteger dateYear=[[formatter stringFromDate:date] integerValue];
//    NSInteger currentYear =[[formatter stringFromDate:localeDate] integerValue];
//
//    [formatter setDateFormat:@"MM"];
//    NSInteger datetMonth=[[formatter stringFromDate:date]integerValue];
//     NSInteger currentMonth=[[formatter stringFromDate:localeDate]integerValue];
//    [formatter setDateFormat:@"dd"];
//    NSInteger dateDay=[[formatter stringFromDate:date] integerValue];
//     NSInteger currentDay=[[formatter stringFromDate:localeDate] integerValue];
//
//    NSTimeInterval time = -[date timeIntervalSinceDate:localeDate];
//
//        int month = (int)(currentMonth - datetMonth);
//        int year = (int)(currentYear - dateYear);
//        int day = (int)(currentDay - dateDay);
//        NSTimeInterval retTime = 1.0;
//        // 小于一小时
//        if (time < 3600) {
//            retTime = time / 60;
//            retTime = retTime <= 0.0 ? 1.0 : retTime;
//            return [NSString stringWithFormat:@"%.0f分钟前", retTime];
//        }
//        // 小于一天，也就是今天
//        else if (time < 60*60*24) {
//            retTime = time / 3600;
//            retTime = retTime <= 0.0 ? 1.0 : retTime;
//            return [NSString stringWithFormat:@"%.0f小时前", retTime];
//        }
//        // 昨天
//        else if (time < 60*60*24 * 2&time>60*60*24) {
//            return @"昨天";
//        }
//        // 第一个条件是同年，且相隔时间在一个月内
//        // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
//        else if ((abs(year) == 0 && abs(month) <= 1)
//                 || (abs(year) == 1 && currentMonth == 1 && datetMonth == 12)) {
//            int retDay = 0;
//            // 同年
//            if (year == 0) {
//                // 同月
//                if (month == 0) {
//                    retDay = day;
//                }
//            }
//
//            if (retDay <= 0) {
//                // 这里按月最大值来计算
//                // 获取发布日期中，该月总共有多少天
//                NSInteger totalDays = [self getNumberOfDaysInMonth:date] ;
//                // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
//                retDay = (int)localeDate + ((int)totalDays  - (int)dateDay);
//
//                if (retDay >= totalDays) {
//                    return [NSString stringWithFormat:@"%d个月前", (abs)(MAX(retDay / 31, 1))];
//                }
//            }
//
//            return [NSString stringWithFormat:@"%d天前", (abs)(retDay)];
//        } else  {
//            if (abs(year) <= 1) {
//                if (year == 0) { // 同年
//                    return [NSString stringWithFormat:@"%d个月前", abs(month)];
//                }
//
//                // 相差一年
//                int month = (int)currentMonth;
//                int preMonth = (int)datetMonth;
//
//                // 隔年，但同月，就作为满一年来计算
//                if (month == 12 && preMonth == 12) {
//                    return @"1年前";
//                }
//
//                // 也不看，但非同月
//                return [NSString stringWithFormat:@"%d个月前", (abs)(12 - preMonth + month)];
//            }
//
//            return [NSString stringWithFormat:@"%d年前", abs(year)];
//        }
//
//        return @"1小时前";
//}

//- (NSInteger)getNumberOfDaysInMonth:(NSDate *)date
//{
//    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
//    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
//                                   inUnit: NSCalendarUnitMonth
//                                  forDate:date];
//    return range.length;
//}

@end
