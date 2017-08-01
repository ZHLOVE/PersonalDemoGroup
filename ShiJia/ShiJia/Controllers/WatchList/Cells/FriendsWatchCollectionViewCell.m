//
//  FriendsWatchCollectionViewCell.m
//  ShiJia
//
//  Created by 蒋海量 on 16/7/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "FriendsWatchCollectionViewCell.h"
@interface FriendsWatchCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *prossBg;
@property (strong, nonatomic) IBOutlet UIImageView *prossImg;


@end

@implementation FriendsWatchCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImg.layer.cornerRadius = self.headImg.frame.size.height/2;
    self.headImg.layer.borderColor = UIColorHex(d8d8d8).CGColor;
    self.headImg.layer.masksToBounds = YES;
    
    self.liveLab.backgroundColor = RGB(239, 100, 74, 1);
    
    self.prossBg.backgroundColor = kTabLineColor;
    self.prossBg.layer.masksToBounds = YES;
    self.prossBg.layer.cornerRadius = 1.0;
    self.prossBg.hidden = YES;
    self.prossImg.hidden = YES;
}
- (void)setEntity:(WatchListEntity *)entity {
    [super setEntity:entity];
    
    if (/*[entity.contentType isEqualToString:@"live"]&&*/[self live:entity]) {
        self.liveLab.hidden = NO;
        if ([OPENFLAG isEqualToString:@"0"]) {
            self.liveLab.text = @"最新";
        }
        else{
            self.liveLab.text = @"直播中";
        }
       // entity.contentType = @"live";
        self.prossBg.hidden = NO;
        self.prossImg.hidden = NO;
        NSTimeInterval timeIntervalSince1970 = [[NSDate date] timeIntervalSince1970];
        int m= (int)timeIntervalSince1970-entity.startTime-[HiTVGlobals sharedInstance].delaySecond;
        int n = entity.endTime- entity.startTime;
        if (!_prossImg) {
            _prossImg = [[UIImageView alloc]init];
            _prossImg.backgroundColor = kColorBlueTheme;
            _prossImg.layer.masksToBounds = YES;
            _prossImg.layer.cornerRadius = 1.0;
            [self.prossBg addSubview:_prossImg];
        }
        self.prossImg.frame = CGRectMake(0, 0, self.prossBg.frame.size.width*m/n, self.prossBg.frame.size.height);
    }
    else{
        self.liveLab.hidden = YES;
        self.prossBg.hidden = YES;
        self.prossImg.hidden = YES;
    }

}

-(BOOL)live:(WatchListEntity *)entity{
    NSString *stamp = [Utils nowTimeString];
    long long date = [stamp longLongValue];
    if (date >=entity.startTime && date <= entity.endTime) {
        return YES;
    }
    return NO;
}
@end
