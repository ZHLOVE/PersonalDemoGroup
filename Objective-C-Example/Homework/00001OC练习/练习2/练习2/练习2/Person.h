//
//  Person.h
//  练习2
//
//  Created by 马千里 on 16/3/12.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

@interface Person : NSObject<DogDelegate>

@property (nonatomic,weak) Dog *dog;

- (void)machineFeedTheDog;

- (void)feedTheDog;
@end
