//
//  Student+CoreDataProperties.m
//  CoreData
//
//  Created by student on 16/4/14.
//  Copyright © 2016年 Five. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

@dynamic stuId;
@dynamic stuName;
@dynamic stuAge;
@dynamic stuClass;

- (NSString *)description{
    NSString *str = [NSString stringWithFormat:@"学号:%@ 姓名:%@ 年龄:%@ 班级:%@",self.stuId,self.stuName,self.stuAge,self.stuClass];
    return str;
}
@end
