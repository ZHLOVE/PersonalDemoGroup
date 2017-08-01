//
//  MLPlayVoiceButton.m
//  CustomerPo
//
//  Created by molon on 8/15/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MLPlayVoiceButton.h"
#import "MLDataResponseSerializer.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define AMR_MAGIC_NUMBER "#!AMR\n"

NSString * const kMLPlayVoiceButtonDidFinishPlayingNotification = @"MLPlayVoiceButtonDidFinishPlayingNotification";
NSString * const kMLPlayVoiceButtonDidStartPlayingNotification = @"MLPlayVoiceButtonDidStartPlayingNotification";
NSString * const kMLPlayVoiceButtonObjectKey = @"MLPlayVoiceButtonObjectKey";

static NSString * kMLPlayVoiceButtonTypeLeftTextColor = @"36C3ED";
static NSString * kMLPlayVoiceButtonTypeRightTextColor = @"FFFFFF";
static CGFloat kVoiceTimeLabelWidth = 20.0;

@interface MLPlayVoiceButton()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AFHTTPRequestOperation *af_dataRequestOperation;

@property (nonatomic, strong) NSURL *voiceURL;

@property (nonatomic, assign, readwrite) BOOL isVoicePlaying;

@property (nonatomic, strong) UIImageView *playingSignImageView;

@property (nonatomic, strong) NSURL *filePath;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, assign) MLPlayVoiceButtonState voiceState;

@property (nonatomic, strong) UILabel *voiceTimeLabel;

@property (nonatomic, strong) UIImageView *errorImgView;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, assign) BOOL isAmrFile;


@end

@implementation MLPlayVoiceButton

#pragma mark - cache
+ (MLDataCache*)sharedDataCache
{
    return [MLDataCache shareInstance];
}

#pragma mark - cancel
- (void)cancelVoiceRequestOperation
{
    [self.af_dataRequestOperation cancel];
    self.af_dataRequestOperation = nil;
}

#pragma mark - life
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayRecorder) name:LeaveChatRoomNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    [self addSubview:self.playingSignImageView];
    [self addSubview:self.indicator];
    [self addSubview:self.voiceTimeLabel];
    [self addSubview:self.errorImgView];
    
    self.voiceState = MLPlayVoiceButtonStateNone;
    
    [self updatePlayingSignImage];
    
    //        [self setBackgroundImage:[UIImage imageWithPureColor:[UIColor colorWithWhite:0.253 alpha:0.650]] forState:UIControlStateHighlighted];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playReceiveStop:) name:MLAMRPLAYER_PLAY_RECEIVE_STOP_NOTIFICATION object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playReceiveError:) name:MLAMRPLAYER_PLAY_RECEIVE_ERROR_NOTIFICATION object:nil];
    
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - notification
- (void)playReceiveStop:(NSNotification*)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (![userInfo[@"filePath"] isEqual:self.filePath]) {
        return;
    }
    [self updatePlayingSignImage];

    [[NSNotificationCenter defaultCenter] postNotificationName:kMLPlayVoiceButtonDidFinishPlayingNotification object:self userInfo:@{kMLPlayVoiceButtonObjectKey:self}];
    
}

- (void)playReceiveError:(NSNotification*)notification
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"播放录音出错";
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
    NSDictionary *userInfo = notification.userInfo;
    if (![userInfo[@"filePath"] isEqual:self.filePath]) {
        [self setVoiceWithURL:self.voiceURL];
        return;
    }
//#warning 这里最好做下发现当前音频播放错误处理
//    DLOG(@"发现音频播放错误:%@",[self.filePath path]);
    [self updatePlayingSignImage];
}

- (void)stopPlayRecorder
{
    if (self.isAmrFile) {
//        [[MLAmrPlayer shareInstance] stopPlaying];
    }
    else{
        
        [self.audioPlayer stop];
    }
    
}

