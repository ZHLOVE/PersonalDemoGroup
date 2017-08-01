//
//  SJAdView.m
//  ShiJia
//
//  Created by yy on 2017/5/18.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJAdView.h"
#import "HomeJumpWebViewController.h"
#import "UIImageView+WebCache.h"

static CGFloat kLabelLeftPadding = 10.0;
static CGFloat kLabelTopPadding = 10.0;
static CGFloat kLabelHeight = 20.0;
static CGFloat kImageLeftPadding = 0.0;
static CGFloat kImageTopPadding = 0.0;

@interface SJAdView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSString *actionUrlString;
@property (nonatomic, strong) NSString *title;

@end

@implementation SJAdView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupSubviews];
        [self loadAdRequest];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)text imageUrl:(NSString *)imgString actionUrl:(NSString *)actionString
{
    self = [super init];
    
    if (self) {
        
        self.titleLabel.text = text;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:[UIImage imageNamed:@"家庭电视@iphonex1"]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.frame = CGRectMake(kLabelLeftPadding,
                                       kLabelTopPadding,
                                       self.frame.size.width - kLabelLeftPadding * 2,
                                       kLabelHeight);
    
    CGFloat originy = kLabelHeight + kLabelTopPadding * 2 + kImageTopPadding;
    self.imgView.frame = CGRectMake(kImageLeftPadding,
                                    originy,
                                    self.frame.size.width - kImageLeftPadding * 2,
                                    self.frame.size.height - originy - kImageTopPadding);
    self.button.frame = self.imgView.frame;
    
}

#pragma mark - Subviews
- (void)setupSubviews
{
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.text = @"以下设备投屏效果更佳";
    [self addSubview:self.titleLabel];
    
    // image
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    self.imgView.image = [UIImage imageNamed:@"家庭电视@iphonex1"];
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"default_image"]];
    [self addSubview:self.imgView];
    
    // button
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor clearColor];
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];

}

#pragma mark - Event
- (void)buttonClicked:(id)sender
{
//    if (self.clickAdBlock) {
//        self.clickAdBlock();
//    }
    if (!self.activeController) {
        return;
    }
    HomeJumpWebViewController *webVC = [[HomeJumpWebViewController alloc] init];
    webVC.urlStr = self.actionUrlString;
    [self.activeController.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Request
- (void)loadAdRequest
{

    NSString* url = SHARE_SERVER;// shareServiceHost;
    
//    if (url == nil || url.length == 0) {
//         url = @"http://192.168.50.138:8080/share-facade/";
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
                NSString *actionKey = [dic objectForKey:@"actionKey"];
                if ([actionKey isEqualToString:@"x3Config3"]) {
                    
                    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"家庭电视@iphonex1"]];
                    self.actionUrlString = [dic objectForKey:@"actionUrl"];
                    break;
                }
            }
                
            
            
        } else {
            
        }

        
    } failure:^(NSString *error) {
        
    }];
}
@end
