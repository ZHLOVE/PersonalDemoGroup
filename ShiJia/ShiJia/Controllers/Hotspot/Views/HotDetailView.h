//
//  HotDetailView.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/24.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotDetailView : UIView
@property (weak, nonatomic)  IBOutlet UIImageView *posterImg;
@property (weak, nonatomic)  IBOutlet UILabel *titleLab;
@property (weak, nonatomic)  IBOutlet UIButton *continuBtn;

@property (strong, nonatomic)  NSString *tipString;

@property (nonatomic, copy) void(^didClickButtonAtIndex)(NSInteger index);

@end