#pragma mark - event
- (void)click
{
    DDLogInfo(@"\n\nplay button clicked\n\n");
    if (!self.filePath) {
        self.errorImgView.hidden = NO;
        self.playingSignImageView.hidden = YES;
        [self setVoiceWithURL:self.voiceURL];
        return;
    }
    self.errorImgView.hidden = YES;
    if (!self.isVoicePlaying) {
        if (self.voiceWillPlayBlock) {
            self.voiceWillPlayBlock(self);
        }
        if (self.isAmrFile) {
//            [[MLAmrPlayer shareInstance] playWithFilePath:self.filePath];
        }
        else{
            
            NSError *error;
            //[[AVAudioSession sharedInstance] setActive:NO error:nil];
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.filePath error:&error];
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer setDelegate:self];
            
            [self.audioPlayer play];
            //[[AVAudioSession sharedInstance] setActive:YES error:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kMLPlayVoiceButtonDidStartPlayingNotification object:self userInfo:@{kMLPlayVoiceButtonObjectKey:self}];
            DDLogInfo(@"outputNumberOfChannels:%zd",[AVAudioSession sharedInstance].outputNumberOfChannels);
        }
        
        [self updatePlayingSignImage];
        
    }else{
        
        if (self.showOnDanmu) {
            return;
        }
        if (self.isAmrFile) {
//            [[MLAmrPlayer shareInstance]stopPlaying];
        }
        else{
            [self.audioPlayer stop];
            if (self.voiceDidFinishPlayingBlock) {
                self.voiceDidFinishPlayingBlock(self);
                
            }
        }
        [self updatePlayingSignImage];
    }
}

#pragma mark - getter
- (BOOL)isVoicePlaying
{
    if (self.isAmrFile) {
//        if ([MLAmrPlayer shareInstance].isPlaying&&[[MLAmrPlayer shareInstance].filePath isEqual:self.filePath]) {
//            return YES;
//        }
    }
    else{
        return self.audioPlayer.playing;
    }
    
    return NO;
}

- (UIImageView *)playingSignImageView
{
    if (!_playingSignImageView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _playingSignImageView = imageView;
    }
    return _playingSignImageView;
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }
    return _indicator;
}

- (UILabel *)voiceTimeLabel
{
    if (!_voiceTimeLabel) {
        _voiceTimeLabel = [[UILabel alloc] init];
        _voiceTimeLabel.backgroundColor = [UIColor clearColor];
        _voiceTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _voiceTimeLabel.textAlignment = NSTextAlignmentCenter;
        _voiceTimeLabel.textColor = [UIColor whiteColor];
    }
    return _voiceTimeLabel;
}

- (UIImageView *)errorImgView
{
    if (!_errorImgView) {
        _errorImgView = [[UIImageView alloc] init];
        _errorImgView.image = [UIImage imageNamed:@"muc_voice_error"];
        _errorImgView.hidden = YES;
    }
    return _errorImgView;
}

#pragma mark - setter
- (void)setType:(MLPlayVoiceButtonType)type
{
    _type = type;
    
    [self updatePlayingSignImage];
    
    [self setNeedsLayout];
}

- (void)setShowOnDanmu:(BOOL)showOnDanmu
{
    _showOnDanmu = showOnDanmu;
    [self updatePlayingSignImage];
    [self setNeedsLayout];
}

- (void)setFilePath:(NSURL *)filePath
{
    _filePath = filePath;
    
    if (filePath) {
        if (self.duration<=0) {
//            _duration = [MLAmrPlayer durationOfAmrFilePath:filePath];
        }
        self.voiceState = MLPlayVoiceButtonStateNormal;
    }else{
        _duration = 0.0f;
        self.voiceState = MLPlayVoiceButtonStateNone;
    }
}

- (void)setVoiceState:(MLPlayVoiceButtonState)voiceState
{
    _voiceState = voiceState;
    
    //如果none啥都没，
    if (voiceState == MLPlayVoiceButtonStateNone) {
        [self.indicator stopAnimating];
        self.playingSignImageView.hidden = YES;
        self.voiceTimeLabel.hidden = YES;
    }else if (voiceState == MLPlayVoiceButtonStateDownloading){
        [self.indicator startAnimating];
        self.playingSignImageView.hidden = YES;
        self.voiceTimeLabel.hidden = YES;
    }else if (voiceState == MLPlayVoiceButtonStateNormal){
        self.playingSignImageView.hidden = NO;
        self.voiceTimeLabel.hidden = NO;
        [self.indicator stopAnimating];
    }
    
    if (self.preferredWidthChangedBlock) {
        self.preferredWidthChangedBlock(self,NO);
    }
}

- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%.f",duration];
    if (self.preferredWidthChangedBlock) {
        self.preferredWidthChangedBlock(self,NO);
    }
}

- (void)setVoiceTime:(CGFloat)voiceTime
{
    _voiceTime = voiceTime;
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%.f",voiceTime];
}

