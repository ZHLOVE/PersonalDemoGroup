//
//  StudentModel.h
//  SaveData
//
//  Created by niit on 16/3/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString *stuId;
@property (nonatomic,copy) NSString *stuName;
@property (nonatomic,copy) NSString *stuAge;

- (instancetype)initWithId:(NSString *)tmpStuId andName:(NSString *)tmpStuName andAge:(NSString *)tmpStuAge;

@end
