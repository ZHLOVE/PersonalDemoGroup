//
//  TPRecorderHUD.m
//  ChatDemo
//
//  Created by yy on 15/10/13.
//  Copyright © 2015年 yy. All rights reserved.
//

#import "TPRecorderHUD.h"
#import "Masonry.h"



@interface TPRecorderHUD ()

//@property (nonatomic, retain) UIImageView *microphoneIconImgView;
//@property (nonatomic, retain) UIImageView *volumeImgView;
@property (nonatomic, retain) UIImageView *iconImgView;
@property (nonatomic, retain) UIImageView *backIconImgView;
@property (nonatomic, retain) UILabel *countLabel;


@end

@implementation TPRecorderHUD
{
    NSTimer *countTimer;
}

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 100, 100);
        [self setupSubviews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsUpdateConstraints];
}

#pragma mark - subviews
- (void)setupSubviews
{
    /*
    self.microphoneIconImgView = [[UIImageView alloc] init];
    self.microphoneIconImgView.image = [UIImage imageNamed:@"voice1"];
    [self addSubview:self.microphoneIconImgView];
    [self.microphoneIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(-25);
        make.centerY.equalTo(self).with.offset(0);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(50);
    }];
    
    self.volumeImgView = [[UIImageView alloc] init];
    [self addSubview:self.volumeImgView];
    [self.volumeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(25);
        make.centerY.equalTo(self).with.offset(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(60);
    }];
    */
    
    self.iconImgView = [[UIImageView alloc] init];
    self.iconImgView.image = [UIImage imageNamed:@"undo"];
    self.iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImgView.clipsToBounds = YES;
    [self addSubview:self.iconImgView];
    self.iconImgView.hidden = YES;
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    self.backIconImgView = [[UIImageView alloc] init];
//    self.backIconImgView.image = [UIImage imageNamed:@"undo"];
//    self.backIconImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.backIconImgView.clipsToBounds = YES;
//    [self addSubview:self.backIconImgView];
//    self.backIconImgView.hidden = YES;
//    [self.backIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.font = [UIFont systemFontOfSize:70.0];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countLabel];
    self.countLabel.hidden = YES;
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark - volume
- (void)showRecordVolume:(double)volume
{
//    self.microphoneIconImgView.hidden = NO;
//    self.volumeImgView.hidden = NO;
    
    DDLogInfo(@"HUD show volume:%f\n",volume);
    self.iconImgView.hidden = NO;
    self.countLabel.hidden = YES;
    if (volume < 0.2) {
        self.iconImgView.image = [UIImage imageNamed:@"muc_record2_wave0"];
//        self.backIconImgView.image = [UIImage imageNamed:@"undo"];
        
    }
    else if(volume < 0.4){
        self.iconImgView.image = [UIImage imageNamed:@"muc_record2_wave1"];
    }
    else{
        self.iconImgView.image = [UIImage imageNamed:@"muc_record2_wave2"];
    }
}

- (void)showMicroPhoneImg
{
//    self.microphoneIconImgView.hidden = YES;
//    self.volumeImgView.hidden = YES;
//    self.backIconImgView.hidden = NO;
//    self.countLabel.hidden = YES;
//    self.backIconImgView.image = [UIImage imageNamed:@"voice1"];
    self.iconImgView.hidden = NO;
    self.countLabel.hidden = YES;
    self.iconImgView.image = [UIImage imageNamed:@"muc_record2_wave0"];
}

- (void)showCancelRecordTip
{
//    self.microphoneIconImgView.hidden = YES;
//    self.volumeImgView.hidden = YES;
    self.backIconImgView.hidden = NO;
    self.countLabel.hidden = YES;
    self.iconImgView.image = [UIImage imageNamed:@"muc_record_undo"];
}

- (void)showWarningImg
{
//    self.microphoneIconImgView.hidden = YES;
//    self.volumeImgView.hidden = YES;
    self.iconImgView.hidden = NO;
    self.countLabel.hidden = YES;
    self.iconImgView.image = [UIImage imageNamed:@"muc_record_warning"];
}

- (void)showCountDown
{
//    self.microphoneIconImgView.hidden = YES;
//    self.volumeImgView.hidden = YES;
    self.iconImgView.hidden = YES;
    self.countLabel.hidden = NO;
    if (countTimer == nil) {
        countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        [countTimer fire];
    }
}


- (void)handleTimer
{
    static int count = 11;
    if (count < 1) {
        [countTimer invalidate];
        countTimer = nil;
        count = 11;
        
        if (self.didFinishCounting) {
            self.didFinishCounting();
        }
    }
    else{
        count -- ;
        self.countLabel.text = [NSString stringWithFormat:@"%zd",count];
    }
    
}

#pragma mark - setter
- (void)setMode:(TPRecorderHUDMode)mode
{
    _mode = mode;
}

@end
