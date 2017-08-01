//
//  TPIMAlertView.m
//  HiTV
//
//  Created by yy on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPIMAlertView.h"

//static CGFloat const kMainViewHorizontalPadding = 50.0;
static CGFloat const kMainViewWidth = 240.0;
static CGFloat const kSubviewInnerPadding = 20.0;
//static CGFloat const kButtonWidth = 80.0;
static CGFloat const kButtonHeight = 45.0;
static CGFloat const kMainViewHeight = 145.0;
static CGFloat const kLabelHeight = 20.0;
static CGFloat const kLineBorderWidth = 0.5;
static CGFloat const kImageViewWidth = 40.0;

@interface TPIMAlertView ()
{
    UIImageView *_horLineImgView;
    UIImageView *_verLineImgView;
}
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, retain) UIImageView *imgView;

@end

@implementation TPIMAlertView

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle
{
    self = [super init];
    if (self) {
        
        UIDevice *device = [UIDevice currentDevice]; //Get the device object
        [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
        [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
        
        //init subview
        [self setupSubviews];
        
        self.titleLabel.text = title;

        if ([message rangeOfString:@"</font>"].location != NSNotFound) {
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[message dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:14.0] } documentAttributes:nil error:nil];
            
            [self.messageLabel setAttributedText:attrStr];
        }
        else{
            self.messageLabel.text = message;
        }
        
//        self.messageLabel.text = message;
        [self.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
        [self.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillShow:)
//                                                     name:UIKeyboardWillShowNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardShow:)
//                                                     name:UIKeyboardDidShowNotification
//                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
    }
    return self;
}
- (void)keyboardHide:(NSNotification *)notif {
    
    [self resignFirstResponder];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = [UIScreen mainScreen].bounds;
    _backButton.frame = CGRectMake(0,
                                   0,
                                   self.frame.size.width,
                                   self.frame.size.height);
    if (_imgView) {
        CGFloat mainViewHeight = kMainViewHeight + kImageViewWidth;
        _mainView.frame = CGRectMake((self.frame.size.width - kMainViewWidth) / 2.0,
                                     (self.frame.size.height - mainViewHeight) / 2.0,
                                     kMainViewWidth,
                                     mainViewHeight);
        
        _imgView.frame = CGRectMake((_mainView.frame.size.width - kImageViewWidth) / 2.0 , _mainView.frame.size.height - kButtonHeight - kImageViewWidth - kSubviewInnerPadding / 2.0, kImageViewWidth, kImageViewWidth);
        
        
    }
    else{
        _mainView.frame = CGRectMake((self.frame.size.width - kMainViewWidth) / 2.0,
                                     (self.frame.size.height - kMainViewHeight) / 2.0,
                                     kMainViewWidth,
                                     kMainViewHeight);
        
    }
    
    _titleLabel.frame = CGRectMake(kSubviewInnerPadding,
                                   kSubviewInnerPadding,
                                   _mainView.frame.size.width - kSubviewInnerPadding * 2,
                                   kLabelHeight);
    
    _messageLabel.frame = CGRectMake(kSubviewInnerPadding,
                                     _titleLabel.frame.origin.y + _titleLabel.frame.size.height + kSubviewInnerPadding / 2.0,
                                     _mainView.frame.size.width - kSubviewInnerPadding * 2,
                                     kLabelHeight * 2);
    
    _leftButton.frame = CGRectMake(0,
                                   _mainView.frame.size.height - kButtonHeight,
                                   _mainView.frame.size.width / 2.0,
                                   kButtonHeight);
    
    _rightButton.frame = CGRectMake(_leftButton.frame.origin.x + _leftButton.frame.size.width,
                                    _leftButton.frame.origin.y,
                                    _leftButton.frame.size.width,
                                    _leftButton.frame.size.height);
    
    _horLineImgView.frame = CGRectMake(0, _leftButton.frame.origin.y, _mainView.frame.size.width, kLineBorderWidth);
    _verLineImgView.frame = CGRectMake(_leftButton.frame.origin.x + _leftButton.frame.size.width, _leftButton.frame.origin.y, kLineBorderWidth, _leftButton.frame.size.height + kLineBorderWidth);
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.backgroundColor = [UIColor blackColor];
    _backButton.alpha = 0.3;
    [self addSubview:_backButton];

    
    //main view
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = kColorLightGrayBackground;
    self.mainView.layer.cornerRadius = 5.0;
    self.mainView.layer.masksToBounds = YES;
    [self addSubview:self.mainView];

    
    //title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:self.titleLabel];

    
    //left button
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.leftButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.leftButton.layer.borderWidth = 0.5;
    [self.mainView addSubview:self.leftButton];

    
    //right button
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.rightButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.rightButton.layer.borderWidth = 0.5;
    [self.mainView addSubview:self.rightButton];

    
    //message
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textColor = [UIColor darkGrayColor];
    self.messageLabel.font = [UIFont systemFontOfSize:14.0];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    [self.mainView addSubview:self.messageLabel];
    
    // 水平分割线
    _horLineImgView = [[UIImageView alloc] init];
    _horLineImgView.backgroundColor = [UIColor colorWithHexString:@"DBDBDB"];
    [self.mainView addSubview:_horLineImgView];
    
    // 垂直分割线
    _verLineImgView = [[UIImageView alloc] init];
    _verLineImgView.backgroundColor = [UIColor colorWithHexString:@"DBDBDB"];
    [self.mainView addSubview:_verLineImgView];

}

#pragma mark - show & hide
//- (void)show
//{
//    [self removeFromSuperview];
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//        
//    }];
//    
//    
//    
//}
//
//- (void)hide
//{
//    [self removeFromSuperview];
//}

- (void)show
{
    [self removeFromSuperview];
    self.frame = CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height);
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:[TPIMAlertView class]]) {
            [subview removeFromSuperview];
        }
    }
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [window addSubview:self];
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//        
//    }];
//    [UIView animateWithDuration:0.08f animations:^{
//        
//        self.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
//        
//        
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.12f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            
//            self.transform = CGAffineTransformMakeScale(.5f, .05f);
//            
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                
//                self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//                [self setNeedsLayout];
//                
//            } completion:^(BOOL finished) {
//                //                [self removeFromSuperview];
//                //                [super removeFromSuperview];
//            }];
//        }];
//    }];
}

