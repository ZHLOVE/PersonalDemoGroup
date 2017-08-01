//
//  SJPhoneFarePayCell.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/6/23.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJPhoneFareViewModel.h"

@protocol SJPhoneFarePayCellDelegate <NSObject>
-(void)noticeLinkId:(NSString *)linkId;
-(void)payFinished;

@end
@interface SJPhoneFarePayCell : UITableViewCell
@property (nonatomic,strong) id <SJPhoneFarePayCellDelegate> m_delegate;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (weak, nonatomic) IBOutlet UITextField *codeNumber;
@property (assign, nonatomic) BOOL isCheck;

@property (nonatomic, strong) PayRequestParam *params1;

- (IBAction)getCodeAction:(id)sender;

@end
