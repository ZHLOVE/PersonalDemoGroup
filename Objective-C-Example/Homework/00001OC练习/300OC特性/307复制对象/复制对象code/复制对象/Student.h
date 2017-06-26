//
//  Student.h
//  复制对象
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject<NSCopying>

@property (nonatomic,copy) NSString *stuId,*stuName;
@property (nonatomic,assign) int reward;

- (instancetype)initWithId:(NSString *)tmpId andName:(NSString *)n andReward:(int)r;

@end
