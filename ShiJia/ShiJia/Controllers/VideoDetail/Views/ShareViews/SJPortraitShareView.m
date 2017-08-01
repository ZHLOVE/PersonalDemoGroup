//
//  SJPortraitShareView.m
//  ShiJia
//
//  Created by 峰 on 16/7/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPortraitShareView.h"
#import "SJShareButton.h"
#import "SJVedioNetWork.h"
#import "MBProgressHUD+AddHUD.h"
#import "HiTVGlobals.h"

NSString * const kSJShareButtonViewIconKey      = @"SJShareItemViewIconKey";
NSString * const kSJShareButtonViewTitleKey     = @"SJShareItemViewTitleKey";
NSString * const kUMSocialShareButtonSnsNameKey = @"UMSocialShareSnsNameKey";

@implementation ShareAlertView

- (instancetype)init{
    self = [super init];
    
    if (self) {
        _alertControlView=[[UIControl alloc]init];
        _alertControlView.backgroundColor=RGB(0, 0, 0, 0.3);
        //        [_alertControlView addTarget:self action:@selector(ControlViewAlertClick) forControlEvents:UIControlEventTouchUpInside];
        _alertControlView.alpha=0;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.;
        self.size = CGSizeMake(300, 200);
        
        UILabel *title =[UILabel new];
        title.text = @"分享";
        [self addSubview:title];
        [title sizeToFit];
        title.textAlignment = 1;
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(5);
            make.height.mas_equalTo(20);
        }];
        
        
        
        _titleText = [UITextField new];
        _titleText.placeholder  =self.titleString;
        _titleText.layer.borderWidth = 1.0;
        _titleText.layer.borderColor = kColorLightGray.CGColor;
        [_titleText setTextColor:kColorLightGray];
        [self addSubview:_titleText];
        [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.right.mas_equalTo(self).offset(-20);
            make.top.mas_equalTo(title.mas_bottom).offset(20);
            make.height.mas_equalTo(30);
        }];
        
        __weak __typeof(self)weakSelf = self;
        
        [RACObserve(_titleText, text) subscribeNext:^(id x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.titleString = (NSString *)x;
            strongSelf.theModel.videoTitle = x;
            _titleText.placeholder  =strongSelf.titleString;
        }];
        
        NSArray *arr = @[@"往前30秒",@"往前60秒"];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
        
        
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: kColorLightGray};
        [segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        segment.tintColor = kColorBlueTheme;
        
        [self addSubview:segment];
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_titleText);
            make.top.mas_equalTo(_titleText.mas_bottom).offset(20);
            make.height.mas_equalTo(30);
        }];
        
        segment.selectedSegmentIndex = 0;
        
        [RACObserve(segment, selectedSegmentIndex) subscribeNext:^(id x) {
            NSInteger seleted = [x integerValue];
            if (seleted==0) {
                self.theModel.videoSecond = 30;
                self.smsModel.shareSeconds = @"30";
            }else{
                self.theModel.videoSecond = 60;
                self.smsModel.shareSeconds = @"60";
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)self.theModel.videoSecond] forKey:LOG_SHARE_VIDEO_LENGTH];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", 30] forKey:LOG_SHARE_VIDEO_LENGTH];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        UIImageView *line1 =[UIImageView new];
        line1.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-40);
            make.height.mas_equalTo(1);
        }];
        
        UIImageView *line2 = [UIImageView new];
        line2.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerX.mas_equalTo(line1);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(line1.mas_bottom);
        }];
        
        _button1 =[UIButton buttonWithType:UIButtonTypeSystem];
        [_button1 setTitle:@"取消" forState:UIControlStateNormal];
        _button1.tag = 100;
        [_button1 setTitleColor:kColorLightGray forState:UIControlStateNormal];
        
        [self addSubview:_button1];
        [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.mas_equalTo(self);
            make.right.mas_equalTo(line2.mas_left);
            make.top.mas_equalTo(line2);
        }];
        
        
        [[self.button1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf hiddenAlertView];
            
        }];
        
        _button2 =[UIButton buttonWithType:UIButtonTypeSystem];
        _button2.tag = 200;
        [_button2 setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        [_button2 setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:_button2];
        [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self);
            make.left.mas_equalTo(line2.mas_right);
            make.top.mas_equalTo(line2);
            
        }];
        
        [[self.button2 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [_titleText resignFirstResponder];
            [strongSelf hiddenAlertView];
            if (strongSelf.sharedelegate) {
                [MBProgressHUD showMessag:@"生成分享链接" toView:strongSelf.alertSuperView];
                [self generationSMSH5WebLinkUrl];
                //                 [SJVedioNetWork SJ_VedioCutManange:strongSelf.theModel Block:^(id result, NSString *error) {
                //                 [MBProgressHUD hideAllHUDsForView:strongSelf.alertSuperView animated:YES];
                //
                //                 [strongSelf.sharedelegate SJShareContentWithPlatform:strongSelf.shareType andModel:nil isDo:NO];
                //                 NSString* str = [NSUserDefaultsManager getObjectForKey:LOG_SHARE_CONTENT];
                //
                //                 if (error) {
                //                 if (str != nil) {
                //                 [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,-1]];
                //                 [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
                //                 }
                //                 [MBProgressHUD showError:@"该节目分享失败" toView:strongSelf.alertSuperView];
                //                 }else{
                //                 if ([result[@"code"] isEqualToString:@"0"]) {
                //                 SJ30SVedioModel *shareModel =[ SJ30SVedioModel mj_objectWithKeyValues:result[@"data"]];
                //
                //                 shareModel.title = strongSelf.theModel.videoTitle;
                //
                //                 shareModel.content =[NSString stringWithFormat:@"%@给你分享的%@，这段视频有点意思，打开看看吧。",[HiTVGlobals sharedInstance].nickName,self.theModel.videoTitle];
                //
                //                 if ([strongSelf.sharedelegate respondsToSelector:@selector(SJShareContentWithPlatform: andModel: isDo:)]) {
                //                 [strongSelf.sharedelegate SJShareContentWithPlatform:strongSelf.shareType andModel:shareModel isDo:YES];
                //
                //
                //                 }
                //                 }else{
                //
                //                 if (str != nil) {
                //                 [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,-1]];
                //                 [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
                //                 }
                //                 [MBProgressHUD showError:@"该节目分享失败" toView:strongSelf.alertSuperView];
                //                 }
                //                 }
                //                 }];
                
            }
        }];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(keyboardFrame:)
         name:UIKeyboardWillChangeFrameNotification
         object:nil];
    }
    return self;
}

