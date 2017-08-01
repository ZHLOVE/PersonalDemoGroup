//
//  MyListTableViewCell.m
//  ShiJia
//
//  Created by 峰 on 2017/5/9.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "MyListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MyListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *liveTVView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *point;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel     *reason;
@property (weak, nonatomic) IBOutlet UILabel     *title;
@property (weak, nonatomic) IBOutlet UILabel     *desLabel;
@property (weak, nonatomic) IBOutlet UIButton    *deleteButton;

@property (weak, nonatomic) IBOutlet UIImageView *channelLogoImgView;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *programNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation MyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteButton.hidden = YES;
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    
    longPressGR.minimumPressDuration = 1;
    
    [self addGestureRecognizer:longPressGR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellEntity:(WatchListEntity *)cellEntity{
    
    _cellEntity = cellEntity;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[cellEntity.posterAddr description]] placeholderImage:[UIImage imageNamed:@"watchlist-thumbnail"]];
    

    if ([cellEntity.contentType isEqualToString:@"watchtv"]||[cellEntity.contentType isEqualToString:@"live"]) {
        self.videoView.hidden = YES;
        self.liveTVView.hidden = NO;
//        if (cellEntity.posterAddr.length !=0 ) {
//            [self.smallThumbnailImageView setImageWithURL:[NSURL URLWithString:entity.posterAddr]];
//            self.smallThumbnailImageView.hidden = NO;
//            self.thumbnailImageView.hidden = YES;
//        }
//        else{
//            self.smallThumbnailImageView.hidden = YES;
//            self.thumbnailImageView.hidden = YES;
//        }
        
        [self.channelLogoImgView sd_setImageWithURL:[NSURL URLWithString:[cellEntity.channelLogo description]] placeholderImage:[UIImage imageNamed:@"watchlist-thumbnail"]];
        self.channelNameLabel.text = cellEntity.channelName;
        self.programNameLabel.text = cellEntity.programSeriesName;
        self.desInfoLabel.text = cellEntity.programSeriesDesc;
        //self.reason.text = cellEntity.reason;
        self.reason.text = cellEntity.duration;

//        self.bellowBg.hidden = NO;
//        if (/*[entity.contentType isEqualToString:@"live"]&&*/[self live:entity]) {
//            self.liveLab.hidden = NO;
//            if ([OPENFLAG isEqualToString:@"0"]) {
//                self.liveLab.text = @"最新";
//            }
//            else{
//                self.liveLab.text = @"直播中";
//            }
//        }
//        else{
//            self.liveLab.hidden = YES;
//        }
        //self.statusLabel.textColor = [UIColor lightGrayColor];
        self.statusLabel.frame = CGRectMake(10, 220, 140, 15);
        [self setHourText:cellEntity];
        
        //self.bellowView.hidden = YES;
        if ([self live:cellEntity]) {
            self.isLivingRow = YES;
        }
        else{
            self.isLivingRow = NO;
        }
    }
    else{
        self.videoView.hidden = NO;
        self.liveTVView.hidden = YES;

        self.title.text = cellEntity.programSeriesName;
        self.desLabel.text = cellEntity.programSeriesDesc.length>0?cellEntity.programSeriesDesc:@"";
        self.reason.text = cellEntity.reason;
        self.isLivingRow = NO;

    }

}

-(void)setHourText:(WatchListEntity *)entity{
    if (entity.setNumber.length!=0) {
        NSString *stamp = [Utils nowTimeString];
        long long date = [stamp longLongValue]*1000;
        if (date < entity.startTime) {
            self.statusLabel.text = [NSString stringWithFormat:@"今天播出第%@%@",entity.setNumber,entity.setNumberWord];
        }
        else if (date > entity.endTime){
            self.statusLabel.text = [NSString stringWithFormat:@"已播出第%@%@",entity.setNumber,entity.setNumberWord];
        }
        else{
            self.statusLabel.text = [NSString stringWithFormat:@"正在播出第%@%@",entity.setNumber,entity.setNumberWord];
        }
        self.statusLabel.hidden = NO;
        
    }
    else{
        self.statusLabel.hidden = YES;
    }
    
    
}

-(void)setIsLivingRow:(BOOL)isLivingRow{

    UIImage *pointImage = isLivingRow?[UIImage imageNamed:@"firstPoint"]:[UIImage imageNamed:@"otherPoint"];
    self.point.image = pointImage;
    self.reason.textColor = isLivingRow?kColorBlueTheme:[UIColor colorWithHexString:@"999999"];
}

-(void)longPress:(UILongPressGestureRecognizer *)lpGR

{
    
    if (lpGR.state == UIGestureRecognizerStateBegan) {
        self.deleteButton.hidden = NO;
    }
    
    if (lpGR.state == UIGestureRecognizerStateEnded){
        
    }
    
}

-(IBAction)deleteMyListRequest{
    NSString* url = [NSString stringWithFormat:@"%@personal/deleteProgramSeries",
                     MYEPG];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[HiTVGlobals sharedInstance].uid forKey:@"userId"];
    [param setObject:_cellEntity.programSeriesId forKey:@"programSeriesId"];
    [param setObject:_cellEntity.contentType forKey:@"contentType"];
    [param setObject:@"personal" forKey:@"recommendType"];
    
    [BaseAFHTTPManager getRequestOperationForHost:url
                                         forParam:@""
                                    forParameters:param
                                       completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            //[OMGToast showWithText:@"操作成功"];
            [self.delegate refreshAfterDeleteCurrentRow];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        [OMGToast showWithText:error];
        
    }];
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
