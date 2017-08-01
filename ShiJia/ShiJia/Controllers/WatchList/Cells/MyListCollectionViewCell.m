//
//  WatchListCollectionViewCell.m
//  HiTV
//
//  Created by lanbo zhang on 8/1/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "MyListCollectionViewCell.h"
#import "BaseAFHTTPManager.h"
#import "MBProgressHUD.h"
#import "HiTVGlobals.h"
#import "OMGToast.h"

@interface MyListCollectionViewCell ()
{
    CAGradientLayer *headerLayer;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *playingLabel;
//@property (weak, nonatomic) IBOutlet UIButton *recommandButton;
//@property (weak, nonatomic) IBOutlet UIButton *notRecommandButton;

@property (weak, nonatomic) IBOutlet UILabel *programeName;

@property (weak, nonatomic) IBOutlet UIView *bellowBg;
@property (weak, nonatomic) IBOutlet UIImageView *channelLogo;
@property (weak, nonatomic) IBOutlet UILabel *channelName;
@property (weak, nonatomic) IBOutlet UILabel *descLab;

@property (weak, nonatomic) IBOutlet UIView *bellowView;

@end
@implementation MyListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = NO;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
    
    self.playingLabel.hidden = YES;
    self.bellowView.backgroundColor = RGB(0, 0, 0, 0);
    [self insertTransparentGradient];

    self.nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.programeName.font = [UIFont boldSystemFontOfSize:16.0f];
    self.liveLab.backgroundColor = RGB(239, 100, 74, 1);
    self.reasonLabel.textColor = kColorBlueTheme;

    self.smallThumbnailImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.thumbnailImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.thumbnailImageView.contentMode =  UIViewContentModeScaleAspectFill;
    self.thumbnailImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.thumbnailImageView.clipsToBounds  = YES;
    
   // self.thumbnailImageView.contentMode = UIViewContentModeScaleToFill;
    self.channelLogo.contentMode = UIViewContentModeScaleToFill;

    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longPressGr];
}
- (void)viewWillLayoutSubviews{
    //[self setFrame:CGRectMake(0, self.frame.origin.y, W, self.frame.size.height)];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    headerLayer.frame = self.bellowView.bounds;
    
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        self.deleteBtn.hidden = NO;
        self.deleteBgBtn.hidden = NO;
    }
}
#pragma mark - 看单删除
-(IBAction)deleteMyListRequest{
    NSString* url = [NSString stringWithFormat:@"%@/personal/deleteProgramSeries",
                     MYEPG];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[HiTVGlobals sharedInstance].uid forKey:@"userId"];
    [param setObject:self.entity.programSeriesId forKey:@"programSeriesId"];
    [param setObject:self.entity.contentType forKey:@"contentType"];
    [param setObject:@"personal" forKey:@"recommendType"];

    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:param completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            //[OMGToast showWithText:@"操作成功"];
            [self.delegate refrashMyList];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        [OMGToast showWithText:error];

    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.playingLabel.hidden = YES;
}

