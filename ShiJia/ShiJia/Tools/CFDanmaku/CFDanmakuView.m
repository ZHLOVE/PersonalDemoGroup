//
//  CFDanmakuView.m
//  31- CFDanmakuDemo
//
//  Created by 于 传峰 on 15/7/9.
//  Copyright (c) 2015年 于 传峰. All rights reserved.
//

#import "CFDanmakuView.h"
#import "CFDanmakuInfo.h"
#import "MLPlayVoiceButton.h"
#import "Masonry.h"
#import "TPIMGroup.h"

#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define Width(view) view.frame.size.width
#define Height(view) view.frame.size.height
#define Left(view) X(view)
#define Right(view) (X(view) + Width(view))
#define Top(view) Y(view)
#define Bottom(view) (Y(view) + Height(view))
#define CenterX(view) (Left(view) + Right(view)) / 2
#define CenterY(view) (Top(view) + Bottom(view)) / 2

@interface CFDanmakuView ()
{
    NSTimer *_timer;
    //    CGFloat originx;
    //    dispatch_source_t _sourceTimer;
}

@property (nonatomic, strong) NSMutableArray *danmakus;
@property (nonatomic, strong) NSMutableArray *currentDanmakus;
@property (nonatomic, strong) NSMutableArray *subDanmakuInfos;

@property (nonatomic, strong) NSMutableDictionary *linesDict;
@property (nonatomic, strong) NSMutableDictionary *centerTopLinesDict;
@property (nonatomic, strong) NSMutableDictionary *centerBottomLinesDict;
@property (nonatomic, strong) NSTimer *animatedTimer;
@property (nonatomic, strong) NSMutableArray *timerArray;

//@property(nonatomic, assign) BOOL centerPause;

@end

static NSTimeInterval const timeMargin = 0.5;

@implementation CFDanmakuView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.timerArray = [[NSMutableArray alloc] init];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordDidFinishPlaying:) name:kMLPlayVoiceButtonDidFinishPlayingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayingAllRecorders:) name:TPIMNotification_LeaveChatRoom object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - lazy
- (NSMutableArray *)subDanmakuInfos
{
    if (!_subDanmakuInfos) {
        _subDanmakuInfos = [[NSMutableArray alloc] init];
    }
    return _subDanmakuInfos;
}

- (NSMutableDictionary *)linesDict
{
    if (!_linesDict) {
        _linesDict = [[NSMutableDictionary alloc] init];
    }
    return _linesDict;
}

- (NSMutableDictionary *)centerBottomLinesDict
{
    if (!_centerBottomLinesDict) {
        _centerBottomLinesDict = [[NSMutableDictionary alloc] init];
    }
    return _centerBottomLinesDict;
}

- (NSMutableDictionary *)centerTopLinesDict
{
    if (!_centerTopLinesDict) {
        _centerTopLinesDict = [[NSMutableDictionary alloc] init];
    }
    return _centerTopLinesDict;
}

- (NSMutableArray *)currentDanmakus
{
    if (!_currentDanmakus) {
        _currentDanmakus = [NSMutableArray array];
    }
    return _currentDanmakus;
}

#pragma mark - perpare
- (void)prepareDanmakus:(NSArray *)danmakus
{
    self.danmakus = [[danmakus
                      sortedArrayUsingComparator:^NSComparisonResult(CFDanmaku *obj1,
                                                                     CFDanmaku *obj2) {
                          if (obj1.timePoint > obj2.timePoint) {
                              return NSOrderedDescending;
                          }
                          return NSOrderedAscending;
                      }] mutableCopy];
}