#pragma mark - player
-(void)initPlayer
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //初始化播放器的时候如下设置
    //kAudioSessionCategory_SoloAmbientSound,kAudioSessionCategory_MediaPlayback
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
#pragma clang diagnostic pop
    
    //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    DDLogInfo(@"category:%@",audioSession.category);
    DDLogInfo(@"categoryOptions:%zd",audioSession.categoryOptions);
    
    //默认情况下扬声器播放
    //AVAudioSessionCategorySoloAmbient,AVAudioSessionCategoryPlayback
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    audioSession = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    self.isVoicePlaying = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:kMLPlayVoiceButtonDidFinishPlayingNotification object:self userInfo:@{kMLPlayVoiceButtonObjectKey:self}];
    if (self.voiceDidFinishPlayingBlock) {
        self.voiceDidFinishPlayingBlock(self);
        
    }
    [self updatePlayingSignImage];
    //[[AVAudioSession sharedInstance] setActive:YES error:nil];
}

#pragma mark - 图像
- (void)updatePlayingSignImage
{
    
    if (self.voiceState==MLPlayVoiceButtonStateDownloading) {
        self.playingSignImageView.image = nil;
        return;
    }
    
    NSString *prefix = self.type==MLPlayVoiceButtonTypeLeft?@"ReceiverVoiceNodePlaying00":@"SenderVoiceNodePlaying00";
    if (self.showOnDanmu) {
        prefix = @"DanmuVoiceNodePlaying00";
    }
    if ([self isVoicePlaying]) {
        self.playingSignImageView.image = [UIImage animatedImageNamed:prefix duration:1.0f];
    }else{
        self.playingSignImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@3",prefix]];
    }
}



#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
#define kVoicePlaySignSideLength 20.0f

    

    if (self.type == MLPlayVoiceButtonTypeRight) {
        
        self.voiceTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.voiceTimeLabel.textColor = [UIColor colorWithHexString:kMLPlayVoiceButtonTypeRightTextColor];
        
        self.playingSignImageView.frame = CGRectMake((self.frame.size.width -kVoicePlaySignSideLength - kVoiceTimeLabelWidth) / 2.0,
                                                     (self.frame.size.height-kVoicePlaySignSideLength) / 2.0,
                                                     kVoicePlaySignSideLength,
                                                     kVoicePlaySignSideLength);
        
        
        self.voiceTimeLabel.frame = CGRectMake(self.playingSignImageView.frame.origin.x +kVoicePlaySignSideLength,
                                               0,
                                               kVoiceTimeLabelWidth,
                                               self.frame.size.height);

        
    }
    else{
        if (self.showOnDanmu) {
            self.voiceTimeLabel.textAlignment = NSTextAlignmentRight;
            self.voiceTimeLabel.textColor = [UIColor colorWithHexString:kMLPlayVoiceButtonTypeLeftTextColor];
        }
        else{
            self.voiceTimeLabel.textAlignment = NSTextAlignmentRight;
            self.voiceTimeLabel.textColor = [UIColor colorWithHexString:kMLPlayVoiceButtonTypeLeftTextColor];
        }
        
        
        self.voiceTimeLabel.frame = CGRectMake((self.frame.size.width -kVoicePlaySignSideLength - kVoiceTimeLabelWidth) / 2.0, 0, kVoiceTimeLabelWidth, self.frame.size.height);
        
        self.playingSignImageView.frame = CGRectMake(self.voiceTimeLabel.frame.origin.x + kVoiceTimeLabelWidth, (self.frame.size.height - kVoicePlaySignSideLength) / 2.0, kVoicePlaySignSideLength, kVoicePlaySignSideLength);

    }
    self.indicator.frame = self.playingSignImageView.frame;
    
    self.errorImgView.frame = CGRectMake((self.frame.size.width-kVoicePlaySignSideLength)/2.0, (self.frame.size.height-kVoicePlaySignSideLength)/2.0, 20, 20);
    
}

#pragma mark - outcall
- (void)setVoiceWithURL:(NSURL*)url
{
    [[self class] sharedDataCache].isPublicVoice = self.isPublicVoice;
    [self setVoiceWithURL:url withAutoPlay:NO];
}

- (void)setVoiceWithURL:(NSURL*)url withAutoPlay:(BOOL)autoPlay
{
    __weak __typeof(self)weakSelf = self;
    [self setVoiceWithURL:url success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSURL *voicePath) {
        if (!voicePath) {
            weakSelf.filePath = voicePath;
            return;
        }
        
        weakSelf.filePath = voicePath;
        if (autoPlay) {
            if (weakSelf.voiceWillPlayBlock) {
                weakSelf.voiceWillPlayBlock(weakSelf);
            }
//            [[MLAmrPlayer shareInstance]playWithFilePath:weakSelf.filePath];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        DLOG(@"%@",error);
        weakSelf.filePath = nil;
    }];
}