-(void)generationSMSH5WebLinkUrl{
    [SJVedioNetWork ShareSmsVideoWithParams:self.smsModel
                                      Block:^(SMSResponseModel *model, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.alertSuperView animated:YES];
        
        //[self.sharedelegate SJShareContentWithPlatform:self.shareType andModel:nil isDo:NO];
        NSString* str = [NSUserDefaultsManager getObjectForKey:LOG_SHARE_CONTENT];
        
        if (error) {
            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,-1]];
                [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
            }
            [MBProgressHUD showError:@"该节目分享失败" toView:self.alertSuperView];
        }else{
            if ([model.resultCode isEqualToString:@"000"]) {
                SJ30SVedioModel *shareModel =[ SJ30SVedioModel new];
                shareModel.link = model.visitUrl;
                shareModel.imgUrl = model.imageUrl;
                shareModel.userName = _smsModel.userName;
                shareModel.userHeadImageUrl =_smsModel.userImgUrl;
                shareModel.title = model.title;
                
                shareModel.content =[NSString stringWithFormat:@"%@给你分享的%@，这段视频有点意思，打开看看吧。",[HiTVGlobals sharedInstance].nickName,model.title];
                
                if ([self.sharedelegate respondsToSelector:@selector(SJShareContentWithPlatform: andModel: isDo:)]) {
                    [self.sharedelegate SJShareContentWithPlatform:self.shareType andModel:shareModel isDo:YES];
                    
                    
                }
            }else{
                
                [MBProgressHUD showError:@"该节目分享失败" toView:self.alertSuperView];
            }
        }
    }];
}

- (void)showAlertViewIn:(UIView *)superView{
    self.alertSuperView = superView;
    self.hidden = YES;
    if (self.isHidden) {
        self.hidden = NO;
        if (_alertControlView.superview==nil) {
            [self.alertSuperView addSubview:_alertControlView];
            [_alertControlView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _alertControlView.alpha=1;
        }];
        CATransition *animation = [CATransition  animation];
        //animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        
        [self.layer addAnimation:animation forKey:@"animation2"];
        self.frame = CGRectMake((SCREEN_WIDTH-300)/2,(SCREEN_HEIGHT-200)/2, 300,200);
        [self.alertSuperView addSubview:self];
        
    }
}

