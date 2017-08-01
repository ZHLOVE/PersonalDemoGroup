//
//  ShareCell.m
//  ShiJia
//
//  Created by 峰 on 2017/2/24.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "ShareCell.h"
//NSString * const kSJShareButtonViewIconKey  = @"SJShareItemViewIconKey";
//NSString * const kSJShareButtonViewTitleKey = @"SJShareItemViewTitleKey";
//NSString * const kUMSocialShareButtonSnsNameKey = @"UMSocialShareSnsNameKey";
@implementation ShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellmodelDict:(NSDictionary *)cellmodelDict{
    
    self.title.text = [cellmodelDict objectForKey:@"SJShareItemViewTitleKey"];
    self.iconImage.image = [UIImage imageNamed:[cellmodelDict objectForKey:@"SJShareItemViewIconKey"]];

}

@end
