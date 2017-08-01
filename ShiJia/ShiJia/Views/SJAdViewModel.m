//
//  SJAdViewModel.m
//  ShiJia
//
//  Created by yy on 2017/5/26.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJAdViewModel.h"
#import "SJAdView.h"
#import "SJAdAlertView.h"

//广告类型
typedef NS_ENUM(NSInteger, SJAdType){
    
    SJAdTypeScreenWithoutDevice,//投屏无设备
    SJAdTypeScreenWithDevice,//投屏有设备
    SJAdTypeDeviceList,//设备列表
    SJAdTypeRemoteControl//遥控器
};

@interface SJAdViewModel ()

@property (nonatomic, assign) SJAdType adType;
@property (nonatomic, strong) UIViewController *activeController;

@end

@implementation SJAdViewModel

#pragma mark - Lifecycle
- (instancetype)initWithActiveController:(UIViewController *)controller
{
    self = [super init];
    
    if (self) {
        
        self.activeController = controller;
    }
    return self;
}

#pragma mark - Operation
- (void)start
{
    if (![[HiTVGlobals sharedInstance].disable_moudles containsObject:@"x3shop"]) {
        [self loadAdRequest];
    }
    else{
        if (self.loadAdFailedBlock) {
            self.loadAdFailedBlock();
        }
    }
}

#pragma mark - Request
- (void)loadAdRequest
{
    
    NSString* url = [HiTVGlobals sharedInstance].shareServiceHost;// shareServiceHost;
    
    //    if (url == nil || url.length == 0) {
    //           url = @"http://192.168.50.138:8080/share-facade/";
    //    }
    NSString *phoneNo = [HiTVGlobals sharedInstance].phoneNo.description;
    NSString *uid = [HiTVGlobals sharedInstance].uid.description;
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:phoneNo,@"phoneNo",
                              uid,@"uid", nil];
    
    [BaseAFHTTPManager postRequestOperationForHost:url forParam:@"get/Config" forParameters:paramDic completion:^(id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        
        if ([[resultDic objectForKey:@"resultCode"] intValue] == 0) {
            
            NSArray *data = [resultDic objectForKey:@"data"];
            for (NSDictionary *dic in data) {
                
//                x3Config1没有xmpp设备时展示
//                x3Config2有
//                x3Config3电视列表
//                x3Config4遥控器
                //actionUrl: "http://www.iqiyi.com/",
                //imageUrl: "http://192.168.50.138:8080/wangli/4.jpg
                
                NSString *actionUrlString = [dic objectForKey:@"actionUrl"];
                NSString *imgUrlString = [dic objectForKey:@"imageUrl"];
                
                NSString *actionKey = [dic objectForKey:@"actionKey"];
                
                if ([actionKey isEqualToString:@"x3Config1"]) {
                    
                    self.adType = SJAdTypeScreenWithoutDevice;
                    SJAdAlertView *adAlertView = [[SJAdAlertView alloc] initWithTitle:@"您还未关联任何电视设备，无法使用投屏，建议关联或购买设备" imageUrl:imgUrlString actionUrl:actionUrlString];
                    adAlertView.activeController = self.activeController;
                    [adAlertView show];
                    
                }
                else if ([actionKey isEqualToString:@"x3Config3"]){
                    
                    self.adType = SJAdTypeDeviceList;
                }
                else if ([actionKey isEqualToString:@"x3Config4"]){
                    
                    self.adType = SJAdTypeRemoteControl;
                    SJAdAlertView *adAlertView = [[SJAdAlertView alloc] initWithTitle:@"您还未关联任何电视设备，无法使用遥控器，建议关联或购买设备" imageUrl:imgUrlString actionUrl:actionUrlString];
                    adAlertView.activeController = self.activeController;
                    [adAlertView show];
                }
                
            }
            
        } else {
            if (self.loadAdFailedBlock) {
                self.loadAdFailedBlock();
            }
        }
        
        
    } failure:^(NSString *error) {
        
        if (self.loadAdFailedBlock) {
            self.loadAdFailedBlock();
        }
    }];
}

@end
