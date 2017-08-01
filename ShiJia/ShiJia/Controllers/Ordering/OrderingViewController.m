//
//  OrderingViewController.m
//  
//
//  Created by 蒋海量 on 16/5/9.
//
//

#import "OrderingViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>


@interface OrderingViewController ()<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>

@end

@implementation OrderingViewController

    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(232, 233, 232, 1);
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, W, H)];
    scrollView.backgroundColor = [UIColor clearColor];
    // 是否支持滑动最顶端
    scrollView.scrollsToTop = NO;
    // 设置内容大小
    scrollView.userInteractionEnabled = YES;
    scrollView.contentSize = CGSizeMake(300, 534);
    [self.view addSubview:scrollView];
    
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake((W-300)/2, 20, 300, 404)];
    [bg setImage:[UIImage imageNamed:@"组-1.png"]];
    bg.userInteractionEnabled = YES;
    [scrollView addSubview:bg];

    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.backgroundColor = [UIColor clearColor];
    orderBtn.frame = CGRectMake(bg.frame.size.width/2-80, 75, 75, 24);
    [orderBtn setImage:[UIImage imageNamed:@"订购.png"] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(orderfiften:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:orderBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.frame = CGRectMake(bg.frame.size.width/2+5, 75, 75, 24);
    [cancelBtn setImage:[UIImage imageNamed:@"组-2.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelfiften:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:cancelBtn];

    UIButton *involvementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    involvementBtn.backgroundColor = [UIColor clearColor];
    involvementBtn.frame = CGRectMake(bg.frame.size.width/2-80, bg.frame.size.height-50, 75, 24);
    [involvementBtn setImage:[UIImage imageNamed:@"点击参与.png"] forState:UIControlStateNormal];
    [involvementBtn addTarget:self action:@selector(involvement:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:involvementBtn];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = NO;
}
-(void)viewWillLayoutSubviews{
   // self.view.frame = self.view.frame;
}
-(IBAction)orderTen:(id)sender{
    [self sendMsm:@"KTMBH10"];
}
-(IBAction)cancelTen:(id)sender{
    [self sendMsm:@"QXMBH10"];
}
-(IBAction)orderfiften:(id)sender{
    [self sendMsm:@"KTMBH15"];
}
-(IBAction)cancelfiften:(id)sender{
    [self sendMsm:@"QXMBH15"];
}

-(IBAction)involvement:(id)sender{
    [self sendMsm:@"KTTYJ15"];
}

    
-(void)sendMsm:(NSString *)content{
    if([MFMessageComposeViewController canSendText])
        
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];

        controller.recipients = @[@"10086"];
        controller.body = content;
        controller.messageComposeDelegate = self;
        
#if 1
        [self presentViewController:controller animated:YES completion:nil];
#else
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
#endif
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
// 短信处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
#if 1
    [self dismissViewControllerAnimated:YES completion:nil];
#else
    [[[[UIApplication sharedApplication].delegate window] rootViewController]  dismissViewControllerAnimated:YES completion:nil];
#endif
    [[[[UIApplication sharedApplication].delegate window] rootViewController]  dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled)
    {
        DDLogInfo(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent){
        DDLogInfo(@"Message sent");
    }
    else{
        DDLogInfo(@"Message failed");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
