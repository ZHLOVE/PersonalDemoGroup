//
//  Dog+CoreDataProperties.h
//  带狗狗散步
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dog (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSSet<Walk *> *walks;

@end

@interface Dog (CoreDataGeneratedAccessors)

- (void)addWalksObject:(Walk *)value;
- (void)removeWalksObject:(Walk *)value;
- (void)addWalks:(NSSet<Walk *> *)values;
- (void)removeWalks:(NSSet<Walk *> *)values;

@end

NS_ASSUME_NONNULL_END
