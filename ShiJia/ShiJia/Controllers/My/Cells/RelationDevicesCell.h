//
//  RelationDevicesCell.h
//  HiTV
//
//  Created by 蒋海量 on 15/8/10.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiTVDeviceInfo.h"

@protocol RelationDevicesCellDelegate <NSObject>
- (void)removeDevice:(HiTVDeviceInfo *)entity;
- (void)updateDevice:(HiTVDeviceInfo *)entity;

@end
@interface RelationDevicesCell : UITableViewCell
@property (nonatomic,strong) id <RelationDevicesCellDelegate> m_delegate;
@property(nonatomic,weak) IBOutlet UILabel *nameLab;
@property(nonatomic,weak) IBOutlet UIButton *removeBtn;
@property(nonatomic,strong) HiTVDeviceInfo *entity;
@property(nonatomic,weak) IBOutlet UIImageView *chooseImg;
@property (weak, nonatomic) IBOutlet UILabel *defautLab;

@end