- (void)hide
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [UIView animateWithDuration:0.08f animations:^{
//        
//        self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
//        
//        
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.12f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            
//            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//            
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                
//                self.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
//                
//            } completion:^(BOOL finished) {
                [self removeFromSuperview];
//                [super removeFromSuperview];
//            }];
//        }];
//    }];
}

#pragma mark - button clicked
- (void)leftButtonClicked:(id)sender
{
    if (self.leftButtonClickBlock) {
        self.leftButtonClickBlock();
    }
    [self hide];
}

- (void)rightButtonClicked:(id)sender
{
    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock();
    }
    [self hide];
}

#pragma mark - Notification
- (void)orientationChanged:(NSNotification *)note  {
    
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:
            [self setNeedsLayout];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self setNeedsLayout];
            
            break;
        case UIDeviceOrientationLandscapeRight:
            [self setNeedsLayout];
            break;
        default:
            break;
    }
}

#pragma mark - Setter
- (void)setImage:(UIImage *)image
{
    _image = image;
    if (image) {
        if (!_imgView) {
            _imgView = [[UIImageView alloc] init];
            _imgView.backgroundColor = [UIColor clearColor];
        }
        _imgView.image = image;
        [_imgView removeFromSuperview];
        [_mainView addSubview:_imgView];
        [self setNeedsLayout];
    }
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    if (imageUrl.length > 0) {
        if (!_imgView) {
            _imgView = [[UIImageView alloc] init];
            _imgView.backgroundColor = [UIColor clearColor];
        }
        [_imgView setImageURL:[NSURL URLWithString:imageUrl]];
        [_imgView removeFromSuperview];
        [_mainView addSubview:_imgView];
        [self setNeedsLayout];
    }
}

@end
