//
//  PresidentDetail.h
//  11402PresidentList
//
//  Created by student on 16/3/10.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresidentDetail : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,copy) NSString *webUrl;

@property (nonatomic,strong) UIPopoverController *popVC;

@end
