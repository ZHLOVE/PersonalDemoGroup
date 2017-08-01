//
//  SJAppdelegateService.h
//  ShiJia
//
//  Created by yy on 16/4/20.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMSCoinView.h"

@class TPIMContentModel;

@interface SJAppdelegateService : NSObject

@property (nonatomic, assign) BOOL         isInBackground;
@property (nonatomic, strong) NSDictionary *pushInfo;
@property (nonatomic, assign) BOOL SetF;

@property (nonatomic, assign) BOOL hasMainVC; //是有加载过主控制器

@property (nonatomic, strong) UIView *coinView;
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, assign) BOOL isMainVCLoaded;


//- (BOOL)firstLaunching;
- (void)showMainViewController;
- (void)showDefaultTemplate;
- (void)pushToVideoDetailController:(TPIMContentModel *)contentModel;
- (void)loadRemoteLogo;
- (void)removeProgramKuaiBaoNotification;
- (void)removeProgramReminderNotification;
- (void)modifyMessageStateWithMsgId:(NSString *)msgid;
-(void)setRemoteLogoToLoading:(BOOL)isLoading;
@end