- (void)getCurrentTime
{
//    DDLogInfo(@"getCurrentTime---------");
    
    if ([self.delegate danmakuViewIsBuffering:self]) return;
    
    [self.subDanmakuInfos
     enumerateObjectsUsingBlock:^(CFDanmakuInfo *obj, NSUInteger idx,
                                  BOOL *stop) {
         NSTimeInterval leftTime = obj.leftTime;
         leftTime -= timeMargin;
         obj.leftTime = leftTime;
     }];
    
    [self.currentDanmakus removeAllObjects];
    NSTimeInterval timeInterval = [self.delegate danmakuViewGetPlayTime:self];
    NSString *timeStr = [NSString stringWithFormat:@"%0.1f", timeInterval];
    timeInterval = timeStr.floatValue;
    
    [self.danmakus
     enumerateObjectsUsingBlock:^(CFDanmaku *obj, NSUInteger idx, BOOL *stop) {
         if (obj.timePoint >= timeInterval &&
             obj.timePoint < timeInterval + timeMargin) {
             [self.currentDanmakus addObject:obj];
             //            DDLogInfo(@"%f----%f--%zd", timeInterval, obj.timePoint,
             //            idx);
         } else if (obj.timePoint > timeInterval) {
             *stop = YES;
         }
     }];
    
    if (self.currentDanmakus.count > 0) {
        for (CFDanmaku *danmaku in self.currentDanmakus) {
            [self playDanmaku:danmaku];
        }
    }
}

