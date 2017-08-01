//
//  RelationDevicesCell.m
//  HiTV
//
//  Created by 蒋海量 on 15/8/10.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "RelationDevicesCell.h"
@interface RelationDevicesCell()

@end
@implementation RelationDevicesCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.defautLab.textColor = klightGrayColor;

}
-(IBAction)removeDevice:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"删除后将退出该家庭，家庭相册也无法查看" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定删除", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.m_delegate) {
            [self p_requestGetDefaultDevice];
            // [self.m_delegate removeDevice:self.entity];
        }
    }
}
-(IBAction)updateDevice:(id)sender{
    if (self.m_delegate) {
        [self.m_delegate updateDevice:self.entity];
    }
}
- (void)p_requestGetDefaultDevice{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/userservice/taipan/findDevice" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        BOOL Default = NO;
        int code = [[resultDic objectForKey:@"code"] intValue];
        if (code == 0) {
            NSArray *userlist = [resultDic objectForKey:@"userList"];
            if (userlist.count>0) {
                NSDictionary *userDic = [userlist objectAtIndex:0];
                NSString *defaultUid = [userDic objectForKey:@"uid"];
                if ([defaultUid intValue] == [[HiTVGlobals sharedInstance].uid intValue]) {
                    Default = YES;
                }
            }
        }
        if (Default) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"默认用户无法解绑" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
             [self.m_delegate removeDevice:self.entity];
        }

    }failure:^(NSString *error) {
        [self.m_delegate removeDevice:self.entity];
    }];

    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
