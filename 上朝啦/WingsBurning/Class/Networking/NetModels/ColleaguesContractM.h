//
//  ColleaguesContractM.h
//  WingsBurning
//
//  Created by MBP on 16/9/13.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmployeeM.h"

@interface ColleaguesContractM : NSObject

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *employer_id;

@property(nonatomic,strong) EmployeeM *employee;

@end
