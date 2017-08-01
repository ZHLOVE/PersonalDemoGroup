//
//  ProgramCell.m
//  HiTV
//
//  Created by 蒋海量 on 15/1/23.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "ProgramCell.h"
#import "TVDataProvider.h"

NSString* const cProgramCellID = @"ProgramCell";
CGFloat cProgramCellHeight = 44;
@interface ProgramCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *prossBg;
@property (strong, nonatomic) IBOutlet UIImageView *prossImg;

@end
@implementation ProgramCell
- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
    self.line.backgroundColor = kTabLineColor;
    
    self.prossBg.backgroundColor = kTabLineColor;
    self.prossBg.layer.masksToBounds = YES;
    self.prossBg.layer.cornerRadius = 3.0;
    self.prossBg.hidden = YES;
    self.prossImg.hidden = YES;

}
- (void)setTvProgram:(TVProgram *)tvProgram{
    _tvProgram = tvProgram;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",tvProgram.displayedStartTime,tvProgram.displayedEndTime];
    self.nameLabel.text = tvProgram.programName;
    
    if ([tvProgram canPlay]) {
        self.nameLabel.textColor = kLiveColor;
        self.timeLabel.textColor = kLiveColor;
        self.typeLabel.text = @"直播";
        if ([OPENFLAG isEqualToString:@"0"]) {
            self.typeLabel.text = @"最新";
        }
        else{
            self.typeLabel.text = @"直播";
        }
        self.typeLabel.textColor = [UIColor redColor];
        self.prossBg.hidden = NO;
        self.prossImg.hidden = NO;
        
        NSTimeInterval timeIntervalSince1970 = [[NSDate date] timeIntervalSince1970];
        int m= (int)timeIntervalSince1970-[tvProgram.startTime intValue]-[HiTVGlobals sharedInstance].delaySecond;
        int n =[tvProgram.endTime intValue]- [tvProgram.startTime intValue];
        
        if (!_prossImg) {
            _prossImg = [[UIImageView alloc]init];
            _prossImg.backgroundColor = kColorBlueTheme;
            _prossImg.layer.masksToBounds = YES;
            _prossImg.layer.cornerRadius = 3.0;
            [self.prossBg addSubview:_prossImg];
        }
        self.prossImg.frame = CGRectMake(0, 0, (W-80-15)*m/n, self.prossBg.frame.size.height);
    }
    else if ([tvProgram canReplay]) {
        self.nameLabel.textColor = kLiveColor;
        self.timeLabel.textColor = kLiveColor;
        self.typeLabel.text = @"回看";
        self.typeLabel.textColor = [UIColor darkGrayColor];
        self.prossBg.hidden = YES;
        self.prossImg.hidden = YES;
    }
    else{
        self.nameLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.typeLabel.text = @"未播";
        self.typeLabel.textColor = [UIColor lightGrayColor];
        self.prossBg.hidden = YES;
        self.prossImg.hidden = YES;
    }
}

@end
