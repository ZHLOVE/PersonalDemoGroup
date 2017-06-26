//
//  User.m
//  Weibo
//
//  Created by qiang on 5/4/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)userWithDict:(NSDictionary *)dict
{
    return [[[self class] alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"发帖人:%@ 头像地址:%@",self.name,self.profile_image_url];
}

- (void)setProfile_image_url:(NSString *)profile_image_url
{
    _profile_image_url = profile_image_url;
    self.imageURL = [NSURL URLWithString:profile_image_url];
}

- (void)setVerified_type:(int)verified_type
{
    _verified_type = verified_type;
    switch (verified_type)
    {
        case 0:
            self.verifiedImage = [UIImage imageNamed:@"avatar_vip"];
            break;
        case 2:
        case 3:
        case 5:
            self.verifiedImage = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case 220:
            self.verifiedImage = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            break;
    }
}

- (void)setMbrank:(int)mbrank
{
    _mbrank = mbrank;
    NSLog(@"等级 = %i",mbrank);
    if(mbrank!= 0)
    {
    self.mbrankImage = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%i",mbrank]];
    }
    else
    {
//        common_icon_membership_expired
        self.mbrankImage = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_expired"]] ;
    }
}

@end