- (void)setEntity:(WatchListEntity *)entity {
    [super setEntity:entity];
    if ([entity.contentType isEqualToString:@"watchtv"]||[entity.contentType isEqualToString:@"live"]) {
        if (entity.posterAddr.length !=0 ) {
            [self.smallThumbnailImageView setImageWithURL:[NSURL URLWithString:entity.posterAddr]];
            self.smallThumbnailImageView.hidden = NO;
            self.thumbnailImageView.hidden = YES;
        }
        else{
            self.smallThumbnailImageView.hidden = YES;
            self.thumbnailImageView.hidden = YES;
        }
        [self.channelLogo setImageWithURL:[NSURL URLWithString:entity.channelLogo]];
        self.channelName.text = entity.channelName;
        self.descLab.text = entity.programSeriesDesc;
        self.reasonLabel.text = entity.reason;

        self.bellowBg.hidden = NO;
        if (/*[entity.contentType isEqualToString:@"live"]&&*/[self live:entity]) {
            self.liveLab.hidden = NO;
            if ([OPENFLAG isEqualToString:@"0"]) {
                self.liveLab.text = @"最新";
            }
            else{
                self.liveLab.text = @"直播中";
            }
        }
        else{
            self.liveLab.hidden = YES;
        }
        self.hourLab.textColor = [UIColor lightGrayColor];
        self.hourLab.frame = CGRectMake(10, 220, 140, 15);
        [self setHourText:entity];
        
        self.bellowView.hidden = YES;
    }
    else{
        if (entity.verticalPosterAddr.length !=0 ) {
            [self.thumbnailImageView setImageWithURL:[NSURL URLWithString:entity.verticalPosterAddr] placeholderImage:[UIImage imageNamed:@"watchlist-thumbnail"]];
            self.smallThumbnailImageView.hidden = YES;
            self.thumbnailImageView.hidden = NO;
        }
        else{
            self.smallThumbnailImageView.hidden = YES;
            self.thumbnailImageView.hidden = YES;
        }

        self.bellowBg.hidden = YES;
        self.thumbnailImageView.layer.cornerRadius = 3;
        
        self.programeName.text = entity.programSeriesName;

        self.liveLab.hidden = YES;
        self.hourLab.textColor = kColorBlueTheme;
        
        self.hourLab.frame = CGRectMake(10, 215, 140, 15);
        self.hourLab.text = entity.reason;
        self.hourLab.hidden = NO;

        self.bellowView.hidden = NO;

       // UIView *bellowView = [[UIView alloc]initWithFrame:CGRectMake(0, self.thumbnailImageView.frame.size.height-50, self.frame.size.width, 50)];
        
        //[self.thumbnailImageView insertSubview:bellowView atIndex:0];
        //self.hourLab.text = [NSString stringWithFormat:@"上次看到%@",entity.hour];
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
-(void)setHourText:(WatchListEntity *)entity{
    if (entity.setNumber.length!=0) {
        NSString *stamp = [Utils nowTimeString];
        long long date = [stamp longLongValue]*1000;
        if (date < entity.startTime) {
            self.hourLab.text = [NSString stringWithFormat:@"今天播出第%@%@",entity.setNumber,entity.setNumberWord];
        }
        else if (date > entity.endTime){
            self.hourLab.text = [NSString stringWithFormat:@"已播出第%@%@",entity.setNumber,entity.setNumberWord];
        }
        else{
            self.hourLab.text = [NSString stringWithFormat:@"正在播出第%@%@",entity.setNumber,entity.setNumberWord];
        }
        self.hourLab.hidden = NO;

    }
    else{
        self.hourLab.hidden = YES;
    }


}
- (void)updateServerTime:(NSTimeInterval)serverTime {
    if (serverTime == 0 || self.entity.startTime == 0 || self.entity.endTime == 0) {
        self.playingLabel.hidden = YES;
        return;
    }
    self.playingLabel.hidden = !(self.entity.startTime <= serverTime && serverTime <= self.entity.endTime);
}
- (IBAction)recommandButtonTapped:(id)sender {
    [self p_updateScore:@"1"];
}
- (IBAction)unrecommandButtonTapped:(id)sender {
    [self p_updateScore:@"0"];
}

- (void)p_updateScore:(NSString*)score {
    //http://sns.is.ysten.com/box_api/singleAddScore?singleId=102&uid=123123&score=1&programId=12312&type=vod&oprUids=123,1231
    
    long l2 = self.entity.endTime - self.entity.startTime;
    if (l2 < 0) {
        l2 = 0;
    }
    
    NSDictionary* parameters = @{
                                 @"uid" : self.currentUserID,
                                 @"oprUids" : self.currentUserID,
                                 @"score" : score,
                                 @"programId" : self.entity.programSeriesId,
                                 @"objecttype" : @"vod",
                                 @"type" : self.playingLabel.hidden ? @"watchtv-replay" : @"watchtv-play",
                                 @"startTime" : @(self.entity.startTime),
                                 @"duration" : @(l2/1000)
                                 };
    
    __weak UIWindow* window = self.window;
    MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/singleAddScore", WXSEEN];
    [BaseAFHTTPManager getRequestOperationForHost:requestUrl forParam:@"" forParameters:parameters completion:^(id responseObject) {
        DDLogInfo(@"%@", responseObject);
        [HUD hide:YES];
        
        MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
        HUD.mode = MBProgressHUDModeText;
        HUD.userInteractionEnabled = NO;
        HUD.labelText = responseObject[@"message"];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        
        // Set custom view mode
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:1.0f];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        [HUD hide:YES];
        
    }];
    
}
- (void) insertTransparentGradient {
    UIColor *colorOne = RGB(0, 0, 0, 0);;
    UIColor *colorTwo = RGB(0, 0, 0, 1);;
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.bellowView.bounds;
    
    //[self.layer insertSublayer:headerLayer atIndex:0];
    
    [self.bellowView.layer addSublayer:headerLayer];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}
@end