- (void)keyboardFrame:(NSNotification*)notification
{
    
    CGRect rect = [[notification.userInfo
                    valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.superview.frame.size.height - rect.size.height - self.frame.size.height,
                            self.frame.size.width,
                            self.frame.size.height);
    
    [UIView animateWithDuration:0.8
                     animations:^{
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)hiddenAlertView{
    
    if (!self.isHidden) {
        self.hidden = YES;
        CATransition *animation = [CATransition  animation];
        //animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [self.layer addAnimation:animation forKey:@"animtion2"];
        [UIView animateWithDuration:0.2 animations:^{
            _alertControlView.alpha=0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
}


@end
@interface SJPortraitShareView ()

@property (nonatomic) NSInteger typeOfView;
//竖屏
@property (nonatomic, strong) UIControl *ControlView;
@property (nonatomic, strong) UIView    *middleView;
@property (nonatomic, strong) UIButton  *cancelButton;
//横屏
@property (nonatomic, strong) UIView    *LandspaceView;
//弹窗
@property (nonatomic, strong) ShareAlertView *alertView;

@property (nonatomic, strong) UIView *superControllerView;

@property (nonatomic, strong) SJ30SVedioModel *shareModel;

@end

@implementation SJPortraitShareView

- (instancetype)initWithTpye:(NSInteger)type
{
    self = [super init];
    if (self) {
        self.typeOfView = type;
        self.hidden = YES;
        
        _ControlView=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _ControlView.backgroundColor=RGB(0, 0, 0, 0.3);
        [_ControlView addTarget:self action:@selector(ControlViewClick) forControlEvents:UIControlEventTouchUpInside];
        _ControlView.alpha=0;
        
        if (type==1) {
            self.backgroundColor = [UIColor lightGrayColor];
            [self initProtrait];
        }else{
            self.backgroundColor = RGB(0, 0, 0, 0.8);
            [self initLandSpace];
        }
        
    }
    return self;
}

- (void)initProtrait{
    
    [self addSubview:self.cancelButton];
    [self addSubview:self.middleView];
    [self addSubViewsConstraints];
    
}

-(void)initLandSpace{
    
    [self addSubview:self.LandspaceView];
    [_LandspaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.width.mas_equalTo(235);
    }];
}


-(UIView *)LandspaceView{
    if (!_LandspaceView) {
        _LandspaceView = [UIView new];
        UIImageView *imageLine = [UIImageView new];
        imageLine.backgroundColor = kColorBlueTheme;
        [_LandspaceView addSubview:imageLine];
        [imageLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_LandspaceView);
            make.size.mas_equalTo(CGSizeMake(2, 18));
            make.top.mas_equalTo(_LandspaceView).offset(34);
        }];
        
        
        UILabel *title = [UILabel new];
        title.text = @"分享";
        title.font = [UIFont systemFontOfSize:17.];
        title.textColor = RGB(204, 204, 204, 1);
        [_LandspaceView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(imageLine);
            make.left.mas_equalTo(imageLine.mas_right).offset(9);
        }];
        
        
        UILabel *label = [UILabel new];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:12.];
        label.textColor = RGB(154, 154, 154, 1);
        label.numberOfLines = 2;
        label.text = @"分享到微信、朋友圈、微博、通讯录仅支持30秒或60秒片段";
        [_LandspaceView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_LandspaceView);
            make.top.mas_equalTo(_LandspaceView).offset(70);
        }];
        
        CGSize buttonSize = CGSizeMake(50, 50);
        CGFloat kSpace = (235 -3*50)/3;
        UIButton *baseButton = [UIButton new];
        NSString *path = [[NSBundle mainBundle] pathForResource:SocialPlistName ofType:@"plist"];
        NSArray *shareArray = [NSArray arrayWithContentsOfFile:path];
        
        
        for (int i=0; i<shareArray.count; i++) {
            
            
            NSDictionary *dic = [shareArray objectAtIndex:i];
            UIImage *icon = [UIImage imageNamed:[dic valueForKey:kSJShareButtonViewIconKey]];
            NSString *title = [dic valueForKey:kSJShareButtonViewTitleKey];
            
            
            UIButton *button = [UIButton new];
            button.tag = i+10;
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:RGB(204, 204, 204, 1) forState:UIControlStateNormal];
            //            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:10.];
            [button setImage:icon forState:UIControlStateNormal];
            button.imageView.contentMode=UIViewContentModeScaleAspectFit;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button setTitleEdgeInsets:UIEdgeInsetsMake(71, -25-button.titleLabel.bounds.size.width/2, 0, 0)];
            //  [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -button.titleLabel.bounds.size.width)];
            [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_LandspaceView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i<3) {
                    if (i>0) {
                        make.left.mas_equalTo(baseButton.mas_right).offset(kSpace);
                    }else{
                        make.left.mas_equalTo(_LandspaceView).offset(kSpace);
                    }
                    
                    make.size.mas_equalTo(buttonSize);
                    make.top.mas_equalTo(_LandspaceView).offset(110.);
                }else{
                    
                    make.left.mas_equalTo(_LandspaceView).offset(kSpace+(i-3)*70);
                    make.size.mas_equalTo(buttonSize);
                    make.top.mas_equalTo(_LandspaceView).offset(190.);
                    
                }
            }];
            baseButton = button;
        }
        
        
        
    }
    return _LandspaceView;
}