- (void)playDanmaku:(CFDanmaku *)danmaku
{
//    DDLogInfo(@"playDanmaku:\n");
    UILabel *playerLabel = [[UILabel alloc] init];
    playerLabel.attributedText = danmaku.contentStr;
    [playerLabel sizeToFit];
    [self addSubview:playerLabel];
    playerLabel.backgroundColor = [UIColor clearColor];
    
    MLPlayVoiceButton *button = nil;
    if (danmaku.type == CFDanmakuTypeRecord) {
        button = [[MLPlayVoiceButton alloc] init];
        button.showOnDanmu = YES;
        button.type = MLPlayVoiceButtonTypeLeft;
        button.voiceTime = [danmaku.recordDuration floatValue];
        [button
         setBackgroundImage:[[UIImage imageNamed:@"muc_danmu_bubble"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(
                                                                          20, 20, 20, 20)]
         forState:UIControlStateNormal];
        [button setVoiceWithURL:[NSURL URLWithString:danmaku.recordUrlStr]];
        
        [self addSubview:button];
        
    }
    
    switch (danmaku.position) {
        case CFDanmakuPositionNone:
            [self playFromRightDanmaku:danmaku
                           playerLabel:playerLabel
                          recordButton:button];
            break;
            
        case CFDanmakuPositionCenterTop:
        case CFDanmakuPositionCenterBottom:
        {
            playerLabel.numberOfLines = 1;
            playerLabel.adjustsFontSizeToFitWidth = YES;
            [self playCenterDanmaku:danmaku
                        playerLabel:playerLabel
                       recordButton:button];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - center top \ bottom
- (void)playCenterDanmaku:(CFDanmaku *)danmaku
              playerLabel:(UILabel *)playerLabel
             recordButton:(MLPlayVoiceButton *)button
{
    NSAssert(self.centerDuration && self.maxCenterLineCount,
             @"如果要使用中间弹幕 "
             @"必须先设置中间弹幕的时间及最大行数");
    
    CFDanmakuInfo *newInfo = [[CFDanmakuInfo alloc] init];
    newInfo.playLabel = playerLabel;
    newInfo.leftTime = self.centerDuration;
    newInfo.danmaku = danmaku;
    newInfo.recordButton = button;
    
    NSMutableDictionary *centerDict = nil;
    
    if (danmaku.position == CFDanmakuPositionCenterTop) {
        centerDict = self.centerTopLinesDict;
    } else {
        centerDict = self.centerBottomLinesDict;
    }
    
    NSInteger valueCount = centerDict.allKeys.count;
    if (valueCount == 0) {
        newInfo.lineCount = 0;
        [self addCenterAnimation:newInfo centerDict:centerDict];
        return;
    }
    for (int i = 0; i < valueCount; i++) {
        CFDanmakuInfo *oldInfo = centerDict[@(i)];
        if (!oldInfo) break;
        if (![oldInfo isKindOfClass:[CFDanmakuInfo class]]) {
            newInfo.lineCount = i;
            [self addCenterAnimation:newInfo centerDict:centerDict];
            break;
        } else if (i == valueCount - 1) {
            if (valueCount < self.maxCenterLineCount) {
                newInfo.lineCount = i + 1;
                [self addCenterAnimation:newInfo centerDict:centerDict];
            } else {
                [self.danmakus removeObject:danmaku];
                [playerLabel removeFromSuperview];
                
//                DDLogInfo(@"同一时间评论太多--排不开了-------------------------" @"-");
            }
        }
    }
}

- (void)addCenterAnimation:(CFDanmakuInfo *)info
                centerDict:(NSMutableDictionary *)centerDict
{
    UILabel *label = info.playLabel;
    NSInteger lineCount = info.lineCount;
    
    if (info.danmaku.position == CFDanmakuPositionCenterTop) {
    
        label.frame = CGRectMake((Width(self) - Width(label)) * 0.5,
                                 (self.lineHeight + self.lineMargin) * lineCount,
                                 Width(label), Height(label));
        
    } else {
        label.frame =
        CGRectMake((Width(self) - Width(label)) * 0.5,
                   Height(self) - Height(label) -
                   (self.lineHeight + self.lineMargin) * lineCount,
                   Width(label), Height(label));
    }
    
    if (info.recordButton != nil) {
        info.recordButton.frame = CGRectMake(X(label) + Width(label), Y(label),
                                             kCFDanmakuInfoRecordButtonWidth,
                                             kCFDanmakuInfoRecordButtonHeight);
    }
    
    centerDict[@(lineCount)] = info;
    [self.subDanmakuInfos addObject:info];
    
    [self performCenterAnimationWithDuration:info.leftTime danmakuInfo:info];
}

- (void)performCenterAnimationWithDuration:(NSTimeInterval)duration
                               danmakuInfo:(CFDanmakuInfo *)info
{
    UILabel *label = info.playLabel;
    
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if (_isPauseing) return;
                       
                       if (info.danmaku.position == CFDanmakuPositionCenterBottom) {
                           self.centerBottomLinesDict[@(info.lineCount)] = @(0);
                       } else {
                           self.centerTopLinesDict[@(info.lineCount)] = @(0);
                       }
                       
                       [label removeFromSuperview];
                       [self.subDanmakuInfos removeObject:info];
                   });
}

#pragma mark - from right
- (void)playFromRightDanmaku:(CFDanmaku *)danmaku
                 playerLabel:(UILabel *)playerLabel
                recordButton:(MLPlayVoiceButton *)button
{
//    DDLogInfo(@"playFromRightDanmaku:\n");
    CFDanmakuInfo *newInfo = [[CFDanmakuInfo alloc] init];
    newInfo.playLabel = playerLabel;
    newInfo.leftTime = self.duration;
    newInfo.danmaku = danmaku;
    
    playerLabel.frame =
    CGRectMake(Width(self), 0, Width(playerLabel), Height(playerLabel));
    if (danmaku.type == CFDanmakuTypeRecord) {
        newInfo.recordButton = button;
        button.frame = CGRectMake(X(playerLabel) + Width(playerLabel), 0,
                                  kCFDanmakuInfoRecordButtonWidth,
                                  kCFDanmakuInfoRecordButtonHeight);
    }
    
    NSInteger valueCount = self.linesDict.allKeys.count;
    if (valueCount == 0) {
        newInfo.lineCount = 0;
        [self addAnimationToViewWithInfo:newInfo];
        return;
    }
    
    for (int i = 0; i < valueCount; i++) {
        CFDanmakuInfo *oldInfo = self.linesDict[@(i)];
        if (!oldInfo) break;
        if (![self judgeIsRunintoWithFirstDanmakuInfo:oldInfo
                                          behindLabel:playerLabel]) {
            newInfo.lineCount = i;
            [self addAnimationToViewWithInfo:newInfo];
            break;
        } else if (i == valueCount - 1) {
            if (valueCount < self.maxShowLineCount) {
                newInfo.lineCount = i + 1;
                [self addAnimationToViewWithInfo:newInfo];
            } else {
                [self.danmakus removeObject:danmaku];
                [playerLabel removeFromSuperview];
                [button removeFromSuperview];
//                DDLogInfo(@"同一时间评论太多--排不开了-------------------------" @"-");
            }
        }
    }
}

- (void)addAnimationToViewWithInfo:(CFDanmakuInfo *)info
{
//    DDLogInfo(@"addAnimationToViewWithInfo\n");
    UILabel *label = info.playLabel;
    NSInteger lineCount = info.lineCount;
    
    label.frame =
    CGRectMake(Width(self), (self.lineHeight + self.lineMargin) * lineCount,
               Width(label), Height(label));
    if (info.recordButton != nil) {
        info.recordButton.frame = CGRectMake(X(label) + Width(label), Y(label),
                                             kCFDanmakuInfoRecordButtonWidth, kCFDanmakuInfoRecordButtonHeight);
    }
    [self.subDanmakuInfos addObject:info];
    self.linesDict[@(lineCount)] = info;
    [self startRunningAnimation:info];
    
}

- (void)performAnimationWithOrigin:(CGFloat)originx
                       danmakuInfo:(CFDanmakuInfo *)info
{
    _isPlaying = YES;
    _isPauseing = NO;
    
    UILabel *label = info.playLabel;
    MLPlayVoiceButton *button = info.recordButton;
    
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         label.frame = CGRectMake(originx, Y(label), Width(label), Height(label));
                         button.frame = CGRectMake(X(label)+Width(label), Y(label), kCFDanmakuInfoRecordButtonWidth, kCFDanmakuInfoRecordButtonHeight);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (BOOL)judgeIsRunintoWithFirstDanmakuInfo:(CFDanmakuInfo *)info
                               behindLabel:(UILabel *)last
{
    UILabel *firstLabel = info.playLabel;
    CGFloat firstSpeed = [self getSpeedFromLabel:firstLabel];
    CGFloat lastSpeed = [self getSpeedFromLabel:last];
    
    CGFloat firstFrameRight = info.leftTime * firstSpeed;
    
    if (info.leftTime <= 1) return NO;
    
    if (Left(last) - firstFrameRight > 10) {
        if (lastSpeed <= firstSpeed) {
            return NO;
        } else {
            CGFloat lastEndLeft = Left(last) - lastSpeed * info.leftTime;
            if (lastEndLeft > 10) {
                return NO;
            }
        }
    }
    
    return YES;
}

// 计算速度
- (CGFloat)getSpeedFromLabel:(UILabel *)label
{
    return (self.bounds.size.width + label.bounds.size.width) / self.duration;
}

#pragma mark - 公共方法
- (BOOL)isPrepared
{
    NSAssert(self.duration && self.maxShowLineCount && self.lineHeight,
             @"必须先设置弹幕的时间\\最大行数\\弹幕行高");
    if (self.danmakus.count && self.lineHeight && self.duration &&
        self.maxShowLineCount) {
        return YES;
    }
    return NO;
}

- (void)start
{
    
    if (_isPauseing) [self resume];
    
    if ([self isPrepared]) {
        if (!_timer) {
            _timer = [NSTimer timerWithTimeInterval:timeMargin
                                             target:self
                                           selector:@selector(getCurrentTime)
                                           userInfo:nil
                                            repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            [_timer fire];
        }
    }
}

- (void)pause
{
    
    if (!_timer || !_timer.isValid) return;
    
    _isPauseing = YES;
    _isPlaying = NO;
    
    [_timer invalidate];
    _timer = nil;
    
    for (CFDanmakuInfo *info in self.subDanmakuInfos) {
        info.pausedOriginX = info.playLabel.frame.origin.x;
    }
    
    for (UIView *view in self.subviews) {
        CALayer *layer = view.layer;
        CGRect rect = view.frame;
        if (layer.presentationLayer) {
            rect = ((CALayer *)layer.presentationLayer).frame;
        }
        view.frame = rect;
        
        
        [view.layer removeAllAnimations];
    }
    
    for (dispatch_source_t timer in self.timerArray) {
        dispatch_source_cancel(timer);
    }
    
}

- (void)resume
{
    
    if (![self isPrepared] || _isPlaying || !_isPauseing) return;
    for (CFDanmakuInfo *info in self.subDanmakuInfos) {
        if (info.danmaku.position == CFDanmakuPositionNone) {
            
            //            [self performAnimationWithDuration:info.leftTime+10 danmakuInfo:info];
            [self startRunningAnimation:info];
        } else {
            _isPauseing = NO;
            [self performCenterAnimationWithDuration:info.leftTime danmakuInfo:info];
        }
    }
    
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeMargin * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self start];
                   });
}

- (void)stop
{
    _isPauseing = NO;
    _isPlaying = NO;
    
    [_timer invalidate];
    _timer = nil;
    [self.danmakus removeAllObjects];
    self.linesDict = nil;
}

- (void)clear
{
    [_timer invalidate];
    _timer = nil;
    self.linesDict = nil;
    _isPauseing = YES;
    _isPlaying = NO;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)sendDanmakuSource:(CFDanmaku *)danmaku
{
    [self playDanmaku:danmaku];
}

#pragma mark - notification
- (void)recordDidFinishPlaying:(NSNotification *)sender
{
    MLPlayVoiceButton *button = [sender.userInfo valueForKey:kMLPlayVoiceButtonObjectKey];
    if (button.frame.origin.x <= -Width(button)-X(button)) {
        DDLogInfo(@"播放结束");
        [button removeFromSuperview];
        if (button.danmuTimer != nil) {
            dispatch_source_cancel(button.danmuTimer);
        }
    }
    
}

- (void)stopPlayingAllRecorders:(NSNotification *)sender
{
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[MLPlayVoiceButton class]]) {
            MLPlayVoiceButton *btn = (MLPlayVoiceButton *)subview;
            [btn stopPlayRecorder];
        }
    }
}

