//
//  ShareVC.m
//  WingsBurning
//
//  Created by MBP on 2016/12/14.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ShareVC.h"
#import "OpenShare.h"
#import "OpenShareHeader.h"
#import "ShareView.h"
#import <MessageUI/MessageUI.h>

@interface ShareVC ()<MFMailComposeViewControllerDelegate>

@property(nonatomic,strong) UIVisualEffectView *grayView;
@property(nonatomic,strong) ShareView *shareView;

@end

@implementation ShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.grayView];
    [self.view addSubview:self.shareView];
}

- (void)grayViewRemoveFromSuperView{
    [self dismissViewControllerAnimated:NO completion:nil];
}



- (void)shareToPlantForm:(UIButton *)btn{
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"sharelogo"]);
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title = @"这才是人类应该使用的考勤机";
    msg.link=@"https://hr.shangchao.la";
    msg.desc = @"方便员工打卡、方便HR统计汇总、方便老板任意部署，方便所有人!";
    msg.image = imageData;
    msg.thumbnail = imageData;
    if (btn == self.shareView.weiXinHaoYouBtn) {
        DLog(@"分享到微信好友");
        [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
            DLog(@"微信分享到好友成功：\n%@",message);
        } Fail:^(OSMessage *message, NSError *error) {
            DLog(@"微信分享到好友失败：\n%@",message);
        }];
    }
    if (btn == self.shareView.QQHaoYouBtn) {
        DLog(@"分享到QQ好友");
        [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
            DLog(@"QQ分享到好友成功：\n%@",message);
        } Fail:^(OSMessage *message, NSError *error) {
            DLog(@"QQ分享到好友失败：\n%@",message);
        }];
    }

    if (btn == self.shareView.emailBtn) {
        if(![MFMailComposeViewController canSendMail]){
            UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            [hud setMode:MBProgressHUDModeText];
            NSString *str = [NSString stringWithFormat:@"您的邮箱未配置"];
            hud.label.text = str;
            [hud hideAnimated:YES afterDelay:1.5];
        }else{
            MFMailComposeViewController *emailVC = [[MFMailComposeViewController alloc] init];
            [emailVC setSubject:@"这才是人类应该使用的考勤机"];
            [emailVC setMessageBody:@"方便员工打卡、方便HR统计汇总、方便老板任意部署，方便所有人! \n https://hr.shangchao.la" isHTML:NO];
            NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"sharelogo"]);
            [emailVC addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
            emailVC.mailComposeDelegate = self;
            [self presentViewController:emailVC animated:YES completion:^{
            }];
        }
    }
}

#pragma mark - 发邮件界面的代理方法 MFMailComposeViewControllerDelegate Method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultSent:
            DLog(@"邮件发送成功");
            break;
        case MFMailComposeResultSaved:
            DLog(@"邮件保存草稿");
            break;
        case MFMailComposeResultFailed:
            DLog(@"邮件发送失败");
            break;
        case MFMailComposeResultCancelled:
            DLog(@"邮件发送失败");
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


/**渐变透明毛玻璃*/
- (UIVisualEffectView *)grayView{
    if (_grayView == nil) {
        _grayView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _grayView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 242);
        _grayView.alpha = 0.6f;
        _grayView.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(grayViewRemoveFromSuperView)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [_grayView addGestureRecognizer:tapGesture];
    }
    return _grayView;
}

- (ShareView *)shareView{
    if (_shareView == nil) {
        _shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, screenHeight-242, screenWidth, 242)];
        _shareView.backgroundColor = [UIColor whiteColor];
        _shareView.alpha = 1.0f;
        [_shareView.weiXinHaoYouBtn addTarget:self action:@selector(shareToPlantForm:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView.QQHaoYouBtn addTarget:self action:@selector(shareToPlantForm:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView.emailBtn addTarget:self action:@selector(shareToPlantForm:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView.cancelBtn addTarget:self action:@selector(grayViewRemoveFromSuperView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareView;
}


@end
