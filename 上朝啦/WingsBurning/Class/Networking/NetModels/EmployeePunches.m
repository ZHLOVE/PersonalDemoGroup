//
//  EmployeePunches.m
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "EmployeePunches.h"

#import "MJExtension.h"

@implementation EmployeePunches

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSString *)imageHash{
    if (_imageHash == nil) {
        _imageHash = @"";
    }
    return _imageHash;
}

- (NSString *)wirelessAp{
    if (_wirelessAp == nil) {
        _wirelessAp = @"";
    }
    return _wirelessAp;
}

- (NSString *)operatingSystem{
    if (_operatingSystem == nil) {
        _operatingSystem = @"";
    }
    return _operatingSystem;
}

- (NSString *)phone_model{
    if (_phone_model == nil) {
        _phone_model = @"iPhone";
    }
    return _phone_model;
}

- (NSNumber *)longitude{
    if (_longitude == nil) {
        _longitude = 0;
    }
    return _longitude;
}

- (NSNumber *)latitude{
    if (_latitude == nil) {
        _latitude = 0;
    }
    return _latitude;
}



MJExtensionLogAllProperties

@end