- (void)setVoiceWithURL:(NSURL *)url success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSURL* voicePath))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    [self setVoiceWithURLRequest:request success:success failure:failure];
}

- (void)setVoiceWithURLRequest:(NSURLRequest *)urlRequest success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSURL* voicePath))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    self.voiceURL = [urlRequest URL];
    
    // 这里有个弊端，例如上一个设置了autoPlay，然后tableViewCell重用后，会取消，然后肯定上面那个就不能自动播放了，似乎也不适合处理这个情况。回头再考虑吧。不过有个应该考虑下，下一半还没下完，然后被重用了,这样之前的下载就被丢弃了！，AFNetworking的图片处理也有类似情况
    self.filePath = nil;
    [self cancelVoiceRequestOperation];
    
    if ([self.voiceURL isFileURL]) {
        if (success) {
            success(urlRequest, nil, self.voiceURL);
        } else if (self.voiceURL) {
            self.filePath = self.voiceURL;
        }
        return;
    }
    
    if (nil==self.voiceURL) {
        if (success) {
            success(urlRequest,nil,self.voiceURL);
        }
        return;
    }
    
    NSURL *filePath = [[[self class] sharedDataCache] cachedFilePathForRequest:urlRequest];
    if (filePath) {
        if (success) {
            success(nil, nil, filePath);
        } else {
            self.filePath = filePath;
        }
        self.af_dataRequestOperation = nil;
    } else {
        self.voiceState = MLPlayVoiceButtonStateDownloading;
        
//        DLOG(@"下载音频%@",[urlRequest URL]);
        __weak __typeof(self)weakSelf = self;
        self.af_dataRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        self.af_dataRequestOperation.responseSerializer = [MLDataResponseSerializer shareInstance];
        
        [self.af_dataRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            static const char* amrHeader = AMR_MAGIC_NUMBER;
            char magic[8];
            [responseObject getBytes:magic length:strlen(amrHeader)];
            
            NSString *urlstr = [NSString stringWithFormat:@"%@",[urlRequest URL].absoluteString];
            if ([urlstr hasSuffix:@"amr"]) {
                strongSelf.isAmrFile = YES;
            }
            else{
                strongSelf.isAmrFile = NO;
            }
            
//            if (strncmp(magic, amrHeader, strlen(amrHeader)))
//            {
//                strongSelf.isAmrFile = NO;
//                /* modified by yy
//                NSError *error = [NSError errorWithDomain:kMLPlayVoiceButtonErrorDomain code:MLPlayVoiceButtonErrorCodeWrongVoiceFomrat userInfo:@{NSLocalizedDescriptionKey:@"音频非amr文件"}];
//                if (failure) {
//                    failure(urlRequest,operation.response,error);
//                }
//                return;
//                  */
//            }
//            else{
//                strongSelf.isAmrFile = YES;
//            }
            
            if ([[urlRequest URL] isEqual:[operation.request URL]]) {
                //写入文件
                [[[strongSelf class] sharedDataCache] cacheData:responseObject forRequest:urlRequest afterCacheInFileSuccess:^(NSURL *filePath) {
                    if (success) {
                        
                        success(urlRequest, operation.response, filePath);
                    } else if (filePath) {
                        strongSelf.filePath = filePath;
                    }
                } failure:^{
                    
                    NSError *error = [NSError errorWithDomain:kMLPlayVoiceButtonErrorDomain code:MLPlayVoiceButtonErrorCodeCacheFailed userInfo:@{NSLocalizedDescriptionKey:@"写入音频缓存文件失败"}];
                    if (failure) {
                        failure(urlRequest, operation.response, error);
                    }
                }];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([[urlRequest URL] isEqual:[operation.request URL]]) {
                if (failure) {
                    failure(urlRequest, operation.response, error);
                }
            }
        }];
        
        [[MLDataResponseSerializer sharedDataRequestOperationQueue] addOperation:self.af_dataRequestOperation];
    }
}


#pragma mark - preferredWidth
- (CGFloat)preferredWidth
{
#define kMinDefaultWidth 50.0f
#define kMaxWidth 120.0f
    if (self.voiceState != MLPlayVoiceButtonStateNormal) {
        return kMinDefaultWidth;
    }
    
    CGFloat width = kMinDefaultWidth + ceil(self.duration)*5.0f;
    if (width>kMaxWidth) {
        width = kMaxWidth;
    }
    return width;
}

@end
