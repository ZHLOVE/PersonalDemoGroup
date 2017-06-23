//
//  CATransitionViewController.m
//  Animations
//
//  Created by niit on 16/3/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "CATransitionViewController.h"

@interface CATransitionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,strong) NSArray *effects;// 效果数组
@end

@implementation CATransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *leftG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDo:)];
    leftG.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDo:)];
    rightG.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:leftG];
    [self.view addGestureRecognizer:rightG];
    
    
    self.effects =@[
               kCATransitionMoveIn,
               kCATransitionPush,
               kCATransitionReveal,
               @"cameraIris",
               @"cameraIrisHollowOpen",
               @"cameraIrisHollowClose",
               @"cube",
               @"alignedCube",
               @"flip",
               @"alignedFlip",
               @"oglFlip",
               @"rotate",
               @"pageCurl",
               @"pageUnCurl",
               @"rippleEffect",
               @"suckEffect",
               @"tubey",
               @"spewEffect",
               @"genieEffect",
               @"unGenieEffect",
               @"twist",
               @"swirl",
               @"charminUltra",
               @"reflection",
               @"zoomyIn",
               @"zoomyOut",
               @"mapCurl",
               @"mapUnCurl",
               @"oglApplicationSuspend"];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 280, 320, 80)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:30];
    label.tag = 101;
    [self.view addSubview:label];
}



- (void)swipeDo:(UISwipeGestureRecognizer *)g
{
    CATransition *anim = [CATransition animation];
    anim.duration = 1;
    
    NSString *effect = self.effects[arc4random_uniform(self.effects.count)];// 随机效果
    anim.type = effect;
    UILabel *label = [self.view viewWithTag:101];
    label.text = effect;

    static int i=1;
    if(g.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        i--;
        if(i<=0)
        {
            i=5;
        }
        
        anim.subtype = kCATransitionFromRight;
    }
    else
    {
        i++;
        if(i>5)
        {
            i=1;
        }
        anim.subtype = kCATransitionFromLeft;
    }

    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bike%i.jpg",i]];
    
    [self.imageView.layer addAnimation:anim forKey:nil];
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
