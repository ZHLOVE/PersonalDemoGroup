//
//  TPIMNodeModel.m
//  HiTV
//
//  Created by yy on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPIMNodeModel.h"

@implementation TPIMNodeModel

- (instancetype)initWithElement:(DDXMLElement *)element
{
    self = [super init];
    if (self) {
        self.uid = [element attributeStringValueForName:@"uid"];
        self.jid = [element attributeStringValueForName:@"jid"];
        self.nickname = [element attributeStringValueForName:@"nickname"];
//        self.nickname = [[element attributeStringValueForName:@"nickname"] stringByRemovingPercentEncoding];
    }
    return self;
}

@end
