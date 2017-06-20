//
//  Grade.m
//  SafeDarkVC
//
//  Created by M on 16/6/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "JYGrade.h"
#import "JYManager.h"
#import "UIImage+RGBAConv.h"
@implementation JYGrade


+ (NSDictionary *)getScore:(UIImage *)img{
    JYManager *j = [[JYManager alloc]init];
    [j renLianShu:img];
    [j jiSuanKuang];
    [j sheZhiTuPian:img];
    NSArray *scoreArr = [j daFeng];
    NSDictionary *scoreDict = @{@"光照充足":scoreArr[0],
                                @"光线均匀":scoreArr[1],
                                @"服装突出":scoreArr[2],
                                @"头部摆正":scoreArr[3]};
    return scoreDict;
}
@end
