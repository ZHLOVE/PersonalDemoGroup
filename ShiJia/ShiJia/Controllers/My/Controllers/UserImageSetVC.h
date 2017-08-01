//
//  UserImageSetVC.h
//  HiTV
//
//  Created by wesley on 15/8/2.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "JKImagePickerController.h"

@interface UserImageSetVC : BaseViewController<UIImagePickerControllerDelegate,JKImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (assign,nonatomic) NSInteger fromUserDetail;

@end
