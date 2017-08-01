//
//  SJShareManager.m
//  ShiJia
//
//  Created by 峰 on 16/10/11.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJShareManager.h"


@implementation SJShareManager

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)shareObject:(SJShareMessage *)params{

    switch (params.platform) {
        case ShiJia: {
            /**
             *  暂时没有用到
             */
            [self shareObjectToSJFriend:params];
            break;
        }
        case WeChat: {
            [HiTVGlobals sharedInstance].shareWay = @"微信";
            [self shareObjectToWeChat:params];
            break;
        }
        case WeChatFriend: {
            [HiTVGlobals sharedInstance].shareWay = @"朋友圈";
            [self shareObjectToWeChatFriend:params];
            break;
        }
        case SinaWeiBo: {
            [self shareObjectToSinaWeiBo:params];
            break;
        }
        case Contact: {
            [self shareObjectToContact:params];
            break;
        }
    }
}

#pragma mark 分享到视加好友

-(void)shareObjectToSJFriend:(SJShareMessage *)params{


}


#pragma mark 分享到微信
-(void)shareObjectToWeChat:(SJShareMessage *)params{




    WXMediaMessage *message = [WXMediaMessage message];
    message.title = params.messageTitle;
    message.description = params.messageContent;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:params.messageThumbImageUrl]];

    if (data.length >32*1024) {
          UIImage *image = [self scaleFromImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(60, 60)];
          [message setThumbImage:image];

    }else{

        [message setThumbImage:data.length==0?[UIImage imageNamed:@"dpgmdefault"]:[UIImage imageWithData:data]];
    }
    //用于推荐有礼分享
    if (params.messageThumbImage) {
        [message setThumbImage:params.messageThumbImage];
    }

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = params.messageSourceLink;
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

#pragma mark 分享到朋友圈

-(void)shareObjectToWeChatFriend:(SJShareMessage *)params{

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = params.messageTitle;
    message.description = params.messageContent;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:params.messageThumbImageUrl]];
    if (data.length >32*1024) {
        UIImage *image = [self scaleFromImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(60, 60)];
        [message setThumbImage:image];

    }else{
        [message setThumbImage:data.length==0?[UIImage imageNamed:@"dpgmdefault"]:[UIImage imageWithData:data]];
    }
    //用于推荐有礼分享
    if (params.messageThumbImage) {
        [message setThumbImage:params.messageThumbImage];
    }
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = params.messageSourceLink;
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}


#pragma mark  分享到新浪

-(void)shareObjectToSinaWeiBo:(SJShareMessage *)params{

    if ([WeiboSDK isWeiboAppInstalled]) {
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://sns.whalecloud.com/sina2/callback";
    authRequest.scope = @"all";

    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = params.messageTitle;
    webpage.description = params.messageContent;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:params.messageThumbImageUrl]];
    webpage.thumbnailData = data;
    if (data.length>1024*32) {
        UIImage *image = [self scaleFromImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(60, 60)];
        if (UIImagePNGRepresentation(image) == nil) {

            data = UIImageJPEGRepresentation(image, 1);

        } else {

            data = UIImagePNGRepresentation(image);
        }
          webpage.thumbnailData = data;
    }
    webpage.webpageUrl = [params.messageSourceLink stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    message.mediaObject = webpage;

    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    }else{

        //    // 未安装，app内分享
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = @"http://sns.whalecloud.com/sina2/callback";
            authRequest.scope = @"all";

            WBMessageObject *message = [WBMessageObject message];
            message.text = [NSString stringWithFormat:@"%@",[params.messageSourceLink stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:@"af3fa6d6066f6733ba9d4529ab416a1f"];
            request.userInfo = @{@"ShareMessageFrom": @"TPShareCenterViewController"};
            [WeiboSDK sendRequest:request];
            return;

    }
}


#pragma mark 分享到短信


-(void)shareObjectToContact:(SJShareMessage *)params{

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *activecontroller = [delegate.window visibleViewController];

    if( [MFMessageComposeViewController canSendText] ){

        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];

        NSString *message = [NSString stringWithFormat:@"%@%@",params.messageTitle,[params.messageSourceLink stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        controller.body = message;
        controller.messageComposeDelegate = self;
        controller.navigationBar.tintColor = [UIColor whiteColor];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:[NSString stringWithFormat:@"%@短信分享",CurrentAppName]];//修改短信界面标题
        [activecontroller presentViewController:controller animated:NO completion:^{
        [[controller navigationBar]setTintColor:kNavgationBarColor];
        }];

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //[dic setValue:@"常规视频" forKey:@"type"];
        [dic setValue:@"通讯录" forKey:@"share_way"];
        [dic setValue:[HiTVGlobals sharedInstance].shareType forKey:@"type"];
        [UMengManager event:@"U_Share" attributes:dic];
        
        [HiTVGlobals sharedInstance].shareType = nil;

    }else{

        [MBProgressHUD showError:@"设备没有短信功能" toView:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *activecontroller = [delegate.window visibleViewController];
    [activecontroller dismissViewControllerAnimated:YES completion:nil];
    
    NSString* str = [NSUserDefaultsManager getObjectForKey:LOG_SHARE_CONTENT];
    
    switch ( result ) {

        case MessageComposeResultCancelled: {
            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str, -1]];
            }
            [MBProgressHUD showError:@"取消分享" toView:nil];
        }
            break;
        case MessageComposeResultFailed: {// send failed
            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str, -1]];
            }
             [MBProgressHUD showError:@"发送失败" toView:nil];
        }
            break;
        case MessageComposeResultSent: {
            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str, 0]];
            }
            [MBProgressHUD showSuccess:@"分享成功" toView:nil];
            
        }
            break;
        default:
            break;
    }
    
    [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
}


- (UIImage*)scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;

    if (width <= newSize.width && height <= newSize.height){
        return image;
    }

    if (width == 0 || height == 0){
        return image;
    }

    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);

    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);

    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
