//
//  ContractM.h
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmployerM.h"

@interface ContractM : NSObject

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *employer_id;
@property(nonatomic,strong) EmployerM *employer;

@end