-(UIView *)middleView{
    if (!_middleView) {
        _middleView = [UIView new];
        
        UIImageView *imageLine1 = [UIImageView new];
        imageLine1.backgroundColor = kColorBlueTheme;
        [_middleView addSubview:imageLine1];
        [imageLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(2.);
            make.left.mas_equalTo(_middleView).offset(20.);
            make.top.mas_equalTo(_middleView).offset(13.);
            make.height.mas_equalTo(14.);
        }];
        
        UILabel *label = [UILabel new];
        label.text = @"分享";
        label.font = [UIFont systemFontOfSize:17.];
        [label sizeToFit];
        [_middleView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageLine1.mas_right).offset(7.);
            make.centerY.mas_equalTo(imageLine1);
        }];
        
        UIImageView *imageLine2 = [UIImageView new];
        imageLine2.backgroundColor = RGB(229, 229, 229, 1);
        [_middleView addSubview:imageLine2];
        [imageLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_middleView);
            make.height.mas_equalTo(1.);
            make.top.mas_equalTo(_middleView).offset(40.);
        }];
        
        _middleView.backgroundColor = [UIColor whiteColor];
        UILabel *label2 =[UILabel new];
        label2.text = @"分享到微信、朋友圈、微博、通讯录仅支持30秒或60秒片段";
        label2.font = [UIFont systemFontOfSize:12.];
        label2.textColor = RGB(154, 154, 154, 1);
        label2.textAlignment  = 1;
        [label2 sizeToFit];
        [_middleView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_middleView);
            make.top.mas_equalTo(imageLine2.mas_bottom).offset(8);
        }];
        
        
        CGSize buttonSize = CGSizeMake(60, 60);
        CGFloat kSpace = (SCREEN_WIDTH -5*60)/6;
        UIButton *baseButton = [UIButton new];
        NSString *path = [[NSBundle mainBundle] pathForResource:SocialPlistName ofType:@"plist"];
        NSArray *shareArray = [NSArray arrayWithContentsOfFile:path];
        
        
        for (int i=0; i<shareArray.count; i++) {
            
            NSDictionary *dic = [shareArray objectAtIndex:i];
            UIImage *icon = [UIImage imageNamed:[dic valueForKey:kSJShareButtonViewIconKey]];
            NSString *title = [dic valueForKey:kSJShareButtonViewTitleKey];
            
            
            UIButton *button = [UIButton new];
            button.tag = i+10;
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:RGB(68, 68, 68, 1) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:11.];
            [button setImage:icon forState:UIControlStateNormal];
            //            [button setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(75, -50, 0, 0)];
            button.titleLabel.textAlignment = 1 ;
            [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_middleView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i>0) {
                    make.left.mas_equalTo(baseButton.mas_right).offset(kSpace);
                }else{
                    make.left.mas_equalTo(_middleView).offset(kSpace);
                }
                make.size.mas_equalTo(buttonSize);
                make.top.mas_equalTo(_middleView).offset(90.);
            }];
            baseButton = button;
        }
        
        
    }
    return _middleView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.tag = 0;
        _cancelButton.backgroundColor =[UIColor whiteColor];
        [_cancelButton setTitleColor:RGB(68, 68, 68, 1) forState:UIControlStateNormal];
        __weak __typeof(self)weakSelf = self;
        [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf hiddleFromSuperView];
        }];
        //        [_cancelButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(void)addSubViewsConstraints{
    
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(50.);
    }];
    
    
    
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(_cancelButton.mas_top).offset(-9);
        make.height.mas_equalTo(175.);
    }];
    
}

- (void)buttonClickAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self hiddleFromSuperView];
    
    if (_shareButtonBlock) {
        self.shareButtonBlock(button);
    }
    
}



- (void)showInView:(UIView *)superView {
    
    self.superControllerView = superView;
    if (self.isHidden) {
        self.hidden = NO;
        if (_ControlView.superview==nil) {
            [superView addSubview:_ControlView];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _ControlView.alpha=1;
        }];
        CATransition *animation = [CATransition  animation];
        //animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype =self.typeOfView==1?kCATransitionFromTop:kCATransitionFromRight;
        [self.layer addAnimation:animation forKey:@"animation1"];
        
        if(self.typeOfView==1){
            self.frame = CGRectMake(0,superView.frame.size.height-235, SCREEN_WIDTH,235);
        }else{
            self.frame = CGRectMake(SCREEN_WIDTH-235,0, 235,SCREEN_HEIGHT);
            
        }
        [superView addSubview:self];
    }
}
- (void)ControlViewClick {
    
    [self hiddleFromSuperView];
}

-(void)hiddleFromSuperView{
    if (!self.isHidden) {
        self.hidden = YES;
        CATransition *animation = [CATransition  animation];
        //animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = self.typeOfView==1?kCATransitionFromBottom:kCATransitionFromLeft;
        [self.layer addAnimation:animation forKey:@"animtion2"];
        [UIView animateWithDuration:0.2 animations:^{
            _ControlView.alpha=0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
}

@end