#pragma mark - timer
- (void)startRunningAnimation:(CFDanmakuInfo *)info
{
    __block CGFloat originx = [UIScreen mainScreen].bounds.size.width;
    if (info.pausedOriginX != 0) {
        originx = info.pausedOriginX;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_sourceTimer,dispatch_walltime(NULL, 0),0.1*NSEC_PER_SEC, 0); //每秒执行
    
    info.recordButton.danmuTimer = _sourceTimer;
    
    if (![self.timerArray containsObject:_sourceTimer]) {
        [self.timerArray addObject:_sourceTimer];
    }
    
    dispatch_source_set_event_handler(_sourceTimer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            UILabel *label = info.playLabel;
            MLPlayVoiceButton *button = info.recordButton;
            
            if (info.recordButton != nil) {
                
                //判断按钮是否移出屏幕
                if (originx <= -Width(label)-Width(button)-5) {
                    
                    //不减5屏幕上还会看到播放按钮的侧边
                    //按钮已移出屏幕，取消timer，删除button和label
                    
                    [label removeFromSuperview];
                    
                    //如果录音未播放，直接删除按钮，如果录音还在播放等播放结束且按钮已移出屏幕再删除
                    if (!button.isVoicePlaying) {
                        [button removeFromSuperview];
                    }
                    dispatch_source_cancel(_sourceTimer);
                    [self.timerArray removeObject:_sourceTimer];
//                    DDLogInfo(@"dispatch_source_cancel");
                }
                else{
                    originx -= 5.0;
                    [self performAnimationWithOrigin:originx danmakuInfo:info];
                }
            }
            else{
                
                //判断label是否移出屏幕
                if (originx <= -Width(label)-5) {
                    
                    //label已移出屏幕，取消timer，删除label
                    
                    dispatch_source_cancel(_sourceTimer);
                    [self.timerArray removeObject:_sourceTimer];
                    [label removeFromSuperview];
//                    DDLogInfo(@"dispatch_source_cancel");
                }
                else{
                    originx -= 5.0;
                    [self performAnimationWithOrigin:originx danmakuInfo:info];
                }
            }
            
        });
        
    });
    dispatch_resume(_sourceTimer);
    
}

//- (void)stopRunningAnimation
//{
//    DDLogInfo(@"stopRunningAnimation");
//    if (_sourceTimer != nil) {
//        dispatch_source_cancel(_sourceTimer);
//        _sourceTimer = nil;
//    }
//
//}

#pragma mark - touch
//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event
//{
//    DDLogInfo(@"touchesBegan");
//    UITouch *touch = [touches anyObject];
//    //    CGPoint point = [touch locationInView:self];
//    if (![[touch view] isKindOfClass:[MLPlayVoiceButton class]]) {
//        DDLogInfo(@"未点中语音按钮");
//        if ([self.delegate respondsToSelector:@selector(singleTapBesideRecordButton)]) {
//            [self.delegate singleTapBesideRecordButton];
//        }
//    }
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //    CGPoint point = [touch locationInView:self];
    if (![[touch view] isKindOfClass:[MLPlayVoiceButton class]]) {
        DDLogInfo(@"未点中语音按钮");
        if ([self.delegate respondsToSelector:@selector(singleTapBesideRecordButton)]) {
            [self.delegate singleTapBesideRecordButton];
        }
    }
}
@end
