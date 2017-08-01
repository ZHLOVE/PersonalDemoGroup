//
//  SPPhotoPlayerView.m
//  InstagramPhotoPicker
//
//  Created by SeacCong on 15/1/14.
//  Copyright (c) 2015年 wenzhaot. All rights reserved.
//

#import "SPPhotoPlayerView.h"

@interface SPPhotoPlayerView()<UIGestureRecognizerDelegate>
{
    //播放控制条状态
    BOOL controlBarHide;
    //投屏状态
    BOOL screenProjectioning;
    //播放状态
    BOOL isPlaying;
    
    NSTimer *controlTimer;
}


@property (strong,nonatomic) UIImageView * bottomImageView;

@end

static const float CONTROL_AUTO_HIDE_TIME = 10.0;

@implementation SPPhotoPlayerView


@synthesize imageNameView,clockwiseBtn,contrarotateBtn,playBtn;
@synthesize imageShowView,screenProjectionBtn,previousBtn,nextBtn;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    NSLog(@"awakeFromNib");
    //默认隐藏播放控制条
//    [self hideControlsAnimated:NO];
    //注册Touch监控
//    [self addGestureTap];
    //初始化Photo Player View
    [self initPhotoPlayerView];
}


- (void)initPhotoPlayerView
{
    //
    self.imageNameView.text = @"";
    
    //创建两个ImageView
    _topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _topImageView.clipsToBounds = YES;
    _topImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_photo_default.png"]];
    [_topImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    _bottomImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bottomImageView.clipsToBounds = YES;

    
    [self addSubview:_bottomImageView];
    [self addSubview:_topImageView];
//    [self addSubview: self.topLayoutView];
//    [self addSubview: self.bottomLayoutView];

    //投屏
    screenProjectionBtn.tag = SPPhotoPlayerProjectionAction;

    [self setScreenProjectioState:NO];
    [screenProjectionBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //前一张
    previousBtn.tag = SPPhotoPlayerPreviousAction;
    [self setButtonBackground:previousBtn NormalImage:@"Screenlast.png" HightLightImage:@"Screenlast.png"];
    [previousBtn  addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //反向旋转90度
    contrarotateBtn.tag = SPPhotoPlayerContrarotateAction;
    [self setButtonBackground:contrarotateBtn NormalImage:@"screen_photo_contrarotate_90.png" HightLightImage:@"screen_photo_contrarotate_90_hightlight.png"];
    [contrarotateBtn  addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //正旋转90度
     clockwiseBtn.tag = SPPhotoPlayerClockwiseAction;
     [self setButtonBackground:clockwiseBtn NormalImage:@"Previous.png" HightLightImage:@"screen_photo_clockwise_90_hightlight.png"];
    [clockwiseBtn  addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //播放按钮，控制两种状态：播放、暂停(默认为暂停状态）
     playBtn.tag = SPPhotoPlayerStopAction;
    [self  setPlayButtonState:NO];
    [playBtn  addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //下一张
     nextBtn.tag = SPPhotoPlayerNextAction;
    [self setButtonBackground:nextBtn NormalImage:@"Screennext.png" HightLightImage:@"Screennext.png"];
    [nextBtn  addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) setPlayButtonState:(BOOL) playing
{
    //modify by jzb at 20150731
    if(!isPlaying){

        [self setButtonBackground:self.playBtn NormalImage:@"Screenplay.png" HightLightImage:@"Screenplay.png"];
    }else{

        [self setButtonBackground:self.playBtn NormalImage:@"Pause-Highlighted.png" HightLightImage:@"Pause-Highlighted.png"];
    }
 }

- (void) switchPlayButtonState
{
    isPlaying = !isPlaying;
    [self setPlayButtonState:isPlaying];
}

- (UIImage*) getShowImage
{
    return _topImageView.image;
}

- (NSString*) getShowImageFileName
{
    return self.imageNameView.text;
}



- (void) setShowImageData:(UIImage*) showImage ImageName:(NSString*) imageName
{
    
    if( [self.delegate respondsToSelector:@selector(hasPrevious)]){
        previousBtn.enabled = [self.delegate hasPrevious];
    }else{
        previousBtn.enabled = NO;
    }
    
    if( [self.delegate respondsToSelector:@selector(hasNext)]){
        nextBtn.enabled = [self.delegate hasNext];
    }else{
        nextBtn.enabled = NO;
    }
    
    _topImageView.image = showImage;
    self.imageNameView.text = imageName;
    //
}

- (void) swtichScreenProjection
{
    screenProjectioning = !screenProjectioning;
    
    [self setScreenProjectioState:screenProjectioning];
}

- (void) setScreenProjectioState:(BOOL) connect
{
    screenProjectioning = connect;
    //modify by jzb at 20150731
//    NSString *imageName = screenProjectioning ? @"screen_photo_projection_highlight.png" : @"screen_photo_projection.png";
    NSString *imageName = screenProjectioning ? @"screenplay.png" : @"screenplay.png";
    
     [screenProjectionBtn setBackgroundImage:[UIImage imageNamed:imageName] forState: UIControlStateNormal ];
}

- (void) setButtonBackground:(UIButton*) button NormalImage:(NSString*) normalImage HightLightImage:(NSString*) hightlightImage
{
    [button setBackgroundImage:[UIImage imageNamed:normalImage] forState: UIControlStateNormal ];
    [button setBackgroundImage:[UIImage imageNamed:hightlightImage] forState: UIControlStateHighlighted ];
}

- (void) controlButtonClicked:(id)sender
{
    NSLog(@"controlButtonClicked");
    //如果点击任何控制按钮，自动隐藏控制条计时器将重新设置

    
    UIButton *button = (UIButton*)sender;
    switch(button.tag)
    {
        case SPPhotoPlayerProjectionAction:
            if(!screenProjectioning){
                if( [self.delegate respondsToSelector:@selector(canScreenProjection)] && [self.delegate canScreenProjection]){
                     [self swtichScreenProjection];
                }
            }else{
                [self swtichScreenProjection];
            }
            break;
            
        case SPPhotoPlayerPreviousAction:
        case SPPhotoPlayerClockwiseAction:
        case SPPhotoPlayerContrarotateAction:
        case SPPhotoPlayerNextAction:
            break;
            
        case SPPhotoPlayerStartAction:
            //播放按钮变为暂停状态
            playBtn.tag = SPPhotoPlayerStopAction;
            [self switchPlayButtonState];
            break;
            
        case SPPhotoPlayerStopAction:
            playBtn.tag = SPPhotoPlayerStartAction;
            [self switchPlayButtonState];
            //播放按钮变为可播放状态
            break;
        
        default:
            NSLog(@"PhotoPlayerView Play state error");
            break;
    }
    
    //

    if((self.delegate)&&
       ([self.delegate respondsToSelector:@selector(playAction:)]))
    {
        [self.delegate playAction:button.tag];
    }
    
}


- (void) addGestureTap
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self action:@selector(handleSingleTap:)];
    
    singleTapGestureRecognizer.delegate = self;
    
    [self addGestureRecognizer:singleTapGestureRecognizer];
}



- (void)handleSingleTap:(id)sender
{
    if (self.bottomLayoutView.alpha) {
        [self hideControlsAnimated:YES];
    } else {
//        [self showControls];
    }
}



#pragma mark - control show / hidden

- (void)showControls
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.topLayoutView.alpha = 1.0;
        weakSelf.bottomLayoutView.alpha = 1.0;
        
    } completion:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlsAnimated:) object:@YES];
    
    [self performSelector:@selector(hideControlsAnimated:) withObject:@YES afterDelay:CONTROL_AUTO_HIDE_TIME];
}

- (void)hideControlsAnimated:(BOOL)animated
{
    __weak typeof(self) weakSelf = self;
    if (animated) {
        
        
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.topLayoutView.alpha = 0;
            weakSelf.bottomLayoutView.alpha = 0;
        } completion:nil];
        
        
    } else {
        weakSelf.topLayoutView.alpha = 0;
        weakSelf.bottomLayoutView.alpha = 0;
        
        
    }
}


- (BOOL) isPlaying
{
    return isPlaying;
}



- (BOOL) isPhotoProjecting
{
    return screenProjectioning;
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.bottomLayoutView]
        || [touch.view isDescendantOfView:self.topLayoutView]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
