//
//  ChannelUnitModel.m
//  V1_Circle
//
//  Created by 刘瑞龙 on 15/11/10.
//  Copyright © 2015年 com.Dmeng. All rights reserved.
//

#import <objc/runtime.h>
#import "ChannelUnitModel.h"

@implementation ChannelUnitModel
- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.editAble = dict[@"editAble"];
        self.icon = dict[@"icon"];
        self.iconSpec = dict[@"iconSpec"];
        self.name = dict[@"name"];
        self.navigateId = dict[@"navigateId"];
        self.categoryId = dict[@"categoryId"];
        self.parentCategId = dict[@"parentCategId"];
        self.actionType = dict[@"actionType"];
        self.actionUrl = dict[@"actionUrl"];

    }
    return self;
}
/*-(NSString *)description{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < count; ++i) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *proName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:proName];
        
        [str appendFormat:@"<%@ : %@> \n", proName, value];
    }
    free(ivars);
    return str;
}*/
@end
