//
//  PunchCameraVC.h
//  WingsBurning
//
//  Created by MBP on 16/9/5.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseViewController.h"

@interface PunchCameraVC : BaseViewController


/**替别人打卡时候用到*/
@property(nonatomic,strong) NSString *otherEmployeeID;

@property(nonatomic,strong) NSString *naviTitle;

/**单例*/
//+ (id)sharedInstance;

@end
