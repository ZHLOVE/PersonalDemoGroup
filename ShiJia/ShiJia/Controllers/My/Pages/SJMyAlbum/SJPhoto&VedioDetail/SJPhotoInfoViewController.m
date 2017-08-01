//
//  SJPhotoInfoViewController.m
//  ShiJia
//
//  Created by 峰 on 16/9/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPhotoInfoViewController.h"
#import "SJAlbumNetWork.h"
#import "UIImageView+WebCache.h"

@interface SJPhotoInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *phtotOwnerImage;
@property (weak, nonatomic) IBOutlet UILabel     *photoUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *photoFromLabel;
@property (weak, nonatomic) IBOutlet UIButton    *photoTime;
@end

@implementation SJPhotoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setCloudModel:(CloudPhotoModel *)cloudModel{
        if ([cloudModel.source isEqualToString:@"APP"]) {
            self.photoFromLabel.text = @"手机上传";
        }
        if ([cloudModel.source isEqualToString:@"TV"]) {
            self.photoFromLabel.text = @"电视上传";
        }
        if ([cloudModel.source isEqualToString:@"WECHAT"]) {
            self.photoFromLabel.text = @"微信上传";
        }
    self.photoUserNameLabel.text = cloudModel.uploadNickName;
    [self.phtotOwnerImage sd_setImageWithURL:[NSURL URLWithString:cloudModel.faceImg] placeholderImage:[UIImage imageNamed:@"default_head"]];
        [self.photoTime setTitle:cloudModel.createTime forState:UIControlStateNormal];
        //    [self.phtotOwnerImage.layer masksToBounds];
        self.phtotOwnerImage.layer.masksToBounds = YES;

}

@end
