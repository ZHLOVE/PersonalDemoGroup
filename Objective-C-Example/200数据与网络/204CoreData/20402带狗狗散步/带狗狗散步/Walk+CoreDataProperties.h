//
//  Walk+CoreDataProperties.h
//  带狗狗散步
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Walk.h"

NS_ASSUME_NONNULL_BEGIN

@interface Walk (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSManagedObject *dog;

@end

NS_ASSUME_NONNULL_END
